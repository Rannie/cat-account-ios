//
//  CATMonthDataView.h
//  CatAccounting
//
//  Created by ran on 2017/9/19.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CATMonthDataView;
@protocol CATMonthDataViewDelegate <NSObject>

- (void)dataViewShouldAddMonth:(CATMonthDataView *)dataView;
- (void)dataViewShouldReduceMonth:(CATMonthDataView *)dataView;

@end

@interface CATMonthDataView : UIView

@property (nonatomic, weak) id<CATMonthDataViewDelegate> delegate;
@property (nonatomic, strong) NSString *yearText;
@property (nonatomic, strong) NSString *monthText;
@property (nonatomic, strong) NSString *expenditure;
@property (nonatomic, strong) NSString *income;

- (void)hideNext;
- (void)showNext;

@end
