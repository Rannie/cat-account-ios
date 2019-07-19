//
//  CATBudgetHeaderView.h
//  CatAccounting
//
//  Created by ran on 2017/10/24.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CATBudgetHeaderView;
@protocol CATBudgetHeaderViewDelegate <NSObject>

@required
- (void)budgetHeaderViewDidClickUseLastButton:(CATBudgetHeaderView *)headerView;
- (void)budgetHeaderViewDidClickClearButton:(CATBudgetHeaderView *)headerView;

@end

#define kBudgetHeaderViewHeight 120

@interface CATBudgetHeaderView : UIView

@property (nonatomic, weak) id<CATBudgetHeaderViewDelegate> delegate;
@property (nonatomic, strong) NSString *dateStr;

- (void)refreshThemeColor;

@end
