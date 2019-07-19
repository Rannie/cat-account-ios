//
//  CATAccount.h
//  CatAccounting
//
//  Created by ran on 2017/9/12.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CATFundAccount.h"

typedef NS_ENUM(NSInteger, CATAccountType) {
    CATAccountTypePay = 0,
    CATAccountTypeIncome
};

@class CATCategory;

@interface CATAccount : NSObject <NSCopying>

@property (nonatomic, assign) NSInteger accountId;

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;

@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *accountDes;
@property (nonatomic, assign) CATAccountType type;
@property (nonatomic, strong) NSString *assFundAccount;

@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) CATCategory *category;

@property (nonatomic, assign) NSTimeInterval modifyTime;
@property (nonatomic, assign) NSTimeInterval createTime;

- (void)setDate:(NSDate *)date;
- (NSDate *)getAccountDate;
- (NSString *)monthAndDayDes;

- (BOOL)commitValidate:(NSString **)validationMsg;

@end
