//
//  CATInfoView.h
//  CatAccounting
//
//  Created by ran on 2017/9/13.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kInfoViewHeight 93

@protocol CATInfoViewDelegate <NSObject>

- (void)infoViewDidClickDateButton;
- (void)infoViewDidClickRemarkButton;
- (void)infoViewDidClickSourceButton;

@end

@interface CATInfoView : UIView

@property (nonatomic, weak) id<CATInfoViewDelegate> delegate;

@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *dateStr;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *source;

@end
