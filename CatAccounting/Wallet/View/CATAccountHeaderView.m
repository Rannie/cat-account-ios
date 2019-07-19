//
//  CATAccountHeaderView.m
//  CatAccounting
//
//  Created by ran on 2017/10/20.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATAccountHeaderView.h"

#define kFundLabelHeight 42
#define kTitleLabelHeight 21

@interface CATAccountHeaderView ()

@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UILabel *incomeLabel;
@property (nonatomic, strong) UILabel *outcomeLabel;
@property (nonatomic, strong) UILabel *assetsLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CATAccountHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    CGFloat labelW = SCREEN_WIDTH/3.0f;
    [self addSubview:self.content];
    [self.content addSubview:self.incomeLabel];
    [self.content addSubview:self.outcomeLabel];
    [self.content addSubview:self.assetsLabel];
    [self addSubview:self.titleLabel];
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.mas_equalTo(self);
        make.height.mas_equalTo(kHeaderViewHeight-1.4*kTitleLabelHeight);
    }];
    [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.content);
        make.width.mas_equalTo(labelW);
        make.height.mas_equalTo(kFundLabelHeight);
        make.left.mas_equalTo(self.content);
    }];
    [self.outcomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.content);
        make.width.mas_equalTo(labelW);
        make.height.mas_equalTo(kFundLabelHeight);
        make.left.mas_equalTo(self.incomeLabel.mas_right);
    }];
    [self.assetsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.content);
        make.width.mas_equalTo(labelW);
        make.height.mas_equalTo(kFundLabelHeight);
        make.left.mas_equalTo(self.outcomeLabel.mas_right);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(CAT_MARGIN);
        make.right.mas_equalTo(self).mas_offset(-CAT_MARGIN);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(kTitleLabelHeight);
    }];
    
    UIView *leftSep = [self genSepLine];
    [self.content addSubview:leftSep];
    [leftSep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.content).mas_offset(labelW);
        make.width.mas_equalTo(CATOnePixel);
        make.top.mas_equalTo(self.outcomeLabel);
        make.bottom.mas_equalTo(self.outcomeLabel);
    }];
    
    UIView *rightSep = [self genSepLine];
    [self.content addSubview:rightSep];
    [rightSep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.content).mas_offset(-labelW);
        make.width.mas_equalTo(CATOnePixel);
        make.top.mas_equalTo(self.outcomeLabel);
        make.bottom.mas_equalTo(self.outcomeLabel);
    }];
}

- (void)setOutcomeStr:(NSString *)outcomeStr {
    _outcomeStr = outcomeStr;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:outcomeStr];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 5.0f;
    paraStyle.alignment = NSTextAlignmentCenter;
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, outcomeStr.length)];
    [attrStr addAttribute:NSFontAttributeName value:UIFontMake(17.0f) range:NSMakeRange(5, outcomeStr.length-5)];
    [attrStr addAttribute:NSFontAttributeName value:UIFontMake(14.0f) range:NSMakeRange(0, 5)];
    self.outcomeLabel.attributedText = attrStr;
}

- (void)setIncomeStr:(NSString *)incomeStr {
    _incomeStr = incomeStr;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:incomeStr];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 5.0f;
    paraStyle.alignment = NSTextAlignmentCenter;
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, incomeStr.length)];
    [attrStr addAttribute:NSFontAttributeName value:UIFontMake(17.0f) range:NSMakeRange(5, incomeStr.length-5)];
    [attrStr addAttribute:NSFontAttributeName value:UIFontMake(14.0f) range:NSMakeRange(0, 5)];
    self.incomeLabel.attributedText = attrStr;
}

- (void)setAssetsStr:(NSString *)assetsStr {
    _assetsStr = assetsStr;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:assetsStr];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 5.0f;
    paraStyle.alignment = NSTextAlignmentCenter;
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, assetsStr.length)];
    [attrStr addAttribute:NSFontAttributeName value:UIFontMake(17.0f) range:NSMakeRange(4, assetsStr.length-4)];
    [attrStr addAttribute:NSFontAttributeName value:UIFontMake(14.0f) range:NSMakeRange(0, 4)];
    self.assetsLabel.attributedText = attrStr;
}

- (void)refreshBackgroundColor {
    self.content.backgroundColor = UIColorMakeWithHex(CAT_THEME_COLOR);
}

- (UIView *)genSepLine {
    UIView *sep = [[UIView alloc] init];
    sep.backgroundColor = UIColorWhite;
    return sep;
}

- (UIView *)content {
    if (_content == nil) {
        _content = [[UIView alloc] init];
        _content.backgroundColor = UIColorMakeWithHex(CAT_THEME_COLOR);
    }
    return _content;
}

- (UILabel *)incomeLabel {
    if (_incomeLabel == nil) {
        _incomeLabel = [[UILabel alloc] initWithFont:UIFontMake(15.0f) textColor:UIColorWhite];
        _incomeLabel.textAlignment = NSTextAlignmentCenter;
        _incomeLabel.numberOfLines = 0;
    }
    return _incomeLabel;
}

- (UILabel *)outcomeLabel {
    if (_outcomeLabel == nil) {
        _outcomeLabel = [[UILabel alloc] initWithFont:UIFontMake(15.0f) textColor:UIColorWhite];
        _outcomeLabel.textAlignment = NSTextAlignmentCenter;
        _outcomeLabel.numberOfLines = 0;
    }
    return _outcomeLabel;
}

- (UILabel *)assetsLabel {
    if (_assetsLabel == nil) {
        _assetsLabel = [[UILabel alloc] initWithFont:UIFontMake(15.0f) textColor:UIColorWhite];
        _assetsLabel.textAlignment = NSTextAlignmentCenter;
        _assetsLabel.numberOfLines = 0;
    }
    return _assetsLabel;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFont:UIFontMake(13.0) textColor:UIColorGray];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"我的账户";
    }
    return _titleLabel;
}

@end
