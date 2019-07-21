//
//  CATBlueTheme.m
//  CatAccounting
//
//  Created by ran on 2017/11/1.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATBlueTheme.h"

@implementation CATBlueTheme

- (NSString *)themeName {
    return @"蓝喵";
}

- (NSString *)themeColor {
    return @"#33539E";
}

- (NSString *)backgroundColor {
    return @"#fafafa";
}

- (NSString *)textColor {
    return @"#616161";
}

- (NSString *)themeColor_lighten5 {
    return @"#3C62BB";
}

- (NSString *)themeColor_darken2 {
    return @"#26407D";
}

- (NSString *)assetSuffix {
    return @"_blue_t";
}

- (NSArray *)themeScreenShots {
    return @[@"blue_home", @"blue_more"];
}

@end
