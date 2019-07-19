//
//  CATAccountService.h
//  CatAccounting
//
//  Created by ran on 2017/9/12.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CATAccount.h"
#import "CATBillFeed.h"
#import "CATCategoryDataSet.h"

typedef void (^CATMonthDataBlock)(NSArray<CATBillDayFeed *> *feeds);
typedef void (^CATCategoryMonthDataBlock)(NSArray<CATBillDayFeed *> *feeds, double total, float percent);
typedef void (^CATCategoryDataSetBlock)(NSArray<CATCategoryDataSet *> *dataSets, double total);
typedef void (^CATFundAccountDataSetBlock)(NSArray<CATFundAccount *> *dataSets);

typedef NS_ENUM(NSInteger, CATAccountDataType) {
    CATAccountDataType_All = 0,
    CATAccountDataType_Outcome,
    CATAccountDataType_Income
};

@interface CATAccountService : NSObject

+ (instancetype)service;

- (BOOL)addAccount:(CATAccount *)account;
- (BOOL)updateAccount:(CATAccount *)account;
- (BOOL)removeAccount:(CATAccount *)account;

/// bill list feeds
- (void)fetchMonthFeedsWithYear:(NSInteger)year month:(NSInteger)month completion:(CATMonthDataBlock)callback;
/// category detail feeds
- (void)fetchMonthOutcomeFeedsWithYear:(NSInteger)year month:(NSInteger)month category:(NSString *)categoryName completion:(CATCategoryMonthDataBlock)callback;
/// category data (pie chart)
- (void)fetchOutCategoryAccountsWithYear:(NSInteger)year month:(NSInteger)month completion:(CATCategoryDataSetBlock)callback;
/// fund account data (h-bar chart)
- (void)fetchFundAccountsWithYear:(NSInteger)year month:(NSInteger)month completion:(CATFundAccountDataSetBlock)callback;

// caculate methods
- (double)cat_sumWithYear:(NSInteger)year month:(NSInteger)month cate:(NSString *)cateName fundType:(NSString *)fundName type:(CATAccountDataType)dataType;
- (void)caculateFeeds:(NSArray<CATBillDayFeed *> *)feeds totalExp:(NSString **)exp totalInc:(NSString **)inc;

@end
