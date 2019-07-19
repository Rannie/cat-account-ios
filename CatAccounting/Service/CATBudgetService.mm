//
//  CATBudgetService.m
//  CatAccounting
//
//  Created by ran on 2017/10/23.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATBudgetService.h"
#import <WCDB/WCDB.h>
#import "CATBudget+WCTTableCoding.h"
#import "CATDBManager.h"
#import "CATCategoryService.h"
#import "CATAccountService.h"

static NSString * const kCATAutoFollowBudgetKey = @"kCATAutoFollowBudgetKey";

@interface CATBudgetService ()
@property (nonatomic, strong) WCTDatabase *db;
@end

@implementation CATBudgetService

+ (instancetype)service {
    static dispatch_once_t onceToken;
    static CATBudgetService *service;
    dispatch_once(&onceToken, ^{
        service = [[CATBudgetService alloc] initService];
    });
    return service;
}

- (instancetype)initService {
    self = [super init];
    if (self) {
        _db = DBManager.database;
        [_db createTableAndIndexesOfName:self.tableName withClass:CATBudget.class];
    }
    return self;
}

- (void)setAutoFollowLastBudget:(BOOL)autoFollowLastBudget {
    [KeyValueStore setBool:autoFollowLastBudget forKey:kCATAutoFollowBudgetKey];
}

- (BOOL)autoFollowLastBudget {
    return [KeyValueStore boolForKey:kCATAutoFollowBudgetKey defaultValue:NO];
}

- (BOOL)addBudget:(CATBudget *)budget {
    NSParameterAssert(budget);
    budget.isAutoIncrement = YES;
    BOOL res = [self.db insertObject:budget into:self.tableName];
    return res;
}

- (BOOL)updateBudget:(CATBudget *)budget {
    NSParameterAssert(budget);
    BOOL res = [self.db updateRowsInTable:self.tableName
                             onProperties:CATBudget.AllProperties
                               withObject:budget
                                    where:CATBudget.budgetId == budget.budgetId];
    return res;
}

- (CATLastBudgetStatus)getLastBudgetStatus {
    NSDate *cur = [NSDate date];
    NSInteger lastYear;NSInteger lastMonth;
    [CATUtil getPrevMonthWithCurYear:cur.year month:cur.month prevYear:&lastYear prevMonth:&lastMonth];
    NSInteger budgetCount = [[self.db getOneValueOnResult:CATBudget.budgetId.count()
                                                fromTable:self.tableName
                                                    where:CATBudget.year == lastYear && CATBudget.month == lastMonth] integerValue];
    if (budgetCount == 0)
    {
        return CATLastBudgetStatusNone;
    }
    else
    {
        CATBudget *monthBudget = [self fetchMonthBudgetWithYear:lastYear month:lastMonth];
        NSArray *cateBudgets = [self.db getObjectsOfClass:CATBudget.class
                                                fromTable:self.tableName
                                                    where:CATBudget.year == lastYear && CATBudget.month == lastMonth && CATBudget.type == CATBudgetTypeCategory && CATBudget.budgetAmount != nil];
        if (CATIsEmptyArray(cateBudgets) && CATIsEmptyString(monthBudget.budgetAmount)) {
            return CATLastBudgetStatusUnSet;
        } else {
            return CATLastBudgetStatusSeted;
        }
    }
}

- (CATBudget *)fetchMonthBudgetWithYear:(NSInteger)year month:(NSInteger)month {
    CATBudget *budget = [self.db getOneObjectOfClass:CATBudget.class
                                           fromTable:self.tableName
                                               where:CATBudget.year == year && CATBudget.month == month && CATBudget.type == CATBudgetTypeMonth];
    return budget;
}

- (void)fetchAllBudgetsWithYear:(NSInteger)year month:(NSInteger)month completion:(CATBudegetDataBlock)callback {
    NSInteger budgetCount = [[self.db getOneValueOnResult:CATBudget.budgetId.count()
                                                fromTable:self.tableName
                                                    where:CATBudget.year == year && CATBudget.month == month] integerValue];
    if (budgetCount == 0) {
        CATLog(@"fake cur month budgets");
        CATLastBudgetStatus status = [self getLastBudgetStatus];
        if (self.autoFollowLastBudget && status == CATLastBudgetStatusSeted) {
            [self fakeBudgetsWithYear:year month:month];
            [self followLastBudgetsWithCurYear:year month:month];
        } else {
            [self fakeBudgetsWithYear:year month:month];
        }
    }
    
    // fake custom add category budget
    [self fakeCustomCategoryBudgetsWithYear:year month:month];
    
    CATBudget *monthBudget = [self fetchMonthBudgetWithYear:year month:month];
    [self caculateBudgetData:monthBudget];
    NSArray *cateBudgets = [self.db getObjectsOfClass:CATBudget.class
                                                 fromTable:self.tableName
                                                     where:CATBudget.year == year && CATBudget.month == month && CATBudget.type == CATBudgetTypeCategory];
    NSMutableArray *setedList = [NSMutableArray array];
    NSMutableArray *unsetList = [NSMutableArray array];
    [cateBudgets enumerateObjectsUsingBlock:^(CATBudget * _Nonnull budget, NSUInteger idx, BOOL * _Nonnull stop) {
        budget.assCategory = [[CATCategoryService service] queryCategoryWithName:budget.categoryName income:NO];
        [self caculateBudgetData:budget];
        
        if (!CATIsEmptyString(budget.budgetAmount))
            [setedList addObject:budget];
        else
            [unsetList addObject:budget];
    }];
    
    if (monthBudget.budgetAmount) {
        double setedSum = [self getSumWithBudgets:setedList];
        NSDecimalNumber *monthAmount = [NSDecimalNumber decimalNumberWithString:monthBudget.budgetAmount];
        NSDecimalNumber *cateSum = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", setedSum]];
        NSDecimalNumber *unset = [monthAmount decimalNumberBySubtracting:cateSum];
        monthBudget.unsetBudgetAmount = [unset stringValue];
    }
    
    if (callback) {
        callback(monthBudget, [setedList copy], [unsetList copy]);
    }
}

- (void)followLastBudgetsWithCurYear:(NSInteger)year month:(NSInteger)month {
    NSInteger lastYear;NSInteger lastMonth;
    [CATUtil getPrevMonthWithCurYear:year month:month prevYear:&lastYear prevMonth:&lastMonth];
    NSArray<CATBudget *> *allBudgets = [self.db getObjectsOfClass:CATBudget.class
                                                        fromTable:self.tableName
                                                            where:CATBudget.year == lastYear && CATBudget.month == lastMonth];
    
    [allBudgets enumerateObjectsUsingBlock:^(CATBudget * _Nonnull budget, NSUInteger idx, BOOL * _Nonnull stop) {
        WCTValue *budgetValue = budget.budgetAmount?:[NSNull null];
        if (budget.type == CATBudgetTypeMonth) {
            [self.db updateRowsInTable:self.tableName
                            onProperty:CATBudget.budgetAmount
                             withValue:budgetValue
                                 where:CATBudget.year == year && CATBudget.month == month && CATBudget.type == CATBudgetTypeMonth];
        } else {
            [self.db updateRowsInTable:self.tableName
                            onProperty:CATBudget.budgetAmount
                             withValue:budgetValue
                                 where:CATBudget.year == year && CATBudget.month == month && CATBudget.type == CATBudgetTypeCategory && CATBudget.categoryName == budget.categoryName];
        }
    }];
}

- (void)clearAllBudgetsWithYear:(NSInteger)year month:(NSInteger)month {
    [self.db updateRowsInTable:self.tableName
                    onProperty:CATBudget.budgetAmount
                     withValue:[NSNull null]
                         where:CATBudget.year == year && CATBudget.month == month];
}

- (void)caculateBudgetData:(CATBudget *)budget {
    @autoreleasepool {
        double cost = 0.0;
        if (budget.type == CATBudgetTypeMonth) {
            cost = [[CATAccountService service] cat_sumWithYear:budget.year month:budget.month cate:nil fundType:nil type:CATAccountDataType_Outcome];
            budget.unsetBudgetAmount = @"0";
        } else {
            cost = [[CATAccountService service] cat_sumWithYear:budget.year month:budget.month cate:budget.categoryName fundType:nil type:CATAccountDataType_Outcome];
        }
        budget.totalCost = [CATUtil formattedNumberString:@(cost)];
        
        if (!CATIsEmptyString(budget.budgetAmount)) {
            NSDecimalNumber *budgetNumber = [NSDecimalNumber decimalNumberWithString:budget.budgetAmount];
            NSDecimalNumber *costNumber = [NSDecimalNumber decimalNumberWithString:budget.totalCost];
            NSDecimalNumber *unusedNumber = [budgetNumber decimalNumberBySubtracting:costNumber];
            budget.unusedAmount = [unusedNumber stringValue];
        }
    }
}

- (void)fakeCustomCategoryBudgetsWithYear:(NSInteger)year month:(NSInteger)month {
    NSArray *customCates = [[CATCategoryService service] fetchCustomCategoriesWithIncome:NO];
    [customCates enumerateObjectsUsingBlock:^(CATCategory * _Nonnull cate, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *list = [self.db getObjectsOfClass:CATBudget.class
                                         fromTable:self.tableName
                                             where:CATBudget.categoryName == cate.name && CATBudget.year == year && CATBudget.month == month];
        if (CATIsEmptyArray(list)) {
            CATBudget *budget = [[CATBudget alloc] init];
            budget.isAutoIncrement = YES;
            budget.year = year;
            budget.month = month;
            budget.type = CATBudgetTypeCategory;
            budget.categoryName = cate.name;
            [self.db insertObject:budget into:self.tableName];
        }
    }];
}

- (void)fakeBudgetsWithYear:(NSInteger)year month:(NSInteger)month {
    CATBudget *monthBudget = [[CATBudget alloc] init];
    monthBudget.isAutoIncrement = YES;
    monthBudget.year = year;
    monthBudget.month = month;
    monthBudget.type = CATBudgetTypeMonth;
    [self.db insertObject:monthBudget into:self.tableName];
    
    NSArray *categories = [CATCategoryService service].outcomeCategoryList;
    NSMutableArray *cateList = [NSMutableArray array];
    [categories enumerateObjectsUsingBlock:^(CATCategory * _Nonnull category, NSUInteger idx, BOOL * _Nonnull stop) {
        CATBudget *budget = [[CATBudget alloc] init];
        budget.isAutoIncrement = YES;
        budget.year = year;
        budget.month = month;
        budget.type = CATBudgetTypeCategory;
        budget.categoryName = category.name;
        [cateList addObject:budget];
    }];
    [self.db insertObjects:cateList into:self.tableName];
}

- (double)getSumWithBudgets:(NSArray *)budgetList {
    __block NSDecimalNumber *sum = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    [budgetList enumerateObjectsUsingBlock:^(CATBudget * _Nonnull budget, NSUInteger idx, BOOL * _Nonnull stop) {
        if (budget.budgetAmount) {
            NSDecimalNumber *budgetAmount = [NSDecimalNumber decimalNumberWithString:budget.budgetAmount];
            sum = [sum decimalNumberByAdding:budgetAmount];
        }
    }];
    return [sum doubleValue];
}

- (NSString *)tableName {
    return @"budget";
}

@end
