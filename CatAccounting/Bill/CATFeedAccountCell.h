//
//  CATFeedAccountCell.h
//  CatAccounting
//
//  Created by ran on 2017/9/20.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>
#import "CATCategoryIconView.h"

@interface CATFeedAccountCell : QMUITableViewCell

@property (nonatomic, strong) CATCategoryIconView *categoryIcon;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *remarkLabel;

- (void)showBottomLine;

@end
