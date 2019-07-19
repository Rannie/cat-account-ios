//
//  Macro.h
//  CatAccounting
//
//  Created by ran on 2017/9/12.
//  Copyright © 2017年 ran. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#import <UIKit/UIKit.h>
#import "CATThemeManager.h"
#import "CATUtil.h"

#define CAT_THEME_COLOR [CATThemeManager manager].currentTheme.themeColor
#define CAT_THEME_COLOR_LIGHTEN5 [CATThemeManager manager].currentTheme.themeColor_lighten5
#define CAT_THEME_COLOR_DARKEN2 [CATThemeManager manager].currentTheme.themeColor_darken2
#define CAT_BG_GRAY [CATThemeManager manager].currentTheme.backgroundColor
#define CAT_TEXT_COLOR_BLACK [CATThemeManager manager].currentTheme.textColor

#define CAT_TEXT_COLOR_BLACK_DARKEN @"#424242"
#define CAT_TEXT_COLOR_BLACK_LIGHTEN @"757575"

#define CATThemeImageMake(imgName) [CATUtil themeImageMake:imgName]

#define CAT_MARGIN (20.0f)

#define CATOnePixel CGFloatFromPixel(1.0f)

#define CAT_TIPS_SHOWTIME (0.45)

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#ifdef DEBUG
#define CATLog(...) NSLog((@"%@"), [NSString stringWithFormat:__VA_ARGS__])
#else
#define CATLog(...)
#endif

#define CATIsEmptyString(str) (!(str && [str isKindOfClass:NSString.class] && str.length > 0))
#define CATIsEmptyArray(arr) (!(arr && [arr isKindOfClass:NSArray.class] && arr.count > 0))
#define CATIsEmptyDictionary(dict) (!(dict && [dict isKindOfClass:NSDictionary.class] && dict.allKeys > 0))
#define CATIsEqualString(str1, str2) ([str1 isEqualToString:str2])

#define CATApplication [UIApplication sharedApplication]
#define CATDevice [UIDevice currentDevice]
#define CATUserDefaults [NSUserDefaults standardUserDefaults]
#define CATNotificationCenter [NSNotificationCenter defaultCenter]
#define CATKeyWindow [UIApplication sharedApplication].keyWindow

#endif /* Macro_h */
