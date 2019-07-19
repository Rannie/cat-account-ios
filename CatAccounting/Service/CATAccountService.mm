//
//  CATAccountService.m
//  CatAccounting
//
//  Created by ran on 2017/9/12.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATAccountService.h"
#import "CATAccount+WCTTableCoding.h"
#import "CATDBManager.h"
#import "CATCategoryService.h"
#import "CATFundAccService.h"

@interface CATAccountService ()
@property (nonatomic, strong) NSString *tableName;
@property (nonatomic, strong) WCTDatabase *db;
@end

@implementation CATAccountService

+ (instancetype)service {
    static dispatch_once_t onceToken;
    static CATAccountService *instance;
    dispatch_once(&onceToken, ^{
        instance = [[CATAccountService alloc] initService];
    });
    return instance;
}

- (instancetype)initService {
    self = [super init];
    if (self) {
        _db = DBManager.database;
        [_db createTableAndIndexesOfName:self.tableName withClass:[CATAccount class]];
    }
    return self;
}

- (BOOL)addAccount:(CATAccount *)account {
    NSParameterAssert(account);
    account.isAutoIncrement = YES;
    account.createTime = [NSDate timeIntervalSinceReferenceDate];
    account.modifyTime = account.createTime;
    BOOL res = [self.db insertObject:account into:self.tableName];
    
    if (account.type == CATAccountTypePay) {
        [[CATFundAccService service] outcome:account.amount inAccount:account.assFundAccount];
    } else {
        [[CATFundAccService service] income:account.amount inAccount:account.assFundAccount];
    }
    DDLogDebug(@"[AccountService]: insert bill(amount:%@, cate:%@, date:%@) res -- %zd", account.amount, account.categoryName, account.monthAndDayDes, res);
    return res;
}

- (BOOL)updateAccount:(CATAccount *)account {
    NSParameterAssert(account);
    CATAccount *oldAccount = [self.db getOneObjectOfClass:CATAccount.class fromTable:self.tableName where:CATAccount.accountId == account.accountId];
    [self removeAccount:oldAccount];
    CATAccount *newAccount = [account copy];
    newAccount.isAutoIncrement = YES;
    newAccount.modifyTime = [NSDate timeIntervalSinceReferenceDate];
    BOOL res = [self.db insertObject:newAccount into:self.tableName];
    
    if (account.type == CATAccountTypePay) {
        [[CATFundAccService service] outcome:account.amount inAccount:account.assFundAccount];
    } else {
        [[CATFundAccService service] income:account.amount inAccount:account.assFundAccount];
    }
    DDLogDebug(@"[AccountService]: update bill(amount:%@, cate:%@, date:%@) res -- %zd", account.amount, account.categoryName, account.monthAndDayDes, res);
    return res;
}

- (BOOL)removeAccount:(CATAccount *)account {
    NSParameterAssert(account);
    BOOL res = [self.db deleteObjectsFromTable:self.tableName
                                         where:CATAccount.accountId == account.accountId];
    
    if (account.type == CATAccountTypePay) {
        [[CATFundAccService service] reduceOutcome:account.amount inAccount:account.assFundAccount];
    } else {
        [[CATFundAccService service] reduceIncome:account.amount inAccount:account.assFundAccount];
    }
    DDLogDebug(@"[AccountService]: delete bill(amount:%@, cate:%@, date:%@) res -- %zd", account.amount, account.categoryName, account.monthAndDayDes, res);
    return res;
}

- (void)cat_fetchMonthFeedsWithYear:(NSInteger)year month:(NSInteger)month category:(NSString *)cateName dataType:(CATAccountDataType)dataType completion:(CATMonthDataBlock)callback {
    NSMutableArray *content = [NSMutableArray array];
    
    WCTSelect *objectSel = [self.db prepareSelectObjectsOfClass:CATAccount.class fromTable:self.tableName];
    WCTCondition condition = CATAccount.year == year && CATAccount.month == month;
    if (!CATIsEmptyString(cateName))
        condition = condition && CATAccount.categoryName == cateName;
    if (dataType) {
        NSInteger type = dataType == CATAccountDataType_Outcome?0:1;
        condition = condition && CATAccount.type == type;
    }
    WCTSelect *select = [[objectSel where:condition] orderBy:{CATAccount.day.order(WCTOrderedDescending), CATAccount.createTime.order(WCTOrderedDescending)}];
    NSArray *res = select.allObjects;
    
    __block CATBillDayFeed *curDayFeed;
    [res enumerateObjectsUsingBlock:^(CATAccount * _Nonnull account, NSUInteger idx, BOOL * _Nonnull stop) {
        if (curDayFeed == nil || curDayFeed.day != account.day) {
            curDayFeed = [[CATBillDayFeed alloc] init];
            curDayFeed.month = month;
            curDayFeed.day = account.day;
            [content addObject:curDayFeed];
        }
        
        account.category = [[CATCategoryService service] queryCategoryWithName:account.categoryName income:account.type];
        [curDayFeed addAccount:account];
    }];
    
    [content makeObjectsPerformSelector:@selector(caculateAccountDataAndSignLocation)];
    
    if (callback) {
        callback([content copy]);
    }
}

- (void)fetchMonthFeedsWithYear:(NSInteger)year month:(NSInteger)month completion:(CATMonthDataBlock)callback {
    [self cat_fetchMonthFeedsWithYear:year month:month category:nil dataType:CATAccountDataType_All completion:callback];
}

- (double)cat_sumWithYear:(NSInteger)year month:(NSInteger)month cate:(NSString *)cateName fundType:(NSString *)fundName type:(CATAccountDataType)dataType {
    WCTCondition condition = CATAccount.year == year && CATAccount.month == month;
    if (!CATIsEmptyString(cateName)) {
        condition = condition && CATAccount.categoryName == cateName;
    }
    if (fundName) {
        condition = condition && CATAccount.assFundAccount == fundName;
    }
    if (dataType) {
        NSInteger type = dataType == CATAccountDataType_Outcome ? 0:1;
        condition = condition && CATAccount.type == type;
    }
    NSNumber *sum = [self.db getOneValueOnResult:CATAccount.amount.sum()
                                       fromTable:self.tableName
                                           where:condition];
    return [sum doubleValue];
}

- (void)fetchMonthOutcomeFeedsWithYear:(NSInteger)year month:(NSInteger)month category:(NSString *)categoryName completion:(CATCategoryMonthDataBlock)callback {
    double sum = [self cat_sumWithYear:year month:month cate:categoryName fundType:nil type:CATAccountDataType_Outcome];
    double total_sum = [self cat_sumWithYear:year month:month cate:nil fundType:nil type:CATAccountDataType_Outcome];
    float percent = sum/total_sum;
    [self cat_fetchMonthFeedsWithYear:year month:month category:categoryName dataType:CATAccountDataType_Outcome completion:^(NSArray<CATBillDayFeed *> *feeds) {
        if (callback) {
            callback(feeds, sum, percent);
        }
    }];
}

- (void)fetchOutCategoryAccountsWithYear:(NSInteger)year month:(NSInteger)month completion:(CATCategoryDataSetBlock)callback {
    NSMutableDictionary *cateMap = [NSMutableDictionary dictionary];
    
    WCTCondition con = CATAccount.year == year && CATAccount.month == month && CATAccount.type == 0;
    NSArray *res = [self.db getObjectsOfClass:CATAccount.class
                                    fromTable:self.tableName
                                        where:con];
    [res enumerateObjectsUsingBlock:^(CATAccount * _Nonnull account, NSUInteger idx, BOOL * _Nonnull stop) {
        CATCategoryDataSet *dataSet = cateMap[account.categoryName];
        CATCategory *category = [[CATCategoryService service] queryCategoryWithName:account.categoryName income:account.type];
        if (!dataSet) {
            dataSet = [[CATCategoryDataSet alloc] init];
            dataSet.category = category;
            dataSet.year = year;
            dataSet.month = month;
            cateMap[account.categoryName] = dataSet;
        }
        
        [dataSet appendAccount:account];
    }];
    
    NSArray *dataSets = [cateMap allValues];
    [dataSets makeObjectsPerformSelector:@selector(caculateTotal)];
    dataSets = [dataSets sortedArrayUsingComparator:^NSComparisonResult(CATCategoryDataSet * _Nonnull obj1, CATCategoryDataSet * _Nonnull obj2) {
        if (obj1.totalCost > obj2.totalCost)
            return NSOrderedAscending;
        else
            return NSOrderedDescending;
    }];
    
    __block NSDecimalNumber *total = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    [dataSets enumerateObjectsUsingBlock:^(CATCategoryDataSet * _Nonnull dataSet, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDecimalNumber *cateTotal = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", dataSet.totalCost]];
        total = [total decimalNumberByAdding:cateTotal];
    }];
    for (CATCategoryDataSet *dataSet in dataSets) {
        [dataSet caculatePercent:[total doubleValue]];
    }
    
    if (callback) {
        callback(dataSets, [total doubleValue]);
    }
}

- (void)fetchFundAccountsWithYear:(NSInteger)year month:(NSInteger)month completion:(CATFundAccountDataSetBlock)callback {
    NSMutableArray *content = [NSMutableArray array];
    NSArray *fundAccList = [[CATFundAccService service] fundAccList];
    for (CATFundAccount *fundAcc in fundAccList) {
        fundAcc.curYear = year;
        fundAcc.curMonth = month;
        fundAcc.curOutcome = [self cat_sumWithYear:year month:month cate:nil fundType:fundAcc.fundAccName type:CATAccountDataType_Outcome];
        [content addObject:fundAcc];
    }
    
    if (callback) {
        callback([content copy]);
    }
}

- (void)caculateFeeds:(NSArray<CATBillDayFeed *> *)feeds totalExp:(NSString *__autoreleasing *)exp totalInc:(NSString *__autoreleasing *)inc {
    __block NSDecimalNumber *expNumber = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    __block NSDecimalNumber *incNumber = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    [feeds enumerateObjectsUsingBlock:^(CATBillDayFeed * _Nonnull dayFeed, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDecimalNumber *dayExp = [NSDecimalNumber decimalNumberWithString:dayFeed.exp];
        NSDecimalNumber *dayinc = [NSDecimalNumber decimalNumberWithString:dayFeed.inc];
        
        expNumber = [expNumber decimalNumberByAdding:dayExp];
        incNumber = [incNumber decimalNumberByAdding:dayinc];
    }];
    
    double expValue = [expNumber doubleValue];
    double incValue = [incNumber doubleValue];
    *exp = [NSString stringWithFormat:@"%.02f", expValue];
    *inc = [NSString stringWithFormat:@"%.02f", incValue];
}

- (NSString *)tableName {
    return @"account";
}

@end
