//
//  CATFundAccService.m
//  CatAccounting
//
//  Created by ran on 2017/10/17.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATFundAccService.h"
#import "CATFundAccount+WCTTableCoding.h"
#import "CATDBManager.h"

static NSString * const kCATDefaultFundAccountKey = @"kCATDefaultFundAccountKey";

@interface CATFundAccService ()
@property (nonatomic, strong) NSString *tableName;
@property (nonatomic, strong) WCTDatabase *db;
@property (nonatomic, strong) NSMutableDictionary *accMap;
@end

@implementation CATFundAccService

+ (instancetype)service {
    static dispatch_once_t onceToken;
    static CATFundAccService *service;
    dispatch_once(&onceToken, ^{
        service = [[CATFundAccService alloc] initService];
    });
    return service;
}

- (instancetype)initService {
    self = [super init];
    if (self) {
        _accMap = [NSMutableDictionary dictionaryWithCapacity:4];
        _db = DBManager.database;
        [_db createTableAndIndexesOfName:self.tableName withClass:[CATFundAccount class]];
        [self setupFundAccList];
    }
    return self;
}

- (void)setupFundAccList {
    BOOL haveCache = [[self.db getOneValueOnResult:CATFundAccount.fundAccName.count()
                                         fromTable:self.tableName] integerValue];
    if (!haveCache) { // insert builtin
        NSMutableArray *content = [NSMutableArray arrayWithCapacity:4];
        for (NSString *name in [CATFundAccService builtinList]) {
            CATFundAccount *fundAcc = [[CATFundAccount alloc] init];
            fundAcc.fundAccName = name;
            [content addObject:fundAcc];
        }
        [self.db insertObjects:content into:self.tableName];
        
        self.fundAccList = [content copy];
    } else {
        self.fundAccList = [self.db getAllObjectsOfClass:CATFundAccount.class fromTable:self.tableName];
    }
    
    [self.fundAccList enumerateObjectsUsingBlock:^(CATFundAccount * _Nonnull acc, NSUInteger idx, BOOL * _Nonnull stop) {
        self.accMap[acc.fundAccName] = acc;
        acc.assColor = self.accColors[idx];
        acc.iconName = self.icons[idx];
    }];
    
    NSString *defaultAccName = [KeyValueStore stringForKey:kCATDefaultFundAccountKey];
    if (defaultAccName) {
        self.defaultAccount = self.accMap[defaultAccName];
    } else {
        CATFundAccount *defaultAccount = [self.fundAccList firstObject];
        [self configDefaultAccountWithName:defaultAccount.fundAccName];
    }
}

- (void)configDefaultAccountWithName:(NSString *)accName {
    self.defaultAccount = self.accMap[accName];
    [KeyValueStore setString:accName forKey:kCATDefaultFundAccountKey];
}

- (NSArray *)fundNameList {
    NSMutableArray *nameList = [NSMutableArray arrayWithCapacity:self.fundAccList.count];
    [self.fundAccList enumerateObjectsUsingBlock:^(CATFundAccount * _Nonnull fundAcc, NSUInteger idx, BOOL * _Nonnull stop) {
        [nameList addObject:fundAcc.fundAccName];
    }];
    return [nameList copy];
}

- (void)outcome:(NSString *)outAmount inAccount:(NSString *)fundAccName {
    CATFundAccount *fundAcc = self.accMap[fundAccName];
    NSDecimalNumber *outNumber = [NSDecimalNumber decimalNumberWithString:outAmount];
    NSDecimalNumber *accNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", fundAcc.totalOutcome]];
    double sum = [[accNumber decimalNumberByAdding:outNumber] doubleValue];
    fundAcc.totalOutcome = sum;
    [self.db updateRowsInTable:self.tableName
                  onProperties:CATFundAccount.AllProperties
                    withObject:fundAcc
                         where:CATFundAccount.fundAccName == fundAccName];
}

- (void)income:(NSString *)income inAccount:(NSString *)fundAccName {
    CATFundAccount *fundAcc = self.accMap[fundAccName];
    NSDecimalNumber *inNumber = [NSDecimalNumber decimalNumberWithString:income];
    NSDecimalNumber *accNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", fundAcc.totalIncome]];
    double sum = [[accNumber decimalNumberByAdding:inNumber] doubleValue];
    fundAcc.totalIncome = sum;
    [self.db updateRowsInTable:self.tableName
                  onProperties:CATFundAccount.AllProperties
                    withObject:fundAcc
                         where:CATFundAccount.fundAccName == fundAccName];
}

- (void)reduceOutcome:(NSString *)outAmount inAccount:(NSString *)fundAccName {
    CATFundAccount *fundAcc = self.accMap[fundAccName];
    NSDecimalNumber *outNumber = [NSDecimalNumber decimalNumberWithString:outAmount];
    NSDecimalNumber *accNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", fundAcc.totalOutcome]];
    double sum = [[accNumber decimalNumberBySubtracting:outNumber] doubleValue];
    fundAcc.totalOutcome = sum;
    [self.db updateRowsInTable:self.tableName
                  onProperties:CATFundAccount.AllProperties
                    withObject:fundAcc
                         where:CATFundAccount.fundAccName == fundAccName];
}

- (void)reduceIncome:(NSString *)income inAccount:(NSString *)fundAccName {
    CATFundAccount *fundAcc = self.accMap[fundAccName];
    NSDecimalNumber *inNumber = [NSDecimalNumber decimalNumberWithString:income];
    NSDecimalNumber *accNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", fundAcc.totalIncome]];
    double sum = [[accNumber decimalNumberBySubtracting:inNumber] doubleValue];
    fundAcc.totalIncome = sum;
    [self.db updateRowsInTable:self.tableName
                  onProperties:CATFundAccount.AllProperties
                    withObject:fundAcc
                         where:CATFundAccount.fundAccName == fundAccName];
}

- (NSString *)tableName {
    return @"fund_account";
}

- (NSArray *)icons {
    return @[@"icon_cash", @"icon_deposit", @"icon_credit", @"icon_alipay"];
}

- (NSArray *)accColors {
    return @[UIColorMakeWithHex(@"#f06292"), UIColorMakeWithHex(@"#ffee58"), UIColorMakeWithHex(@"#66bb6a"), UIColorMakeWithHex(@"#4fc3f7")];
}

+ (NSArray *)builtinList {
    return @[@"现金", @"储蓄卡", @"信用卡", @"第三方账户"];
}

@end
