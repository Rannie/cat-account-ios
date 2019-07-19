//
//  CATThemeManager.h
//  CatAccounting
//
//  Created by ran on 2017/10/19.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CATThemeProtocol.h"

@interface CATThemeManager : NSObject

@property (nonatomic, strong, readonly) NSArray<id<CATThemeProtocol>> *themeList;
@property (nonatomic, strong) id<CATThemeProtocol> currentTheme;

+ (instancetype)manager;
- (void)setup;

@end
