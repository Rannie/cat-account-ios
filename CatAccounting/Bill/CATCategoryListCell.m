//
//  CATCategoryListCell.m
//  CatAccounting
//
//  Created by ran on 2017/9/13.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATCategoryListCell.h"

@interface CATCategoryListCell ()
@end

@implementation CATCategoryListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.height.width.mas_equalTo(kCategoryIconSize);
            make.centerX.mas_equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(21);
            make.left.bottom.and.right.mas_equalTo(self.contentView);
        }];
        
        [self clearState];
    }
    return self;
}

- (void)clearState {
    self.iconView.state = CategoryIconStateNormal;
    self.iconView.icon = nil;
    self.titleLabel.text = nil;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self clearState];
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorMakeWithHex(@"#424242");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = UIFontMake(13.f);
    }
    return _titleLabel;
}

- (CATCategoryIconView *)iconView {
    if (_iconView == nil) {
        _iconView = [[CATCategoryIconView alloc] init];
    }
    return _iconView;
}

@end
