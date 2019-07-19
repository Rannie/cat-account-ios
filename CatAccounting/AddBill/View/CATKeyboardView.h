//
//  CATKeyboardView.h
//  CatAccounting
//
//  Created by ran on 2017/9/13.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kKeyboardViewHeight 240

@class CATKeyboardView;

@protocol CATKeyboardViewDelegate <NSObject>

- (void)keyboardViewDidClickNumber:(NSString *)number;
- (void)keyboardViewDidClickClear;
- (void)keyboardViewDidClickDot;
- (void)keyboardViewDidClickBackspace;
- (void)keyboardViewDidClickReturn;

@end

@interface CATKeyboardView : UIView

@property (nonatomic, weak) id<CATKeyboardViewDelegate> delegate;

+ (instancetype)keyboardView;

@end
