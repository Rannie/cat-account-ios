//
//  CATThemeManager.m
//  CatAccounting
//
//  Created by ran on 2017/10/19.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATThemeManager.h"
#import "CATDefaultTheme.h"
#import "QMUIConfigurationTemplate.h"
#import "CATGreenTheme.h"
#import "CATBlueTheme.h"
#import "CATRedTheme.h"
#import "CATPurpleTheme.h"

@implementation CATThemeManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static CATThemeManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initManager];
    });
    return manager;
}

- (instancetype)initManager {
    self = [super init];
    if (self) {
        CATDefaultTheme *defaultTheme = [[CATDefaultTheme alloc] init];
        CATGreenTheme *greenTheme = [[CATGreenTheme alloc] init];
        CATBlueTheme *blueTheme = [[CATBlueTheme alloc] init];
        CATRedTheme *redTheme = [[CATRedTheme alloc] init];
        CATPurpleTheme *purpleTheme = [[CATPurpleTheme alloc] init];
        _themeList = @[defaultTheme, greenTheme, blueTheme, redTheme, purpleTheme];
    }
    return self;
}

- (void)setup {
    NSString *userTheme = [KeyValueStore stringForKey:@"CATThemeName"];
    if (!CATIsEmptyString(userTheme)) {
        for (id<CATThemeProtocol> theme in self.themeList) {
            if (CATIsEqualString(theme.themeName, userTheme)) {
                self.currentTheme = theme;
                return;
            }
        }
    }
    
    // use default
    self.currentTheme = [self.themeList firstObject];
}

- (void)setCurrentTheme:(id<CATThemeProtocol>)currentTheme {
    if (_currentTheme == currentTheme)
        return;
    
    _currentTheme = currentTheme;
    [QMUIConfigurationTemplate setupConfigurationTemplate];
    [KeyValueStore setString:currentTheme.themeName forKey:@"CATThemeName"];
    [[NSNotificationCenter defaultCenter] postNotificationName:CATThemeDidUpdateNotification object:nil];
}

@end
