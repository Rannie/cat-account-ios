//
//  CATFeedDayCell.m
//  CatAccounting
//
//  Created by ran on 2017/9/20.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATFeedDayView.h"

#define kDayLabelHeight 22
#define kDayLabelWidth  100

@implementation CATFeedDayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorMakeWithHex(@"#f5f5f5");
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.dayInfoLabel];
    [self addSubview:self.totalLabel];
    
    [self.dayInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kDayLabelWidth);
        make.left.mas_equalTo(self).mas_offset(CAT_MARGIN);
        make.height.mas_equalTo(kDayLabelHeight);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kDayLabelHeight);
        make.right.mas_equalTo(self).mas_offset(-CAT_MARGIN);
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.dayInfoLabel.mas_right).mas_offset(CAT_MARGIN);
    }];
}

- (UILabel *)dayInfoLabel {
    if (_dayInfoLabel == nil) {
        _dayInfoLabel = [[UILabel alloc] init];
        _dayInfoLabel.textColor = UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK);
        _dayInfoLabel.textAlignment = NSTextAlignmentLeft;
        _dayInfoLabel.font = UIFontMake(12.0f);
    }
    return _dayInfoLabel;
}

- (UILabel *)totalLabel {
    if (_totalLabel == nil) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.textColor = UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK);
        _totalLabel.textAlignment = NSTextAlignmentRight;
        _totalLabel.font = UIFontMake(12.0f);
    }
    return _totalLabel;
}

@end
