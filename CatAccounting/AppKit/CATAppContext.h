//
//  CATAppContext.h
//  CatAccounting
//
//  Created by ran on 2017/9/11.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AppContext [CATAppContext context]

@interface CATAppContext : NSObject

@property (nonatomic, assign) BOOL autoPresentAddBillPage;

+ (instancetype)context;

- (void)startupFlow;

@end
