//
//  CATCategoryIconView.h
//  CatAccounting
//
//  Created by ran on 2017/9/13.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCategoryItemSize  40
#define kCategoryIconSize  36

typedef NS_ENUM(NSInteger, CategoryIconState) {
    CategoryIconStateNormal = 0,
    CategoryIconStateHighlight
};

@interface CATCategoryIconView : UIView

@property (nonatomic, assign) CategoryIconState state;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIColor *highlightColor;

@end
