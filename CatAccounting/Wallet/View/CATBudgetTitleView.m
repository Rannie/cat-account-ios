//
//  CATBudgetTitleView.m
//  CatAccounting
//
//  Created by ran on 2017/10/24.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATBudgetTitleView.h"

@implementation CATBudgetTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorMakeWithHex(@"#f5f5f5");
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(CAT_MARGIN);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFont:UIFontMake(12.0f) textColor:UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK)];
    }
    return _titleLabel;
}

@end
