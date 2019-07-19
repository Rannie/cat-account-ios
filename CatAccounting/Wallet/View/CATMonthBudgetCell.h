//
//  CATMonthBudgetCell.h
//  CatAccounting
//
//  Created by ran on 2017/10/26.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

#define kMonthBudgetHeight 92

@class CATBudget;
@interface CATMonthBudgetCell : QMUITableViewCell

- (void)bindMonthBudget:(CATBudget *)budget;

@end
