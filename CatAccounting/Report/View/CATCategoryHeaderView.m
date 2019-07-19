//
//  CATCategoryHeaderView.m
//  CatAccounting
//
//  Created by ran on 2017/10/12.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATCategoryHeaderView.h"

#define kLabelMargin 15
#define kLabelHeight 21

@implementation CATCategoryHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.totalLabel];
    [self addSubview:self.percentLabel];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.mas_equalTo(self);
        make.width.mas_equalTo(self).multipliedBy(0.5f);
        make.height.mas_equalTo(kLabelHeight);
    }];
    [self.percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.and.width.mas_equalTo(self.totalLabel);
        make.right.mas_equalTo(self);
    }];
}

- (UILabel *)totalLabel {
    if (_totalLabel == nil) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.font = UIFontMake(15.0f);
        _totalLabel.textColor = UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK_DARKEN);
        _totalLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalLabel;
}

- (UILabel *)percentLabel {
    if (_percentLabel == nil) {
        _percentLabel = [[UILabel alloc] init];
        _percentLabel.font = UIFontMake(15.0f);
        _percentLabel.textColor = UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK_DARKEN);
        _percentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _percentLabel;
}

@end
