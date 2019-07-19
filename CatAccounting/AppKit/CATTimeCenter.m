//
//  CATTimeCenter.m
//  CatAccounting
//
//  Created by ran on 2017/10/31.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATTimeCenter.h"

@interface CATTimeCenter ()
@property (nonatomic, assign, readwrite) NSInteger catYear;
@property (nonatomic, assign, readwrite) NSInteger catMonth;
@end

@implementation CATTimeCenter

+ (instancetype)center {
    static dispatch_once_t onceToken;
    static CATTimeCenter *instance;
    dispatch_once(&onceToken, ^{
        instance = [[CATTimeCenter alloc] initCenter];
    });
    return instance;
}

- (instancetype)initCenter {
    if (self = [super init]) {}
    return self;
}

- (void)getCurrentTime:(TimeHandler)timeHandler {
    if (timeHandler) {
        timeHandler(self.nowYear, self.nowMonth, NO);
    }
}

- (void)moveNext:(TimeHandler)nextHandler {
    
}

- (void)movePrev:(TimeHandler)prevHandler {
    
}

- (NSInteger)nowYear {
    NSDate *date = [NSDate date];
    return date.year;
}

- (NSInteger)nowMonth {
    NSDate *date = [NSDate date];
    return date.month;
}

@end
