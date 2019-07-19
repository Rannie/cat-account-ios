//
//  CATMonthBudgetCell.m
//  CatAccounting
//
//  Created by ran on 2017/10/26.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATMonthBudgetCell.h"
#import "CATCategoryIconView.h"
#import "CATBudget.h"

#define kNormalFontSize 12.0f
#define kLargeFontSize  14.0f

#define kIconSize 40
#define kInsetH 10
#define kInsetV 2
#define kTitleWidth 100

@interface CATMonthBudgetCell ()

@property (nonatomic, strong) CATCategoryIconView *iconView;
@property (nonatomic, strong) UILabel *unusedTitleLabel;
@property (nonatomic, strong) UILabel *unusedAmountLabel;
@property (nonatomic, strong) UIView *sepLine;
@property (nonatomic, strong) UILabel *budgetTitleLabel;
@property (nonatomic, strong) UILabel *budgetAmountLabel;
@property (nonatomic, strong) UILabel *costTitleLabel;
@property (nonatomic, strong) UILabel *costAmountLabel;
@property (nonatomic, strong) UILabel *unsetTitleLabel;
@property (nonatomic, strong) UILabel *unsetAmountLabel;

@end

@implementation CATMonthBudgetCell

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
    UIView *content = self.contentView;
    [content addSubview:self.iconView];
    [content addSubview:self.unusedTitleLabel];
    [content addSubview:self.unusedAmountLabel];
    [content addSubview:self.sepLine];
    [content addSubview:self.budgetTitleLabel];
    [content addSubview:self.budgetAmountLabel];
    [content addSubview:self.costTitleLabel];
    [content addSubview:self.costAmountLabel];
    [content addSubview:self.unsetTitleLabel];
    [content addSubview:self.unsetAmountLabel];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(content).mas_offset(CAT_MARGIN);
        make.width.height.mas_equalTo(kIconSize);
        make.centerY.mas_equalTo(content);
    }];
    [self.unusedTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).mas_offset(CAT_MARGIN);
        make.width.mas_equalTo(kTitleWidth);
        make.top.mas_equalTo(content).mas_offset(2*kInsetV);
        make.height.mas_equalTo(21);
    }];
    [self.unusedAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.unusedTitleLabel);
        make.left.mas_equalTo(self.unusedTitleLabel.mas_right).mas_offset(kInsetH);
        make.right.mas_equalTo(content).mas_offset(-CAT_MARGIN);
    }];
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.unusedTitleLabel);
        make.right.mas_equalTo(self.unusedAmountLabel);
        make.height.mas_equalTo(CATOnePixel);
        make.top.mas_equalTo(self.unusedTitleLabel.mas_bottom).mas_offset(kInsetV);
    }];
    
    [self.budgetTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sepLine.mas_bottom).mas_offset(kInsetV);
        make.left.right.mas_equalTo(self.unusedTitleLabel);
        make.height.mas_equalTo(19);
    }];
    [self.budgetAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.budgetTitleLabel);
        make.left.right.mas_equalTo(self.unusedAmountLabel);
    }];
    
    [self.costTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.budgetTitleLabel.mas_bottom).mas_offset(kInsetV);
        make.left.right.mas_equalTo(self.unusedTitleLabel);
        make.height.mas_equalTo(19);
    }];
    [self.costAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.costTitleLabel);
        make.left.right.mas_equalTo(self.unusedAmountLabel);
    }];

    [self.unsetTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.costTitleLabel.mas_bottom).mas_offset(kInsetV);
        make.left.right.mas_equalTo(self.unusedTitleLabel);
        make.height.mas_equalTo(19);
    }];
    [self.unsetAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.unsetTitleLabel);
        make.left.right.mas_equalTo(self.unusedAmountLabel);
    }];
}

- (void)bindMonthBudget:(CATBudget *)budget {
    if (!CATIsEmptyString(budget.unusedAmount)) {
        self.unusedAmountLabel.textColor = [budget.unusedAmount doubleValue]>=0.0?UIColorMakeWithHex(CAT_THEME_COLOR_DARKEN2):UIColorRed;
        self.unusedAmountLabel.text = [NSString stringWithFormat:@"¥ %@", budget.unusedAmount];
    } else {
        self.unusedAmountLabel.textColor = UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK);
        self.unusedAmountLabel.text = @"---";
    }
    
    if (!CATIsEmptyString(budget.budgetAmount)) {
        self.budgetAmountLabel.text = [NSString stringWithFormat:@"¥ %@", budget.budgetAmount];
    } else {
        self.budgetAmountLabel.text = @"未设定预算";
    }
    
    self.costAmountLabel.text = [NSString stringWithFormat:@"¥ %@", budget.totalCost];
    self.unsetAmountLabel.text = [NSString stringWithFormat:@"¥ %@", budget.unsetBudgetAmount];
    self.iconView.highlightColor = UIColorMakeWithHex(CAT_THEME_COLOR);
}

- (CATCategoryIconView *)iconView {
    if (_iconView == nil) {
        _iconView = [[CATCategoryIconView alloc] init];
        _iconView.icon = UIImageMake(@"cat_month_budget");
        _iconView.highlightColor = UIColorMakeWithHex(CAT_THEME_COLOR);
        _iconView.state = CategoryIconStateHighlight;
    }
    return _iconView;
}

- (UILabel *)unusedTitleLabel {
    if (_unusedTitleLabel == nil) {
        _unusedTitleLabel = [[UILabel alloc] initWithFont:UIFontMake(kLargeFontSize) textColor:UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK)];
        _unusedTitleLabel.text = @"剩余预算";
    }
    return _unusedTitleLabel;
}

- (UILabel *)unusedAmountLabel {
    if (_unusedAmountLabel == nil) {
        _unusedAmountLabel = [[UILabel alloc] initWithFont:UIFontMake(kLargeFontSize) textColor:UIColorMakeWithHex(CAT_THEME_COLOR)];
        _unusedAmountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _unusedAmountLabel;
}

- (UIView *)sepLine {
    if (_sepLine == nil) {
        _sepLine = [[UIView alloc] init];
        _sepLine.backgroundColor = UIColorSeparator;
    }
    return _sepLine;
}

- (UILabel *)budgetTitleLabel {
    if (_budgetTitleLabel == nil) {
        _budgetTitleLabel = [[UILabel alloc] initWithFont:UIFontMake(kNormalFontSize) textColor:UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK_LIGHTEN)];
        _budgetTitleLabel.text = @"全部预算";
    }
    return _budgetTitleLabel;
}

- (UILabel *)budgetAmountLabel {
    if (_budgetAmountLabel == nil) {
        _budgetAmountLabel = [[UILabel alloc] initWithFont:UIFontMake(kNormalFontSize) textColor:UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK_LIGHTEN)];
        _budgetAmountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _budgetAmountLabel;
}

- (UILabel *)costTitleLabel {
    if (_costTitleLabel == nil) {
        _costTitleLabel = [[UILabel alloc] initWithFont:UIFontMake(kNormalFontSize) textColor:UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK_LIGHTEN)];
        _costTitleLabel.text = @"全部花费";
    }
    return _costTitleLabel;
}

- (UILabel *)costAmountLabel {
    if (_costAmountLabel == nil) {
        _costAmountLabel = [[UILabel alloc] initWithFont:UIFontMake(kNormalFontSize) textColor:UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK_LIGHTEN)];
        _costAmountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _costAmountLabel;
}

- (UILabel *)unsetTitleLabel {
    if (_unsetTitleLabel == nil) {
        _unsetTitleLabel = [[UILabel alloc] initWithFont:UIFontMake(kNormalFontSize) textColor:UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK_LIGHTEN)];
        _unsetTitleLabel.text = @"未分配";
    }
    return _unsetTitleLabel;
}

- (UILabel *)unsetAmountLabel {
    if (_unsetAmountLabel == nil) {
        _unsetAmountLabel = [[UILabel alloc] initWithFont:UIFontMake(kNormalFontSize) textColor:UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK_LIGHTEN)];
        _unsetAmountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _unsetAmountLabel;
}

@end
