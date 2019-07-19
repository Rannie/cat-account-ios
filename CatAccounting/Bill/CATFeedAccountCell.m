//
//  CATFeedAccountCell.m
//  CatAccounting
//
//  Created by ran on 2017/9/20.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATFeedAccountCell.h"

#define kIconSize 32
#define kLabelHeight 21
#define kCategoryLabelWidth 80
#define kAmountLabelWidth 100

@interface CATFeedAccountCell ()
@property (nonatomic, strong) UIView *bottomSep;
@end

@implementation CATFeedAccountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorClear;
        self.contentView.backgroundColor = UIColorWhite;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.bottomSep.hidden = YES;
    self.amountLabel.text = nil;
    self.categoryLabel.text = nil;
    self.remarkLabel.hidden = YES;
    self.remarkLabel.text = nil;
    self.categoryIcon.icon = nil;
    self.categoryIcon.highlightColor = nil;
}

- (void)setupSubviews {
    [self.contentView addSubview:self.categoryIcon];
    [self.contentView addSubview:self.categoryLabel];
    [self.contentView addSubview:self.remarkLabel];
    [self.contentView addSubview:self.amountLabel];
    [self.contentView addSubview:self.bottomSep];
    [self.bottomSep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.categoryLabel);
        make.bottom.and.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(CATOnePixel);
    }];
}

- (void)layoutSubviews {
    CGFloat iconY = (self.contentView.height-kIconSize)/2.0f;
    self.categoryIcon.frame = CGRectMake(CAT_MARGIN, iconY, kIconSize, kIconSize);
    CGFloat amountY = (self.contentView.height-kLabelHeight)/2.0f;
    self.amountLabel.frame = CGRectMake(self.contentView.width-kAmountLabelWidth-CAT_MARGIN, amountY, kAmountLabelWidth, kLabelHeight);
    
    CGFloat cateX = self.categoryIcon.right+CAT_MARGIN;
    if (CATIsEmptyString(self.remarkLabel.text)) {
        self.remarkLabel.hidden = YES;
        self.categoryLabel.frame = CGRectMake(cateX, amountY, kCategoryLabelWidth, kLabelHeight);
    } else {
        self.remarkLabel.hidden = NO;
        static CGFloat inset = 1;
        CGFloat marginV = (self.contentView.height-2*kLabelHeight-inset)/2.0f;
        self.categoryLabel.frame = CGRectMake(cateX, marginV, kCategoryLabelWidth, kLabelHeight);
        self.remarkLabel.frame = CGRectMake(cateX, marginV+kLabelHeight+inset, self.contentView.width-cateX-CAT_MARGIN-kAmountLabelWidth, kLabelHeight);
    }
}

- (void)showBottomLine {
    self.bottomSep.hidden = NO;
}

- (UIView *)bottomSep {
    if (_bottomSep == nil) {
        _bottomSep = [[UIView alloc] init];
        _bottomSep.backgroundColor = UIColorSeparator;
        _bottomSep.hidden = YES;
    }
    return _bottomSep;
}

- (CATCategoryIconView *)categoryIcon {
    if (_categoryIcon == nil) {
        _categoryIcon = [[CATCategoryIconView alloc] init];
    }
    return _categoryIcon;
}

- (UILabel *)remarkLabel {
    if (_remarkLabel == nil) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.font = UIFontMake(12.0f);
        _remarkLabel.textColor = UIColorGray;
    }
    return _remarkLabel;
}

- (UILabel *)categoryLabel {
    if (_categoryLabel == nil) {
        _categoryLabel = [[UILabel alloc] init];
        _categoryLabel.textColor = UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK);
        _categoryLabel.font = UIFontMake(14.0f);
    }
    return _categoryLabel;
}

- (UILabel *)amountLabel {
    if (_amountLabel == nil) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.textColor = UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK);
        _amountLabel.font = UIFontMake(14.0f);
        _amountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _amountLabel;
}

@end
