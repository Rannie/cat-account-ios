//
//  CATBudget.h
//  CatAccounting
//
//  Created by ran on 2017/10/23.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CATBudgetType) {
    CATBudgetTypeCategory = 0,
    CATBudgetTypeMonth
};

@class CATCategory;
@interface CATBudget : NSObject

@property (nonatomic, assign) NSInteger budgetId;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) CATBudgetType type;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *budgetAmount;

// non-store
@property (nonatomic, strong) NSString *totalCost;
@property (nonatomic, strong) NSString *unusedAmount;
@property (nonatomic, strong) NSString *unsetBudgetAmount;
@property (nonatomic, strong) CATCategory *assCategory;

+ (instancetype)fakeBudgetWithYear:(NSInteger)year month:(NSInteger)month type:(CATBudgetType)type;

@end
