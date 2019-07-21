//
//  CATPurpleTheme.m
//  CatAccounting
//
//  Created by Rann on 2019/7/21.
//  Copyright © 2019 ran. All rights reserved.
//

#import "CATPurpleTheme.h"

@implementation CATPurpleTheme

- (NSString *)themeName {
    return @"紫喵";
}

- (NSString *)themeColor {
    return @"#A5678E";
}

- (NSString *)backgroundColor {
    return @"#fafafa";
}

- (NSString *)textColor {
    return @"#616161";
}

- (NSString *)themeColor_lighten5 {
    return @"#C57BA9";
}

- (NSString *)themeColor_darken2 {
    return @"#835070";
}

- (NSString *)assetSuffix {
    return @"_purple_t";
}

- (NSArray *)themeScreenShots {
    return @[@"purple_home", @"purple_more"];
}

@end
