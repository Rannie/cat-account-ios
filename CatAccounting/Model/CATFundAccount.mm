//
//  CATFundAccountDataSet.m
//  CatAccounting
//
//  Created by ran on 2017/10/12.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATFundAccount.h"
#import <WCDB/WCDB.h>

@implementation CATFundAccount

WCDB_IMPLEMENTATION(CATFundAccount)
WCDB_SYNTHESIZE(CATFundAccount, fundAccName)
WCDB_SYNTHESIZE(CATFundAccount, totalOutcome)
WCDB_SYNTHESIZE(CATFundAccount, totalIncome)
WCDB_SYNTHESIZE(CATFundAccount, totalAssets)

WCDB_PRIMARY(CATFundAccount, fundAccName)

- (void)setTotalOutcome:(double)totalOutcome {
    _totalOutcome = totalOutcome;
    [self caculateAssets];
}

- (void)setTotalIncome:(double)totalIncome {
    _totalIncome = totalIncome;
    [self caculateAssets];
}

- (void)caculateAssets {
    NSDecimalNumber *outcome = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", self.totalOutcome]];
    NSDecimalNumber *income = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", self.totalIncome]];
    NSDecimalNumber *assets = [income decimalNumberBySubtracting:outcome];
    self.totalAssets = [assets doubleValue];
}

@end
