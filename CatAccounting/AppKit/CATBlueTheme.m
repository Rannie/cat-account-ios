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
    return @"天海蓝";
}

- (NSString *)themeColor {
    return @"#03a9f4";
}

- (NSString *)backgroundColor {
    return @"#fafafa";
}

- (NSString *)textColor {
    return @"#616161";
}

- (NSString *)themeColor_lighten5 {
    return @"#e1f5fe";
}

- (NSString *)themeColor_darken2 {
    return @"#0288d1";
}

- (NSString *)assetSuffix {
    return @"_blue_t";
}

- (NSArray *)themeScreenShots {
    return @[@"bill_blue", @"addbill_blue", @"wallet_blue"];
}

@end
