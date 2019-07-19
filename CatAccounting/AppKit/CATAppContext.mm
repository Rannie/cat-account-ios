//
//  CATAppContext.m
//  CatAccounting
//
//  Created by ran on 2017/9/11.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATAppContext.h"
#import <UMMobClick/MobClick.h>
#import "CATDBManager.h"
#import "CATCategoryService.h"
#import "CATFundAccService.h"

static NSString * const kCATAutoPresentPageKey = @"kCATAutoPresentPageKey";

@implementation CATAppContext

+ (instancetype)context {
    static dispatch_once_t onceToken;
    static CATAppContext *context;
    dispatch_once(&onceToken, ^{
        context = [[CATAppContext alloc] init];
    });
    return context;
}

- (void)startupFlow {
    // setup log
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // log file
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
    
    DDLogDebug(@"%@", CATApplication.documentsPath);
#if DEBUG
    [MobClick setLogEnabled:YES];
#endif
    UMConfigInstance.appKey = @"59b73b62a40fa367bd000014";
    UMConfigInstance.channelId = @"App Store";
    [MobClick setAppVersion:[UIApplication sharedApplication].appVersion];
    [MobClick startWithConfigure:UMConfigInstance];
    
    [[CATThemeManager manager] setup];
    
    [CATDBManager manager];
    [CATCategoryService service];
    [CATFundAccService service];
    
    DDLogInfo(@"[App Context]: finish startup flow");
}

- (void)setAutoPresentAddBillPage:(BOOL)autoPresentAddBillPage {
    [KeyValueStore setBool:autoPresentAddBillPage forKey:kCATAutoPresentPageKey];
}

- (BOOL)autoPresentAddBillPage {
    return [KeyValueStore boolForKey:kCATAutoPresentPageKey defaultValue:NO];
}

@end
