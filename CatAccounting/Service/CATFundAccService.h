//
//  CATFundAccService.h
//  CatAccounting
//
//  Created by ran on 2017/10/17.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CATFundAccount.h"

@interface CATFundAccService : NSObject

@property (nonatomic, strong) NSArray *fundAccList;
@property (nonatomic, strong) CATFundAccount *defaultAccount;

+ (instancetype)service;

- (void)configDefaultAccountWithName:(NSString *)accName;

- (NSArray *)fundNameList;
- (NSArray *)accColors;

- (void)outcome:(NSString *)outAmount inAccount:(NSString *)fundAccName;
- (void)income:(NSString *)income inAccount:(NSString *)fundAccName;
- (void)reduceOutcome:(NSString *)outAmount inAccount:(NSString *)fundAccName;
- (void)reduceIncome:(NSString *)income inAccount:(NSString *)fundAccName;

@end
