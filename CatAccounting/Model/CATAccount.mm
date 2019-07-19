//
//  CATAccount.m
//  CatAccounting
//
//  Created by ran on 2017/9/12.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATAccount.h"
#import <WCDB/WCDB.h>
#import "CATFundAccService.h"

@interface CATAccount () <WCTTableCoding>

@end

@implementation CATAccount

WCDB_IMPLEMENTATION(CATAccount)

WCDB_SYNTHESIZE(CATAccount, accountId)
WCDB_SYNTHESIZE(CATAccount, year)
WCDB_SYNTHESIZE(CATAccount, month)
WCDB_SYNTHESIZE(CATAccount, day)
WCDB_SYNTHESIZE(CATAccount, amount)
WCDB_SYNTHESIZE(CATAccount, accountDes)
WCDB_SYNTHESIZE(CATAccount, categoryName)
WCDB_SYNTHESIZE(CATAccount, modifyTime)
WCDB_SYNTHESIZE(CATAccount, createTime)
WCDB_SYNTHESIZE(CATAccount, type)
WCDB_SYNTHESIZE(CATAccount, assFundAccount)

WCDB_INDEX(CATAccount, "_timeIndex", year)
WCDB_INDEX(CATAccount, "_timeIndex", month)

WCDB_PRIMARY_AUTO_INCREMENT(CATAccount, accountId)

- (instancetype)init {
    self = [super init];
    if (self) {
        _type = CATAccountTypePay;
        _assFundAccount = [CATFundAccService service].defaultAccount.fundAccName;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    CATAccount *account = [[CATAccount alloc] init];
    account.accountId = self.accountId;
    account.year = self.year;
    account.month = self.month;
    account.day = self.day;
    account.amount = self.amount;
    account.accountDes = self.accountDes;
    account.categoryName = self.categoryName;
    account.modifyTime = self.modifyTime;
    account.createTime = self.createTime;
    account.type = self.type;
    account.assFundAccount = self.assFundAccount;
    return account;
}

- (void)setDate:(NSDate *)date {
    self.year = date.year;
    self.month = date.month;
    self.day = date.day;
}

- (NSDate *)getAccountDate {
    return [NSDate dateWithString:[NSString stringWithFormat:@"%4zd-%2zd-%2zd", self.year, self.month, self.day] format:@"yyyy-MM-dd"];
}

- (NSString *)monthAndDayDes {
    return [NSString stringWithFormat:@"%2zd月%2zd日", self.month, self.day];
}

- (BOOL)commitValidate:(NSString *__autoreleasing *)validationMsg {
    if (CATIsEmptyString(self.amount) || [self.amount floatValue] == 0.0f) {
        *validationMsg = @"请输入金额";
        return NO;
    }
    if (CATIsEmptyString(self.categoryName)) {
        *validationMsg = @"请选择账目类型";
        return NO;
    }
    if (!(self.year && self.month && self.day)) {
        *validationMsg = @"请选择日期";
        return NO;
    }
    
    if ([self.amount hasSuffix:@"."]) {
        self.amount = [self.amount substringToIndex:self.amount.length-1];
    }
    return YES;
}

@end
