//
//  CATBudgetService.h
//  CatAccounting
//
//  Created by ran on 2017/10/23.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CATBudget.h"

typedef NS_ENUM(NSInteger, CATLastBudgetStatus) {
    CATLastBudgetStatusNone = 0,
    CATLastBudgetStatusUnSet,
    CATLastBudgetStatusSeted
};

typedef void (^CATBudegetDataBlock)(CATBudget *monthBudget, NSArray<CATBudget *> *setBudgetList, NSArray<CATBudget *> *unsetBudgetList);

@interface CATBudgetService : NSObject

@property (nonatomic, assign) BOOL autoFollowLastBudget;

+ (instancetype)service;

- (BOOL)addBudget:(CATBudget *)budget;
- (BOOL)updateBudget:(CATBudget *)budget;

- (double)getSumWithBudgets:(NSArray *)budgetList;
- (CATLastBudgetStatus)getLastBudgetStatus;

- (void)fetchAllBudgetsWithYear:(NSInteger)year month:(NSInteger)month completion:(CATBudegetDataBlock)callback;
- (void)followLastBudgetsWithCurYear:(NSInteger)year month:(NSInteger)month;
- (void)clearAllBudgetsWithYear:(NSInteger)year month:(NSInteger)month;

@end
