//
//  CATSegmentControl.m
//  CatAccounting
//
//  Created by ran on 2017/10/31.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATSegmentControl.h"

#define kItemWidth 90

@implementation CATSegmentItem

- (instancetype)initWithTitle:(NSString *)title selectAction:(CATSegmentItemAction)action {
    self = [super init];
    if (self) {
        _title = title;
        _action = [action copy];
    }
    return self;
}

@end

@interface CATSegmentControl ()
@property (nonatomic, strong) NSArray *itemViews;
@end

@implementation CATSegmentControl

- (instancetype)initWithSegmentItems:(NSArray<CATSegmentItem *> *)items defaultIndex:(NSInteger)defaultIndex {
    NSParameterAssert(items);
    self = [super init];
    if (self) {
        _items = items;
        _selectIndex = defaultIndex;
        self.layer.borderWidth = CATOnePixel*2;
        self.layer.borderColor = UIColorMakeWithHex(CAT_THEME_COLOR).CGColor;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    NSMutableArray *content = [NSMutableArray arrayWithCapacity:self.items.count];
    [self.items enumerateObjectsUsingBlock:^(CATSegmentItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label;
        if (idx == _selectIndex) {
            label = [[UILabel alloc] initWithFont:UIFontBoldMake(13.f) textColor:UIColorWhite];
            label.backgroundColor = UIColorMakeWithHex(CAT_THEME_COLOR);
        } else {
            label = [[UILabel alloc] initWithFont:UIFontBoldMake(13.f) textColor:UIColorMakeWithHex(CAT_THEME_COLOR)];
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        label.text = item.title;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onItemViewSelected:)]];
        label.frame = CGRectMake(idx*kItemWidth, 0, kItemWidth, kSegControlHeight);
        [self addSubview:label];
        [content addObject:label];
        
        if (idx != self.items.count-1) {
            UIView *sep = [[UIView alloc] init];
            sep.backgroundColor = UIColorMakeWithHex(CAT_THEME_COLOR);
            sep.frame = CGRectMake(label.right, 0, CATOnePixel, kSegControlHeight);
            [self addSubview:sep];
        }
    }];
    self.itemViews = [content copy];
}

- (void)onItemViewSelected:(UIGestureRecognizer *)sender {
    UILabel *selected = (UILabel *)sender.view;
    NSInteger index = [self.itemViews indexOfObject:selected];
    self.selectIndex = index;
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    if (_selectIndex == selectIndex) {
        return;
    }
    
    if (_selectIndex != -1) {
        UILabel *selectedLabel = self.itemViews[_selectIndex];
        selectedLabel.backgroundColor = UIColorClear;
        selectedLabel.textColor = UIColorMakeWithHex(CAT_THEME_COLOR);
    }
    
    UILabel *newLabel = self.itemViews[selectIndex];
    newLabel.backgroundColor = UIColorMakeWithHex(CAT_THEME_COLOR);
    newLabel.textColor = UIColorWhite;
    
    CATSegmentItem *item = self.items[selectIndex];
    if (item.action) {
        item.action();
    }
    
    _selectIndex = selectIndex;
}

- (CATSegmentItem *)selectedItem {
    return self.items[self.selectIndex];
}

- (CGFloat)expectWidth {
    return kItemWidth*self.items.count;
}

@end
