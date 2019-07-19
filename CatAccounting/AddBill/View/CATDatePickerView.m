//
//  CATDatePickerView.m
//  CatAccounting
//
//  Created by ran on 2017/9/14.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATDatePickerView.h"

#define kButtonWidth 50
#define kButtonHeight 26

@interface CATDatePickerView ()
@property (nonatomic, strong) UIView *toolBarContent;
@property (nonatomic, strong) QMUIButton *cancelBtn;
@property (nonatomic, strong) QMUIButton *doneBtn;
@end

@implementation CATDatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _toolBarContent = [[UIView alloc] init];
        _toolBarContent.backgroundColor = UIColorMakeWithHex(@"#eeeeee");
        [self addSubview:_toolBarContent];
        [_toolBarContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.and.right.mas_equalTo(self);
            make.height.mas_equalTo(ToolBarHeight);
        }];
        
        _cancelBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColorBlue forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:UIFontMake(15)];
        [_cancelBtn addTarget:self action:@selector(onCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBarContent addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_toolBarContent).mas_offset(20);
            make.centerY.mas_equalTo(_toolBarContent);
            make.width.mas_equalTo(kButtonWidth);
            make.height.mas_equalTo(kButtonHeight);
        }];
        
        _doneBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_doneBtn setTitleColor:UIColorBlue forState:UIControlStateNormal];
        [_doneBtn.titleLabel setFont:UIFontMake(16)];
        [_doneBtn addTarget:self action:@selector(onDoneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBarContent addSubview:_doneBtn];
        [_doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_toolBarContent).mas_offset(-20);
            make.centerY.mas_equalTo(_toolBarContent);
            make.width.mas_equalTo(kButtonWidth);
            make.height.mas_equalTo(kButtonHeight);
        }];
        
        _datePicker = [[UIDatePicker alloc] init];
        [self addSubview:_datePicker];
        [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_toolBarContent.mas_bottom);
            make.left.bottom.and.right.mas_equalTo(self);
        }];
    }
    return self;
}

- (void)onCancelButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerViewDidSelectedCancelButton:)]) {
        [self.delegate datePickerViewDidSelectedCancelButton:self];
    }
}

- (void)onDoneButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerView:didSelectedDate:)]) {
        [self.delegate datePickerView:self didSelectedDate:self.datePicker.date];
    }
}

@end
