//
//  CATGreenTheme.m
//  CatAccounting
//
//  Created by ran on 2017/11/1.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATGreenTheme.h"

@implementation CATGreenTheme

- (NSString *)themeName {
    return @"绿喵";
}

- (NSString *)themeColor {
    return @"#16a5a3";
}

- (NSString *)backgroundColor {
    return @"#fafafa";
}

- (NSString *)textColor {
    return @"#616161";
}

- (NSString *)themeColor_lighten5 {
    return @"#19C1BF";
}

- (NSString *)themeColor_darken2 {
    return @"#0F8483";
}

- (NSString *)assetSuffix {
    return @"_green_t";
}

- (NSArray *)themeScreenShots {
    return @[@"green_home", @"green_more"];
}

@end
