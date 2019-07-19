//
//  CATBudgetHeaderView.m
//  CatAccounting
//
//  Created by ran on 2017/10/24.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATBudgetHeaderView.h"
#import "CATBudgetTitleView.h"

#define kEleHeight (22)
#define kButtonHeight (32)

@interface CATBudgetHeaderView ()
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) QMUIButton *useLastButton;
@property (nonatomic, strong) QMUIButton *clearButton;
@property (nonatomic, strong) CATBudgetTitleView *titleView;
@end

@implementation CATBudgetHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorClear;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.headerLabel];
    [self addSubview:self.useLastButton];
    [self addSubview:self.clearButton];
    [self addSubview:self.titleView];
    
    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(CAT_MARGIN);
        make.top.mas_equalTo(self).mas_offset(5);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(kEleHeight);
    }];
    CGFloat buttonW = (SCREEN_WIDTH-3*CAT_MARGIN)/2.0f;
    [self.useLastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(CAT_MARGIN);
        make.top.mas_equalTo(self.headerLabel.mas_bottom).mas_offset(13);
        make.width.mas_equalTo(buttonW);
        make.height.mas_equalTo(kButtonHeight);
    }];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(-CAT_MARGIN);
        make.top.bottom.mas_equalTo(self.useLastButton);
        make.width.mas_equalTo(buttonW);
    }];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.mas_equalTo(self);
        make.height.mas_equalTo(kBudgetTitleHeight);
    }];
}

- (void)setDateStr:(NSString *)dateStr {
    _dateStr = dateStr;
}

- (void)onUseLastButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(budgetHeaderViewDidClickUseLastButton:)]) {
        [self.delegate budgetHeaderViewDidClickUseLastButton:self];
    }
}

- (void)onClearButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(budgetHeaderViewDidClickClearButton:)]) {
        [self.delegate budgetHeaderViewDidClickClearButton:self];
    }
}

- (void)refreshThemeColor {
    [self.useLastButton setBackgroundColor:UIColorMakeWithHex(CAT_THEME_COLOR)];
    [self.clearButton setBackgroundColor:UIColorMakeWithHex(CAT_THEME_COLOR)];
    self.useLastButton.layer.borderColor = UIColorMakeWithHex(CAT_THEME_COLOR).CGColor;
    self.clearButton.layer.borderColor = UIColorMakeWithHex(CAT_THEME_COLOR).CGColor;
}

- (UILabel *)headerLabel {
    if (_headerLabel == nil) {
        _headerLabel = [[UILabel alloc] initWithFont:UIFontMake(13.0) textColor:UIColorGray];
        _headerLabel.text = @"我的预算";
    }
    return _headerLabel;
}

- (QMUIButton *)useLastButton {
    if (_useLastButton == nil) {
        _useLastButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_useLastButton setTitle:@"沿用上期预算" forState:UIControlStateNormal];
        [_useLastButton setTitleColor:UIColorWhite forState:UIControlStateNormal];
        [_useLastButton setBackgroundColor:UIColorMakeWithHex(CAT_THEME_COLOR)];
        _useLastButton.titleLabel.font = UIFontMake(13.0f);
        _useLastButton.layer.cornerRadius = kButtonHeight/2.0f;
        _useLastButton.layer.borderWidth = CATOnePixel;
        _useLastButton.layer.borderColor = UIColorMakeWithHex(CAT_THEME_COLOR).CGColor;
        [_useLastButton addTarget:self action:@selector(onUseLastButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _useLastButton;
}

- (QMUIButton *)clearButton {
    if (_clearButton == nil) {
        _clearButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_clearButton setTitle:@"清除所有预算" forState:UIControlStateNormal];
        [_clearButton setTitleColor:UIColorWhite forState:UIControlStateNormal];
        [_clearButton setBackgroundColor:UIColorMakeWithHex(CAT_THEME_COLOR)];
        _clearButton.titleLabel.font = UIFontMake(13.0f);
        _clearButton.layer.cornerRadius = kButtonHeight/2.0f;
        _clearButton.layer.borderWidth = CATOnePixel;
        _clearButton.layer.borderColor = UIColorMakeWithHex(CAT_THEME_COLOR).CGColor;
        [_clearButton addTarget:self action:@selector(onClearButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

- (CATBudgetTitleView *)titleView {
    if (_titleView == nil) {
        _titleView = [[CATBudgetTitleView alloc] init];
        _titleView.titleLabel.text = @"月度预算";
    }
    return _titleView;
}

@end
