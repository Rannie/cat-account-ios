//
//  CATFundAccCell.m
//  CatAccounting
//
//  Created by ran on 2017/10/23.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATFundAccCell.h"
#import "CATFundAccount.h"

#define kIconContentSize 25
#define kIconSize 20

@interface CATFundAccCell ()
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UIImageView *accIconView;
@property (nonatomic, strong) UIView *iconContent;
@property (nonatomic, strong) UILabel *accNameLabel;
@property (nonatomic, strong) UILabel *assetLabel;
@end

@implementation CATFundAccCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorClear;
        self.contentView.backgroundColor = UIColorClear;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self.contentView addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    
    [self.content addSubview:self.iconContent];
    [self.content addSubview:self.accNameLabel];
    [self.content addSubview:self.assetLabel];
    
    [self.iconContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.content).mas_offset(CAT_MARGIN-5);
        make.width.height.mas_equalTo(kIconContentSize);
        make.centerY.mas_equalTo(self.content);
    }];
    [self.accNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconContent.mas_right).mas_offset(15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(21);
        make.centerY.mas_equalTo(self.content);
    }];
    [self.assetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.content).mas_offset(-CAT_MARGIN+5);
        make.left.mas_equalTo(self.accNameLabel.mas_right).mas_offset(15);
        make.centerY.mas_equalTo(self.content);
        make.height.mas_equalTo(21);
    }];
    
    [self.iconContent addSubview:self.accIconView];
    [self.accIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kIconSize);
        make.center.mas_equalTo(self.iconContent);
    }];
}

- (void)bindFundAcc:(CATFundAccount *)fundAcc {
    self.iconContent.backgroundColor = fundAcc.assColor;
    self.accIconView.image = UIImageMake(fundAcc.iconName);
    self.accNameLabel.text = fundAcc.fundAccName;
    self.assetLabel.text = [CATUtil formattedNumberString:@(fundAcc.totalAssets)];
}

- (UIView *)content {
    if (_content == nil) {
        _content = [[UIView alloc] init];
        _content.backgroundColor = UIColorWhite;
        _content.layer.cornerRadius = 3.0f;
    }
    return _content;
}

- (UIView *)iconContent {
    if (_iconContent == nil) {
        _iconContent = [[UIView alloc] init];
        _iconContent.layer.cornerRadius = 2.0f;
    }
    return _iconContent;
}

- (UIImageView *)accIconView {
    if (_accIconView == nil) {
        _accIconView = [[UIImageView alloc] init];
        _accIconView.userInteractionEnabled = YES;
    }
    return _accIconView;
}

- (UILabel *)accNameLabel {
    if (_accNameLabel == nil) {
        _accNameLabel = [[UILabel alloc] initWithFont:UIFontMake(15.0f) textColor:UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK)];
    }
    return _accNameLabel;
}

- (UILabel *)assetLabel {
    if (_assetLabel == nil) {
        _assetLabel = [[UILabel alloc] initWithFont:UIFontMake(15.0f) textColor:UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK)];
        _assetLabel.textAlignment = NSTextAlignmentRight;
    }
    return _assetLabel;
}

@end
