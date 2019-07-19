//
//  CATTabBarItem.h
//  CatAccounting
//
//  Created by ran on 2017/10/16.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CATTabBarItem : UIView

@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, assign, readonly) NSInteger index;
@property (nonatomic, copy) dispatch_block_t selectedCallback;

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage index:(NSInteger)index;
- (void)refreshThemeColor;

@end
