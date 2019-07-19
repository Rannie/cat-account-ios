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
    return @"青草绿";
}

- (NSString *)themeColor {
    return @"#cddc39";
}

- (NSString *)backgroundColor {
    return @"#fafafa";
}

- (NSString *)textColor {
    return @"#616161";
}

- (NSString *)themeColor_lighten5 {
    return @"#f9fbe7";
}

- (NSString *)themeColor_darken2 {
    return @"#afb42b";
}

- (NSString *)assetSuffix {
    return @"_green_t";
}

- (NSArray *)themeScreenShots {
    return @[@"bill_green", @"addbill_green", @"wallet_green"];
}

@end
