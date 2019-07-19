//
//  CATDateBrowserBar.m
//  CatAccounting
//
//  Created by ran on 2017/9/28.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATDateBrowserBar.h"

#define kDateLWidth     110
#define kDateLHeight    22

@implementation CATDateBrowserBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.height < 30) {
        frame.size.height = 30;
    }
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorClear;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kDateLWidth);
        make.height.mas_equalTo(kDateLHeight);
        make.center.mas_equalTo(self);
    }];
    
    [self addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(26);
        make.right.mas_equalTo(self.dateLabel.mas_left).mas_offset(-3);
        make.centerY.mas_equalTo(self.dateLabel);
    }];
    
    [self addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(26);
        make.left.mas_equalTo(self.dateLabel.mas_right).mas_offset(3);
        make.centerY.mas_equalTo(self.dateLabel);
    }];
}

- (UILabel *)dateLabel {
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK);
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = UIFontMake(15.0f);
    }
    return _dateLabel;
}

- (UIButton *)leftBtn {
    if (_leftBtn == nil) {
        _leftBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setImage:UIImageMake(@"icon_arrow_left") forState:UIControlStateNormal];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (_rightBtn == nil) {
        _rightBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:UIImageMake(@"icon_arrow_right") forState:UIControlStateNormal];
    }
    return _rightBtn;
}

@end
