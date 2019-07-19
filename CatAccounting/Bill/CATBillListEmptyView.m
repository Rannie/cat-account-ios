//
//  CATBillListEmptyView.m
//  CatAccounting
//
//  Created by ran on 2017/9/21.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATBillListEmptyView.h"

@interface CATBillListEmptyView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation CATBillListEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorClear;
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(250);
            make.height.mas_equalTo(47);
            make.centerY.mas_equalTo(self).mas_offset(-70);
            make.centerX.mas_equalTo(self);
        }];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(self);
            make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(5);
            make.height.mas_equalTo(50);
        }];
    }
    return self;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = UIImageMake(@"empty_image");
        _imageView.alpha = 0.7;
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = UIFontMake(17.0f);
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = UIColorMakeWithHex(@"#757575");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"暂无账目，点击底部 “+” 添加账目";
    }
    return _titleLabel;
}

@end
