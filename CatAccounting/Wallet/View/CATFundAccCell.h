//
//  CATFundAccCell.h
//  CatAccounting
//
//  Created by ran on 2017/10/23.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

@class CATFundAccount;
@interface CATFundAccCell : QMUITableViewCell

- (void)bindFundAcc:(CATFundAccount *)fundAcc;

@end
