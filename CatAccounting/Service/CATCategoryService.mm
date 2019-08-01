//
//  CATCategoryService.m
//  CatAccounting
//
//  Created by ran on 2017/9/12.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATCategoryService.h"
#import "CATDBManager.h"
#import "CATCategory+WCTTableCoding.h"

static NSString * const kCategoryVersionKey = @"category_version";

@interface CATCategoryService ()

@property (nonatomic, strong) NSString *tableName;
@property (nonatomic, strong) WCTDatabase *db;
@property (nonatomic, strong) NSMutableArray *outList;
@property (nonatomic, strong) NSMutableArray *inList;
@property (nonatomic, strong) NSMutableDictionary *map;

@end

@implementation CATCategoryService

+ (instancetype)service {
    static dispatch_once_t onceToken;
    static CATCategoryService *instance;
    dispatch_once(&onceToken, ^{
        instance = [[CATCategoryService alloc] initService];
    });
    return instance;
}

- (instancetype)initService {
    self = [super init];
    if (self) {
        _outList = [NSMutableArray arrayWithCapacity:40];
        _inList = [NSMutableArray arrayWithCapacity:15];
        _map = [NSMutableDictionary dictionaryWithCapacity:50];
        
        _db = DBManager.database;
        [_db createTableAndIndexesOfName:self.tableName withClass:[CATCategory class]];
        [self setupCategories];
    }
    return self;
}

- (void)insertAllWithPlistDict:(NSDictionary *)dict {
    NSArray *list = dict[@"outcome_list"];
    [list enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        CATCategory *cate = [CATCategory yy_modelWithDictionary:dict];
        cate.isAutoIncrement = YES;
        if (cate) {
            [self.outList addObject:cate];
        }
    }];
    [self.db insertObjects:self.outList into:self.tableName];
    
    NSArray *ilist = dict[@"income_list"];
    [ilist enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        CATCategory *cate = [CATCategory yy_modelWithDictionary:dict];
        cate.isAutoIncrement = YES;
        if (cate) {
            [self.inList addObject:cate];
        }
    }];
    [self.db insertObjects:self.inList into:self.tableName];
}

- (void)setupCategories {
    BOOL haveCache = [[self.db getOneValueOnResult:CATCategory.categoryId.count()
                                         fromTable:self.tableName] unsignedIntegerValue] > 0;
    
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"Categories" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistFile];
    NSString *version = dict[@"version"];
    NSString *orderVersion = [KeyValueStore stringForKey:kCategoryVersionKey];
    
    if (!haveCache)
    {
        [self insertAllWithPlistDict:dict];
        DDLogInfo(@"[Category Service]: insert category data");
    }
    else if (!CATIsEqualString(version, orderVersion))
    {
        DDLogInfo(@"[Category Service]: update category data");
        if ([self isBetaVersion:orderVersion]) {
            [self.db deleteAllObjectsFromTable:self.tableName];
            [self insertAllWithPlistDict:dict];
        }
    }
    else
    {
        WCTSelect *oSel = [self.db prepareSelectObjectsOfClass:CATCategory.class fromTable:self.tableName];
        WCTSelect *select = [[oSel where:CATCategory.income == NO] orderBy:CATCategory.sortIndex.order(WCTOrderedAscending)];
        NSArray *res = select.allObjects;
        [self.outList addObjectsFromArray:res];
        
        WCTSelect *iSel = [self.db prepareSelectObjectsOfClass:CATCategory.class fromTable:self.tableName];
        WCTSelect *iSelect = [[iSel where:CATCategory.income == YES] orderBy:CATCategory.sortIndex.order(WCTOrderedAscending)];
        res = iSelect.allObjects;
        [self.inList addObjectsFromArray:res];
        DDLogInfo(@"[Category Service]: load category data from cache");
    }
    [KeyValueStore setString:version forKey:kCategoryVersionKey];
    
    // for query
    [self.outList enumerateObjectsUsingBlock:^(CATCategory *category, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *outKey = [NSString stringWithFormat:@"out_%@", category.name];
        self.map[outKey] = category;
    }];
    [self.inList enumerateObjectsUsingBlock:^(CATCategory *category, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *inKey = [NSString stringWithFormat:@"in_%@", category.name];
        self.map[inKey] = category;
    }];
}

- (void)addCustomCategoryWithName:(NSString *)name income:(BOOL)isIncome {
    CATCategory *newCate = [[CATCategory alloc] init];
    newCate.isAutoIncrement = YES;
    newCate.name = name;
    newCate.income = isIncome;
    newCate.iconName = @"cat_custom";
    newCate.builtin = NO;
    newCate.color = CAT_THEME_COLOR;
    NSInteger maxIndex = [[self.db getOneValueOnResult:CATCategory.sortIndex.max()
                                             fromTable:self.tableName
                                                 where:CATCategory.income == isIncome] integerValue];
    newCate.sortIndex = maxIndex+1;
    [self.db insertObject:newCate into:self.tableName];
    
    if (isIncome) {
        [self.inList addObject:newCate];
        NSString *inKey = [NSString stringWithFormat:@"in_%@", newCate.name];
        self.map[inKey] = newCate;
    } else {
        [self.outList addObject:newCate];
        NSString *outKey = [NSString stringWithFormat:@"out_%@", newCate.name];
        self.map[outKey] = newCate;
    }
}

- (NSArray<CATCategory *> *)fetchCustomCategoriesWithIncome:(BOOL)isIncome {
    NSArray *res;
    res = [self.db getObjectsOfClass:CATCategory.class
                           fromTable:self.tableName
                               where:CATCategory.income == isIncome && CATCategory.builtin == NO];
    return res;
}

- (CATCategory *)queryCategoryWithName:(NSString *)cateName income:(BOOL)isIncome {
    NSParameterAssert(cateName);
    NSString *key = [NSString stringWithFormat:@"%@_%@", isIncome?@"in":@"out", cateName];
    return self.map[key];
}

- (BOOL)isBetaVersion:(NSString *)version {
    float v = [version floatValue];
    return v < 1.6;
}

- (NSArray<CATCategory *> *)outcomeCategoryList {
    return [self.outList copy];
}

- (NSArray<CATCategory *> *)incomeCategoryList {
    return [self.inList copy];
}

- (NSString *)tableName {
    return @"category";
}

@end
