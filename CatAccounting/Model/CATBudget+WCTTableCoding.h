//
//  CATBudget+WCTTableCoding.h
//  CatAccounting
//
//  Created by ran on 2017/10/23.
//Copyright © 2017年 ran. All rights reserved.
//

#import "CATBudget+WCTTableCoding.h"
#import <WCDB/WCDB.h>

@interface CATBudget (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(budgetId)
WCDB_PROPERTY(year)
WCDB_PROPERTY(month)
WCDB_PROPERTY(type)
WCDB_PROPERTY(categoryName)
WCDB_PROPERTY(budgetAmount)

@end
