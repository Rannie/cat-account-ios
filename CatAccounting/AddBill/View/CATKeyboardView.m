//
//  CATKeyboardView.m
//  CatAccounting
//
//  Created by ran on 2017/9/13.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATKeyboardView.h"

typedef NS_ENUM(NSInteger, KeyType) {
    KeyTypeDot = 10,
    KeyTypeZero = 11,
    KeyTypeClear = 12,
    KeyTypeBackspace = 13,
    KeyTypeReturn = 14
};

@interface CATKeyboardView ()

@end

@implementation CATKeyboardView

+ (instancetype)keyboardView {
    return [[CATKeyboardView alloc] initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, SCREEN_WIDTH, kKeyboardViewHeight)];
    if (self) {
        self.backgroundColor = UIColorWhite;
        
        CGFloat itemW = SCREEN_WIDTH/4.0f;
        CGFloat itemH = kKeyboardViewHeight/4.0f;
        
        for (NSInteger i = 1; i < 13; i++) {
            QMUIButton *btn = [QMUIButton buttonWithType:UIButtonTypeCustom];
            
            NSInteger col = (i-1)%3;
            NSInteger row = (i-1)/3;
            btn.frame = CGRectMake(col*itemW, row*itemH, itemW, itemH);
            NSString *title;
            if (i < 10) {
                title = [NSString stringWithFormat:@"%zd", i];
            } else if (i == KeyTypeDot) {
                title = @".";
            } else if (i == KeyTypeZero) {
                title = @"0";
            } else if (i == KeyTypeClear) {
                title = @"C";
            }
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:UIColorMakeWithHex(CAT_THEME_COLOR) forState:UIControlStateNormal];
            [btn setHighlightedBackgroundColor:UIColorMakeWithHex(CAT_THEME_COLOR_LIGHTEN5)];
            btn.titleLabel.font = UIFontMake(23);
            btn.tag = i;
            [btn addTarget:self action:@selector(onKeyboardButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        
        QMUIButton *backBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(SCREEN_WIDTH-itemW, 0, itemW, itemH*2);
        backBtn.tag = KeyTypeBackspace;
        [backBtn setImage:CATThemeImageMake(@"keyboard_backspace") forState:UIControlStateNormal];
        [backBtn setHighlightedBackgroundColor:UIColorMakeWithHex(CAT_THEME_COLOR_LIGHTEN5)];
        [backBtn addTarget:self action:@selector(onKeyboardButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        QMUIButton *returnBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        returnBtn.frame = CGRectMake(SCREEN_WIDTH-itemW, itemH*2, itemW, itemH*2);
        returnBtn.tag = KeyTypeReturn;
        [returnBtn addTarget:self action:@selector(onKeyboardButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [returnBtn setBackgroundColor:UIColorMakeWithHex(CAT_THEME_COLOR)];
        [returnBtn setTitle:@"完成" forState:UIControlStateNormal];
        [returnBtn setTitleColor:UIColorWhite forState:UIControlStateNormal];
        returnBtn.titleLabel.font = UIFontMake(20);
        [self addSubview:returnBtn];
        
        for (NSInteger i = 0; i < 5; i++) {
            CGFloat lineW;
            if (i == 0 || i == 4) {
                lineW = SCREEN_WIDTH;
            } else {
                lineW = SCREEN_WIDTH - itemW;
            }
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = UIColorSeparator;
            line.frame = CGRectMake(0, i*itemH, lineW, CATOnePixel);
            [self addSubview:line];
        }
        
        for (NSInteger i = 0; i < 3; i++) {
            UIView *sep = [[UIView alloc] init];
            sep.backgroundColor = UIColorSeparator;
            sep.frame = CGRectMake((i+1)*itemW, 0, CATOnePixel, kKeyboardViewHeight);
            [self addSubview:sep];
        }
    }
    return self;
}

- (void)onKeyboardButtonClicked:(UIButton *)sender {
    if (sender.tag < KeyTypeDot)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardViewDidClickNumber:)]) {
            [self.delegate keyboardViewDidClickNumber:[NSString stringWithFormat:@"%zd", sender.tag]];
        }
    }
    else if (sender.tag == KeyTypeDot)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardViewDidClickDot)]) {
            [self.delegate keyboardViewDidClickDot];
        }
    }
    else if (sender.tag == KeyTypeZero)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardViewDidClickNumber:)]) {
            [self.delegate keyboardViewDidClickNumber:@"0"];
        }
    }
    else if (sender.tag == KeyTypeClear)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardViewDidClickClear)]) {
            [self.delegate keyboardViewDidClickClear];
        }
    }
    else if (sender.tag == KeyTypeBackspace)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardViewDidClickBackspace)]) {
            [self.delegate keyboardViewDidClickBackspace];
        }
    }
    else // Return
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardViewDidClickReturn)]) {
            [self.delegate keyboardViewDidClickReturn];
        }
    }
}

@end
