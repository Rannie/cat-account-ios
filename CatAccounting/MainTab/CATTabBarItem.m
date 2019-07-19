//
//  CATTabBarItem.m
//  CatAccounting
//
//  Created by ran on 2017/10/16.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATTabBarItem.h"

#define kImageSize 23
#define kLabelHeight 16
#define kImageTop 6.33

@interface CATTabBarItem ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CATTabBarItem

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage index:(NSInteger)index {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = UIColorClear;
        _title = title;
        _image = image;
        _selectedImage = selectedImage;
        _index = index;
        
        [self setupSubviews];
        
        self.titleLabel.text = title;
        self.iconView.image = image;
        
        @weakify(self)
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self)
            if (self.selectedCallback) {
                self.selectedCallback();
            }
        }];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}

- (void)setupSubviews {
    if (self.title)
    {
        [self addSubview:self.iconView];
        [self addSubview:self.titleLabel];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).mas_offset(kImageTop);
            make.centerX.mas_equalTo(self);
            make.width.and.height.mas_equalTo(kImageSize);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.mas_equalTo(self);
            make.height.mas_equalTo(kLabelHeight);
        }];
    }
    else
    {
        [self addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.width.height.mas_equalTo(kImageSize);
        }];
    }
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (selected) {
        if (self.title) self.titleLabel.textColor = UIColorMakeWithHex(CAT_THEME_COLOR);
        self.iconView.image = self.selectedImage;
    } else {
        if (self.title) self.titleLabel.textColor = UIColorMakeWithHex(@"#8a8a8a");
        self.iconView.image = self.image;
    }
}

- (void)refreshThemeColor {
    if (self.selected) {
        if (self.title) self.titleLabel.textColor = UIColorMakeWithHex(CAT_THEME_COLOR);
        self.iconView.image = self.selectedImage;
    }
}

- (UIImage *)selectedImage {
    if (_selectedImage) {
        return _selectedImage;
    } else {
        return _image;
    }
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColorMakeWithHex(@"#8a8a8a");
        _titleLabel.font = UIFontMake(10.0f);
    }
    return _titleLabel;
}

- (UIImageView *)iconView {
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] init];
        _iconView.userInteractionEnabled = YES;
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconView;
}

@end
