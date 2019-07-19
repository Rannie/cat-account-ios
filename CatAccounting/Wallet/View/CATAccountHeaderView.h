//
//  CATAccountHeaderView.h
//  CatAccounting
//
//  Created by ran on 2017/10/20.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHeaderViewHeight 100

@interface CATAccountHeaderView : UIView

@property (nonatomic, strong) NSString *incomeStr;
@property (nonatomic, strong) NSString *outcomeStr;
@property (nonatomic, strong) NSString *assetsStr;

- (void)refreshBackgroundColor;

@end
