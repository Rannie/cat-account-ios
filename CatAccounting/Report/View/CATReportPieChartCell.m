//
//  CATReportPieChartCell.m
//  CatAccounting
//
//  Created by ran on 2017/9/28.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATReportPieChartCell.h"

#define kColorAreaSize 13
#define kCateLW 70
#define kLabelH 21
#define kPercentLW 100
#define kInset 10
#define kFontSize 14.0f

@interface CATReportPieChartCell ()

@property (nonatomic, strong) UIView *cateColorView;
@property (nonatomic, strong) UILabel *cateNameLabel;
@property (nonatomic, strong) UILabel *percentLabel;
@property (nonatomic, strong) UILabel *totalLabel;

@end

@implementation CATReportPieChartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColorWhite;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIView *contentView = self.contentView;
    
    [contentView addSubview:self.cateColorView];
    [self.cateColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView).mas_offset(CAT_MARGIN);
        make.width.and.height.mas_equalTo(kColorAreaSize);
        make.centerY.mas_equalTo(contentView);
    }];
    
    [contentView addSubview:self.cateNameLabel];
    [self.cateNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cateColorView.mas_right).mas_offset(kInset);
        make.width.mas_equalTo(kCateLW);
        make.height.mas_equalTo(kLabelH);
        make.centerY.mas_equalTo(contentView);
    }];
    
    [contentView addSubview:self.percentLabel];
    [self.percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kPercentLW);
        make.height.mas_equalTo(kLabelH);
        make.center.mas_equalTo(contentView);
    }];
    
    [contentView addSubview:self.totalLabel];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.percentLabel.mas_right).mas_offset(kInset);
        make.right.mas_equalTo(contentView).mas_offset(-CAT_MARGIN);
        make.height.mas_equalTo(kLabelH);
        make.centerY.mas_equalTo(contentView);
    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.cateColor = UIColorClear;
    self.cateName = nil;
    self.percentText = nil;
    self.totalText = nil;
}

- (void)setCateColor:(UIColor *)cateColor {
    _cateColor = cateColor;
    self.cateColorView.backgroundColor = cateColor;
}

- (void)setCateName:(NSString *)cateName {
    _cateName = cateName;
    self.cateNameLabel.text = cateName;
}

- (void)setPercentText:(NSString *)percentText {
    _percentText = percentText;
    self.percentLabel.text = percentText;
}

- (void)setTotalText:(NSString *)totalText {
    _totalText = totalText;
    self.totalLabel.text = totalText;
}

- (UIView *)cateColorView {
    if (_cateColorView == nil) {
        _cateColorView = [[UIView alloc] init];
        _cateColorView.layer.cornerRadius = 2.0f;
    }
    return _cateColorView;
}

- (UILabel *)cateNameLabel {
    if (_cateNameLabel == nil) {
        _cateNameLabel = [[UILabel alloc] init];
        _cateNameLabel.font = UIFontMake(kFontSize);
        _cateNameLabel.textColor = UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK);
    }
    return _cateNameLabel;
}

- (UILabel *)percentLabel {
    if (_percentLabel == nil) {
        _percentLabel = [[UILabel alloc] init];
        _percentLabel.font = UIFontMake(kFontSize);
        _percentLabel.textColor = UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK);
        _percentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _percentLabel;
}

- (UILabel *)totalLabel {
    if (_totalLabel == nil) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.font = UIFontMake(kFontSize);
        _totalLabel.textColor = UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK);
        _totalLabel.textAlignment = NSTextAlignmentRight;
    }
    return _totalLabel;
}

@end
