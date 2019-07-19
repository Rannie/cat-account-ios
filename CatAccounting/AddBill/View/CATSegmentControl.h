//
//  CATSegmentControl.h
//  CatAccounting
//
//  Created by ran on 2017/10/31.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSegControlHeight 28

typedef dispatch_block_t CATSegmentItemAction;

@interface CATSegmentItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) CATSegmentItemAction action;

- (instancetype)initWithTitle:(NSString *)title selectAction:(CATSegmentItemAction)action;

@end

@interface CATSegmentControl : UIView

@property (nonatomic, readonly, strong) CATSegmentItem *selectedItem;
@property (nonatomic, readonly, assign) CGFloat expectWidth;
@property (nonatomic, readonly, strong) NSArray<CATSegmentItem *> *items;

@property (nonatomic, assign) NSInteger selectIndex;

- (instancetype)initWithSegmentItems:(NSArray<CATSegmentItem *> *)items defaultIndex:(NSInteger)defaultIndex;

@end
