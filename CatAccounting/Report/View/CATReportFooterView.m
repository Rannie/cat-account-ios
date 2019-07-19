//
//  CATReportFooterView.m
//  CatAccounting
//
//  Created by ran on 2017/9/29.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATReportFooterView.h"

@implementation CATReportFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.footerLabel];
        [self.footerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(150);
            make.right.mas_equalTo(self).mas_offset(-10);
            make.height.mas_equalTo(21);
            make.top.mas_equalTo(self).mas_offset(2);
        }];
    }
    return self;
}

- (UILabel *)footerLabel {
    if (_footerLabel == nil) {
        _footerLabel = [[UILabel alloc] init];
        _footerLabel.textAlignment = NSTextAlignmentRight;
        _footerLabel.font = UIFontMake(12.0f);
        _footerLabel.textColor = UIColorGrayLighten;
    }
    return _footerLabel;
}

@end
