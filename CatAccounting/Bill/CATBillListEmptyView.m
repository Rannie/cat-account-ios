//
//  CATBillListEmptyView.m
//  CatAccounting
//
//  Created by ran on 2017/9/21.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATBillListEmptyView.h"

@interface CATBillListEmptyView ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation CATBillListEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorClear;
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(self);
            make.height.mas_equalTo(50);
            make.centerY.mas_equalTo(self).mas_offset(-30);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = UIFontMake(17.0f);
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = UIColorMakeWithHex(@"#757575");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"暂无账目，点击 “+” 添加账目";
    }
    return _titleLabel;
}

@end
