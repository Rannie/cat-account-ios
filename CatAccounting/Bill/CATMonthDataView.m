//
//  CATMonthDataView.m
//  CatAccounting
//
//  Created by ran on 2017/9/19.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATMonthDataView.h"

#define kMonthAreaWidth     130
#define kDateLabelWidth     48
#define kPromptFontSize     13
#define kMonthFontSize      20
#define kDataFontSize       17
#define kPromptLabelHeight  19
#define kMargin             9
#define kLabelInset         4
#define kArrowSize          25

@interface CATMonthDataView ()

@property (nonatomic, strong) UIView *monthArea;
@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UIView *sepLine;
@property (nonatomic, strong) UILabel *expLabel;
@property (nonatomic, strong) UILabel *expDataLabel;
@property (nonatomic, strong) UILabel *incLabel;
@property (nonatomic, strong) UILabel *incDataLabel;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) QMUIButton *rightTriIcon;
@property (nonatomic, strong) QMUIButton *leftTriIcon;

@end

@implementation CATMonthDataView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWhite;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.monthArea];
    [self.monthArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.bottom.mas_equalTo(self);
        make.width.mas_equalTo(kMonthAreaWidth);
    }];
    
    [self.monthArea addSubview:self.yearLabel];
    [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.monthArea).mas_offset(kMargin);
        make.centerX.mas_equalTo(self.monthArea);
        make.width.mas_equalTo(kDateLabelWidth);
        make.height.mas_equalTo(kPromptLabelHeight);
    }];
    
    [self.monthArea addSubview:self.monthLabel];
    [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.yearLabel);
        make.top.mas_equalTo(self.yearLabel.mas_bottom).mas_offset(kLabelInset);
        make.bottom.mas_equalTo(self.monthArea).mas_offset(-kMargin);
    }];
    
    [self.monthArea addSubview:self.leftTriIcon];
    [self.leftTriIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.monthLabel.mas_left).mas_offset(-kLabelInset-3); //offset
        make.width.height.mas_equalTo(kArrowSize);
        make.centerY.mas_equalTo(self.monthLabel);
    }];
    
    [self.monthArea addSubview:self.rightTriIcon];
    [self.rightTriIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.monthLabel.mas_right).mas_offset(kLabelInset);
        make.width.height.mas_equalTo(kArrowSize);
        make.centerY.mas_equalTo(self.monthLabel);
    }];
    
    [self.monthArea addSubview:self.sepLine];
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.monthArea);
        make.top.bottom.mas_equalTo(self.monthLabel);
        make.width.mas_equalTo(CATOnePixel);
    }];
    
    CGFloat dWidth = (SCREEN_WIDTH-kMonthAreaWidth)/2.0f;
    [self addSubview:self.expDataLabel];
    [self addSubview:self.expLabel];
    
    [self.expDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.monthArea.mas_right);
        make.width.mas_equalTo(dWidth);
        make.top.mas_equalTo(self.expLabel.mas_bottom).mas_offset(kLabelInset);
        make.bottom.mas_equalTo(self).mas_offset(-kMargin);
    }];
    [self.expLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.expDataLabel);
        make.top.mas_equalTo(self).mas_offset(kMargin);
        make.height.mas_equalTo(kPromptLabelHeight);
    }];
    
    [self addSubview:self.incDataLabel];
    [self addSubview:self.incLabel];
    
    [self.incDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.expDataLabel.mas_right);
        make.top.and.bottom.mas_equalTo(self.expDataLabel);
        make.right.mas_equalTo(self);
    }];
    [self.incLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.incDataLabel);
        make.top.bottom.mas_equalTo(self.expLabel);
    }];
    
    [self addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.mas_equalTo(self);
        make.height.mas_equalTo(CATOnePixel);
    }];
}

- (void)showNext {
    if (!self.rightTriIcon.hidden) {
        return;
    }
    self.rightTriIcon.hidden = NO;
}

- (void)hideNext {
    self.rightTriIcon.hidden = YES;
}

- (void)onLeftArrowClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataViewShouldReduceMonth:)]) {
        [self.delegate dataViewShouldReduceMonth:self];
    }
}

- (void)onRightArrowClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataViewShouldAddMonth:)]) {
        [self.delegate dataViewShouldAddMonth:self];
    }
}

- (void)setYearText:(NSString *)yearText {
    _yearText = yearText;
    self.yearLabel.text = yearText;
}

- (void)setMonthText:(NSString *)monthText {
    _monthText = monthText;
    self.monthLabel.text = monthText;
}

- (void)setExpenditure:(NSString *)expenditure {
    _expenditure = expenditure;
    self.expDataLabel.text = expenditure;
}

- (void)setIncome:(NSString *)income {
    _income = income;
    self.incDataLabel.text = income;
}

- (QMUIButton *)leftTriIcon {
    if (_leftTriIcon == nil) {
        _leftTriIcon = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_leftTriIcon setImage:UIImageMake(@"icon_arrow_left") forState:UIControlStateNormal];
        [_leftTriIcon addTarget:self action:@selector(onLeftArrowClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftTriIcon;
}

- (QMUIButton *)rightTriIcon {
    if (_rightTriIcon == nil) {
        _rightTriIcon = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_rightTriIcon setImage:UIImageMake(@"icon_arrow_right") forState:UIControlStateNormal];
        [_rightTriIcon addTarget:self action:@selector(onRightArrowClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightTriIcon;
}

- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = UIColorSeparator;
    }
    return _bottomLine;
}

- (UILabel *)incLabel {
    if (_incLabel == nil) {
        _incLabel = [[UILabel alloc] init];
        _incLabel.font = UIFontMake(kPromptFontSize);
        _incLabel.textAlignment = NSTextAlignmentCenter;
        _incLabel.text = @" 收入（元）";
        _incLabel.textColor = UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK);
    }
    return _incLabel;
}

- (UILabel *)incDataLabel {
    if (_incDataLabel == nil) {
        _incDataLabel = [[UILabel alloc] init];
        _incDataLabel.font = UIFontMake(kDataFontSize);
        _incDataLabel.textAlignment = NSTextAlignmentCenter;
        _incDataLabel.textColor = UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK);
        _incDataLabel.text = @"0.00";
    }
    return _incDataLabel;
}

- (UILabel *)expLabel {
    if (_expLabel == nil) {
        _expLabel = [[UILabel alloc] init];
        _expLabel.font = UIFontMake(kPromptFontSize);
        _expLabel.textAlignment = NSTextAlignmentCenter;
        _expLabel.text = @" 支出（元）";
        _expLabel.textColor = UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK);
    }
    return _expLabel;
}

- (UILabel *)expDataLabel {
    if (_expDataLabel == nil) {
        _expDataLabel = [[UILabel alloc] init];
        _expDataLabel.font = UIFontMake(kDataFontSize);
        _expDataLabel.textAlignment = NSTextAlignmentCenter;
        _expDataLabel.textColor = UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK);
        _expDataLabel.text = @"0.00";
    }
    return _expDataLabel;
}

- (UIView *)sepLine {
    if (_sepLine == nil) {
        _sepLine = [[UIView alloc] init];
        _sepLine.backgroundColor = UIColorSeparator;
    }
    return _sepLine;
}

- (UILabel *)monthLabel {
    if (_monthLabel == nil) {
        _monthLabel = [[UILabel alloc] init];
        _monthLabel.font = UIFontMake(kMonthFontSize);
        _monthLabel.textColor = UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK);
        _monthLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _monthLabel;
}

- (UILabel *)yearLabel {
    if (_yearLabel == nil) {
        _yearLabel = [[UILabel alloc] init];
        _yearLabel.font = UIFontMake(kPromptFontSize);
        _yearLabel.textColor = UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK);
        _yearLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _yearLabel;
}

- (UIView *)monthArea {
    if (_monthArea == nil) {
        _monthArea = [[UIView alloc] init];
    }
    return _monthArea;
}

@end
