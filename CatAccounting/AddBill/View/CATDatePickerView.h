//
//  CATDatePickerView.h
//  CatAccounting
//
//  Created by ran on 2017/9/14.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CATDatePickerView;
@protocol CATDatePickerViewDelegate <NSObject>

- (void)datePickerViewDidSelectedCancelButton:(CATDatePickerView *)datePickerView;
- (void)datePickerView:(CATDatePickerView *)datePickerView didSelectedDate:(NSDate *)date;

@end

@interface CATDatePickerView : UIView

@property (nonatomic, weak) id<CATDatePickerViewDelegate> delegate;
@property (nonatomic, strong, readonly) UIDatePicker *datePicker;

@end
