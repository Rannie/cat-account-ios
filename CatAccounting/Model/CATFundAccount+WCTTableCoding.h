//
//  CATFundAccount+WCTTableCoding.h
//  CatAccounting
//
//  Created by ran on 2017/10/17.
//Copyright © 2017年 ran. All rights reserved.
//

#import "CATFundAccount+WCTTableCoding.h"
#import <WCDB/WCDB.h>

@interface CATFundAccount (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(fundAccName)
WCDB_PROPERTY(totalOutcome)
WCDB_PROPERTY(totalIncome)
WCDB_PROPERTY(totalAssets)

@end
