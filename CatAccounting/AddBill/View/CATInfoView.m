//
//  CATInfoView.m
//  CatAccounting
//
//  Created by ran on 2017/9/13.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATInfoView.h"

#define kButtonWidth    50
#define kSourceWidth    80
#define kButtonHeight   25
#define kButtonInsetH   7
#define kButtonFontSize 14
#define kAmountWidth    155
#define kEdgeMargin     14

@interface CATInfoView ()
@property (nonatomic, strong) UIView *infoContent;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) QMUIButton *dateBtn;
@property (nonatomic, strong) QMUIButton *remarkBtn;
@property (nonatomic, strong) QMUIButton *sourceBtn;
@property (nonatomic, strong) UILabel *remarkLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@end

@implementation CATInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorClear;
        _categoryName = @"类别";
        _dateStr = @"日期";
        _remark = @"备注";
        _source = @"账户";
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.infoContent];
    [self.infoContent addSubview:self.categoryLabel];
    [self.infoContent addSubview:self.dateBtn];
    [self.infoContent addSubview:self.remarkBtn];
    [self.infoContent addSubview:self.remarkLabel];
    [self.infoContent addSubview:self.sourceBtn];
    [self.infoContent addSubview:self.amountLabel];
}

- (void)layoutSubviews {
    self.infoContent.frame = CGRectMake(kEdgeMargin, kEdgeMargin, self.width-2*kEdgeMargin, kInfoViewHeight-2*kEdgeMargin);
    
    CGFloat buttonInsetV = (self.infoContent.height-2*kButtonHeight)/3.f;
    self.categoryLabel.frame = CGRectMake(self.infoContent.width-kButtonWidth*1.3-kButtonInsetH, buttonInsetV, kButtonWidth*1.3, kButtonHeight);
    self.dateBtn.frame = CGRectMake(kButtonInsetH, buttonInsetV, kButtonWidth*1.5, kButtonHeight);
    self.sourceBtn.frame = CGRectMake(self.dateBtn.right+kButtonInsetH, buttonInsetV, kSourceWidth, kButtonHeight);
    self.remarkBtn.frame = CGRectMake(kButtonInsetH, 2*buttonInsetV+kButtonHeight, kButtonHeight, kButtonHeight);
    self.remarkLabel.frame = CGRectMake(self.remarkBtn.right+kButtonInsetH, 2*buttonInsetV+kButtonHeight, self.infoContent.width-4*kButtonInsetH-kAmountWidth-kButtonHeight, kButtonHeight);
    self.amountLabel.frame = CGRectMake(self.infoContent.width-kButtonInsetH-kAmountWidth, 2*buttonInsetV+kButtonHeight, kAmountWidth, kButtonHeight);
}

- (void)setAmount:(NSString *)amount {
    _amount = amount;
    self.amountLabel.text = amount;
}

- (void)setCategoryName:(NSString *)categoryName {
    _categoryName = categoryName;
    [self.categoryLabel setText:categoryName];
}

- (void)setDateStr:(NSString *)dateStr {
    _dateStr = dateStr;
    [self.dateBtn setTitle:dateStr forState:UIControlStateNormal];
}

- (void)setSource:(NSString *)source {
    _source = source;
    [self.sourceBtn setTitle:source forState:UIControlStateNormal];
}

- (void)setRemark:(NSString *)remark {
    _remark = remark;
    if (remark == nil || CATIsEqualString(remark, @"")) {
        self.remarkLabel.text = @"备注";
    } else {
        self.remarkLabel.text = remark;
    }
}

- (void)onDateBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(infoViewDidClickDateButton)]) {
        [self.delegate infoViewDidClickDateButton];
    }
}

- (void)onRemarkBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(infoViewDidClickRemarkButton)]) {
        [self.delegate infoViewDidClickRemarkButton];
    }
}

- (void)onSourceBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(infoViewDidClickSourceButton)]) {
        [self.delegate infoViewDidClickSourceButton];
    }
}

- (UIView *)infoContent {
    if (_infoContent == nil) {
        _infoContent = [[UIView alloc] init];
        _infoContent.backgroundColor = UIColorMakeWithHex(@"#eceff1");
        _infoContent.layer.cornerRadius = 4.0f;
    }
    return _infoContent;
}

- (UILabel *)categoryLabel {
    if (_categoryLabel == nil) {
        _categoryLabel = [[UILabel alloc] initWithFont:UIFontBoldMake(17) textColor:UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK)];
        _categoryLabel.textAlignment = NSTextAlignmentRight;
    }
    return _categoryLabel;
}

- (QMUIButton *)dateBtn {
    if (_dateBtn == nil) {
        _dateBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_dateBtn setTitleColor:UIColorWhite forState:UIControlStateNormal];
        [_dateBtn setBackgroundColor:UIColorMakeWithHex(CAT_THEME_COLOR)];
        [_dateBtn setTitle:self.dateStr forState:UIControlStateNormal];
        [_dateBtn addTarget:self action:@selector(onDateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _dateBtn.layer.cornerRadius = 2.0f;
        _dateBtn.titleLabel.font = UIFontMake(kButtonFontSize);
    }
    return _dateBtn;
}

- (UILabel *)amountLabel {
    if (_amountLabel == nil) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.textAlignment = NSTextAlignmentRight;
        _amountLabel.textColor = UIColorMakeWithHex(CAT_THEME_COLOR);
        _amountLabel.font = UIFontMake(24);
    }
    return _amountLabel;
}

- (QMUIButton *)remarkBtn {
    if (_remarkBtn == nil) {
        _remarkBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_remarkBtn addTarget:self action:@selector(onRemarkBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_remarkBtn setImage:UIImageMake(@"more_suggest") forState:UIControlStateNormal];
        [_remarkBtn setImagePosition:QMUIButtonImagePositionLeft];
    }
    return _remarkBtn;
}

- (UILabel *)remarkLabel {
    if (_remarkLabel == nil) {
        _remarkLabel = [[UILabel alloc] initWithFont:UIFontMake(13.0f) textColor:UIColorMakeWithHex(@"#8a8a8a")];
        _remarkLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRemarkBtnClicked:)];
        [_remarkLabel addGestureRecognizer:tapGes];
        _remarkLabel.text = self.remark;
    }
    return _remarkLabel;
}

- (QMUIButton *)sourceBtn {
    if (_sourceBtn == nil) {
        _sourceBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_sourceBtn setBackgroundColor:UIColorMakeWithHex(CAT_THEME_COLOR)];
        [_sourceBtn setTitleColor:UIColorWhite forState:UIControlStateNormal];
        [_sourceBtn setTitle:self.source forState:UIControlStateNormal];
        [_sourceBtn addTarget:self action:@selector(onSourceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _sourceBtn.layer.cornerRadius = 2.0f;
        _sourceBtn.titleLabel.font = UIFontMake(kButtonFontSize);
    }
    return _sourceBtn;
}

@end
