//
//  CATCategoryIconView.m
//  CatAccounting
//
//  Created by ran on 2017/9/13.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATCategoryIconView.h"

@interface CATCategoryIconView ()
@property (nonatomic, strong) UIImageView *iconView;
@end

@implementation CATCategoryIconView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 0, 0)];
    if (self) {
        self.layer.masksToBounds = YES;
        
        _iconView = [[UIImageView alloc] init];
        _iconView.userInteractionEnabled = YES;
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_iconView];
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(self.mas_width).multipliedBy(0.55);
            make.center.mas_equalTo(self);
        }];
        
        self.state = CategoryIconStateNormal;
    }
    return self;
}

- (void)layoutSubviews {
    self.layer.cornerRadius = self.width/2.0f;
}

- (void)setState:(CategoryIconState)state {
    _state = state;
    if (state == CategoryIconStateNormal) {
        self.backgroundColor = UIColorMakeWithHex(@"#eeeeee");
    } else {
        self.backgroundColor = self.highlightColor;
    }
}

- (void)setHighlightColor:(UIColor *)highlightColor {
    _highlightColor = highlightColor;
    if (self.state == CategoryIconStateHighlight) {
        self.backgroundColor = self.highlightColor;
    }
}

- (void)setIcon:(UIImage *)icon {
    _iconView.image = icon;
}

@end
