//
//  CATThemeCell.m
//  CatAccounting
//
//  Created by ran on 2017/11/1.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATThemeCell.h"
#import <BEMCheckBox/BEMCheckBox.h>

#define kInset 15
#define kSpace 35
#define kScreenShotWidth 150
#define kScreenShotHeight 300
#define kShotCount 2

@interface CATThemeCell ()
@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *imageContent;
@property (nonatomic, strong) BEMCheckBox *checkbox;
@property (nonatomic, strong) UIView *sepLine;
@property (nonatomic, strong) NSArray<UIImageView *> *imageViewList;
@end

@implementation CATThemeCell

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
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.checkbox];
    [self.contentView addSubview:self.sepLine];
    [self.contentView addSubview:self.colorView];
    [self.contentView addSubview:self.imageContent];
    
    self.colorView.frame = CGRectMake(0, kInset, 4, 24);
    self.titleLabel.frame = CGRectMake(kInset, kInset, 120, 24);
    self.checkbox.frame = CGRectMake(SCREEN_WIDTH-22-CAT_MARGIN, kInset, 22, 22);
    self.imageContent.frame = CGRectMake(0, self.titleLabel.bottom+kInset, SCREEN_WIDTH, kScreenShotHeight);
    self.sepLine.frame = CGRectMake(0, kThemeCellHeight-kInset, SCREEN_WIDTH, kInset);
    
    CGFloat right = 0.0;
    NSMutableArray *imageViewContent = [NSMutableArray arrayWithCapacity:kShotCount];
    for (int i = 0; i < kShotCount; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kInset +i*kScreenShotWidth+i*kSpace, 0, kScreenShotWidth, kScreenShotHeight)];
        [self.imageContent addSubview:imgView];
        [imageViewContent addObject:imgView];
        right = imgView.right+kSpace;
    }
    self.imageViewList = [imageViewContent copy];
    self.imageContent.contentSize = CGSizeMake(right, 0.0);
}

- (void)bindTheme:(id<CATThemeProtocol>)theme {
    self.titleLabel.text = [theme themeName];
    UIColor *themeColor = UIColorMakeWithHex([theme themeColor]);
    self.checkbox.onFillColor = themeColor;
    self.checkbox.onTintColor = themeColor;
    self.colorView.backgroundColor = themeColor;
    
    [self.imageViewList enumerateObjectsUsingBlock:^(UIImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        if (theme.themeScreenShots.count) {
            NSString *imgName = [theme themeScreenShots][idx];
            imageView.image = UIImageMake(imgName);
        }
    }];
}

- (void)setChecked:(BOOL)checked animated:(BOOL)animated {
    [_checkbox setOn:checked animated:animated];
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFont:UIFontMake(16.0f) textColor:UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK)];
    }
    return _titleLabel;
}

- (BEMCheckBox *)checkbox {
    if (_checkbox == nil) {
        _checkbox = [[BEMCheckBox alloc] init];
        _checkbox.lineWidth = 1;
        _checkbox.userInteractionEnabled = NO;
        _checkbox.onCheckColor = UIColorWhite;
    }
    return _checkbox;
}

- (UIView *)sepLine {
    if (_sepLine == nil) {
        _sepLine = [[UIView alloc] init];
        _sepLine.backgroundColor = UIColorMakeWithHex(CAT_BG_GRAY);
    }
    return _sepLine;
}

- (UIView *)colorView {
    if (_colorView == nil) {
        _colorView = [[UIView alloc] init];
        _colorView.layer.cornerRadius = 1;
    }
    return _colorView;
}

- (UIScrollView *)imageContent {
    if (_imageContent == nil) {
        _imageContent = [[UIScrollView alloc] init];
        _imageContent.showsHorizontalScrollIndicator = NO;
    }
    return _imageContent;
}

@end
