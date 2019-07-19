//
//  CATThemeCell.h
//  CatAccounting
//
//  Created by ran on 2017/11/1.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>
#import "CATThemeProtocol.h"

#define kThemeCellHeight 370

@interface CATThemeCell : QMUITableViewCell

- (void)bindTheme:(id<CATThemeProtocol>)theme;
- (void)setChecked:(BOOL)checked animated:(BOOL)animated;

@end
