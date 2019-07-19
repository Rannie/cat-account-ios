//
//  CATThemeProtocol.h
//  CatAccounting
//
//  Created by ran on 2017/10/19.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CATThemeProtocol <NSObject>

@required
- (NSString *)themeColor;
- (NSString *)backgroundColor; 
- (NSString *)textColor;
- (NSString *)themeColor_lighten5;
- (NSString *)themeColor_darken2;

- (NSString *)assetSuffix;

- (NSString *)themeName;
- (NSArray *)themeScreenShots;

@end
