//
//  CATRedTheme.m
//  CatAccounting
//
//  Created by Rann on 2019/7/21.
//  Copyright © 2019 ran. All rights reserved.
//

#import "CATRedTheme.h"

@implementation CATRedTheme

- (NSString *)themeName {
    return @"红喵";
}

- (NSString *)themeColor {
    return @"#DA2864";
}

- (NSString *)backgroundColor {
    return @"#fafafa";
}

- (NSString *)textColor {
    return @"#616161";
}

- (NSString *)themeColor_lighten5 {
    return @"#F52E71";
}

- (NSString *)themeColor_darken2 {
    return @"#B92456";
}

- (NSString *)assetSuffix {
    return @"_red_t";
}

- (NSArray *)themeScreenShots {
    return @[@"red_home", @"red_more"];
}

@end
