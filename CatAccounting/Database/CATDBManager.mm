//
//  CATDBManager.m
//  CatAccounting
//
//  Created by ran on 2017/9/12.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATDBManager.h"
#import <WCDB/WCDB.h>

@interface CATDBManager ()
@end

@implementation CATDBManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static CATDBManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[CATDBManager alloc] initManager];
    });
    return instance;
}

- (instancetype)initManager {
    if (self = [super init]) {
        _database = [[WCTDatabase alloc] initWithPath:self.path];
        if (![_database canOpen]) {
            DDLogError(@"[DBManager]: can not open database!");
        }
    }
    return self;
}

- (NSString *)path {
    return [CATApplication.documentsPath stringByAppendingPathComponent:@"database/cat.db"];
}

@end
