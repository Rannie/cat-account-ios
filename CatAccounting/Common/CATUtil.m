//
//  CATUtil.m
//  CatAccounting
//
//  Created by ran on 2017/10/27.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATUtil.h"
#import "CATThemeManager.h"

@implementation CATUtil

+ (NSNumberFormatter *)numberFormatter {
    static dispatch_once_t onceToken;
    static NSNumberFormatter *formatter;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
        formatter.maximumFractionDigits = 2;
        formatter.minimumFractionDigits = 0;
    });
    return formatter;
}

+ (NSString *)formattedNumberString:(id)numberValue {
    if ([numberValue isKindOfClass:[NSNumber class]]) {
        return [[self numberFormatter] stringFromNumber:numberValue];
    }
    else if ([numberValue isKindOfClass:[NSString class]]) {
        return [[self numberFormatter] stringFromNumber:@([numberValue doubleValue])];
    }
    return nil;
}

+ (UIImage *)themeImageMake:(NSString *)imageName {
    id<CATThemeProtocol> theme = [CATThemeManager manager].currentTheme;
    NSString *imgName = [NSString stringWithFormat:@"%@%@", imageName, [theme assetSuffix]];
    return UIImageMake(imgName);
}

+ (void)getNextMonthWithCurYear:(NSInteger)year month:(NSInteger)month result:(CATTimeUtilHandler)result {
    [self getNextMonthWithCurYear:year month:month nextYear:&year nextMonth:&month];
    NSDate *now = [NSDate date];
    BOOL haveNext = YES;
    if (now.year == year && now.month == month) {
        haveNext = NO;
    }
    
    if (result) {
        result(year, month, haveNext);
    }
}

+ (void)getPrevMonthWithCurYear:(NSInteger)year month:(NSInteger)month result:(CATTimeUtilHandler)result {
    [self getPrevMonthWithCurYear:year month:month prevYear:&year prevMonth:&month];
    NSDate *now = [NSDate date];
    BOOL haveNext = YES;
    if (now.year == year && now.month == month) {
        haveNext = NO;
    }
    
    if (result) {
        result(year, month, haveNext);
    }
}

+ (void)getNextMonthWithCurYear:(NSInteger)year month:(NSInteger)month nextYear:(NSInteger *)nyear nextMonth:(NSInteger *)nmonth {
    if (month == 12) {
        year += 1;
        month = 1;
    } else {
        month += 1;
    }
    
    *nyear = year;
    *nmonth = month;
}

+ (void)getPrevMonthWithCurYear:(NSInteger)year month:(NSInteger)month prevYear:(NSInteger *)pyear prevMonth:(NSInteger *)pmonth {
    if (month == 1) {
        year -= 1;
        month = 12;
    } else {
        month -= 1;
    }
    
    *pyear = year;
    *pmonth = month;
}

@end
