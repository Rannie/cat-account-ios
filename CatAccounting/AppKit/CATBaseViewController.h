//
//  CATBaseViewController.h
//  CatAccounting
//
//  Created by ran on 2017/9/12.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

@interface CATBaseViewController : QMUICommonViewController

/// pop
- (void)back;
/// 解决 content scroll 和返回手势冲突
- (void)registerConflictGestureScroll:(UIScrollView *)scroll;

@end
