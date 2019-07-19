//
//  CATUtil.h
//  CatAccounting
//
//  Created by ran on 2017/10/27.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CATTimeUtilHandler)(NSInteger year, NSInteger month, BOOL haveNext);

@interface CATUtil : NSObject

+ (NSNumberFormatter *)numberFormatter;
+ (NSString *)formattedNumberString:(id)numberValue;

+ (UIImage *)themeImageMake:(NSString *)imageName;

+ (void)getNextMonthWithCurYear:(NSInteger)year month:(NSInteger)month result:(CATTimeUtilHandler)result;
+ (void)getPrevMonthWithCurYear:(NSInteger)year month:(NSInteger)month result:(CATTimeUtilHandler)result;
+ (void)getNextMonthWithCurYear:(NSInteger)year month:(NSInteger)month nextYear:(NSInteger *)year nextMonth:(NSInteger *)month;
+ (void)getPrevMonthWithCurYear:(NSInteger)year month:(NSInteger)month prevYear:(NSInteger *)year prevMonth:(NSInteger *)month;

@end
