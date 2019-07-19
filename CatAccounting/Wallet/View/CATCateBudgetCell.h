//
//  CATCateBudgetCell.h
//  CatAccounting
//
//  Created by ran on 2017/10/26.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

#define kCateBudgetHeight 75

@class CATBudget;
@interface CATCateBudgetCell : QMUITableViewCell

- (void)bindBudget:(CATBudget *)budget;

@end
