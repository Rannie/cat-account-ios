//
//  CATBudget.m
//  CatAccounting
//
//  Created by ran on 2017/10/23.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATBudget.h"
#import <WCDB/WCDB.h>

@interface CATBudget () <WCTTableCoding>

@end

@implementation CATBudget

WCDB_IMPLEMENTATION(CATBudget)

WCDB_SYNTHESIZE(CATBudget, budgetId)
WCDB_SYNTHESIZE(CATBudget, year)
WCDB_SYNTHESIZE(CATBudget, month)
WCDB_SYNTHESIZE(CATBudget, type)
WCDB_SYNTHESIZE(CATBudget, categoryName)
WCDB_SYNTHESIZE(CATBudget, budgetAmount)

WCDB_INDEX(CATBudget, "_timeIndex", year)
WCDB_INDEX(CATBudget, "_timeIndex", month)

WCDB_PRIMARY_AUTO_INCREMENT(CATBudget, budgetId)

+ (instancetype)fakeBudgetWithYear:(NSInteger)year month:(NSInteger)month type:(CATBudgetType)type {
    CATBudget *budget = [[CATBudget alloc] init];
    budget.year = year;
    budget.month = month;
    budget.type = type;
    return budget;
}

@end
