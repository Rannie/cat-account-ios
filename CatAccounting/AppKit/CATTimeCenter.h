//
//  CATTimeCenter.h
//  CatAccounting
//
//  Created by ran on 2017/10/31.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TimeCenter [CATTimeCenter center]

typedef void (^TimeHandler)(NSInteger newYear, NSInteger newMonth, BOOL haveNext);

@interface CATTimeCenter : NSObject

@property (nonatomic, assign, readonly) NSInteger catYear;
@property (nonatomic, assign, readonly) NSInteger catMonth;

@property (nonatomic, assign, readonly) NSInteger nowYear;
@property (nonatomic, assign, readonly) NSInteger nowMonth;

+ (instancetype)center;

- (void)getCurrentTime:(TimeHandler)timeHandler;
- (void)moveNext:(TimeHandler)nextHandler;
- (void)movePrev:(TimeHandler)prevHandler;

@end
