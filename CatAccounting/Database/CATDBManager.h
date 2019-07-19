//
//  CATDBManager.h
//  CatAccounting
//
//  Created by ran on 2017/9/12.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>

#define DBManager [CATDBManager manager]

@interface CATDBManager : NSObject

@property (nonatomic, strong, readonly) NSString *path;
@property (nonatomic, strong) WCTDatabase *database;

+ (instancetype)manager;

@end
