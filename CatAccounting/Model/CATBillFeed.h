//
//  CATBillFeed.h
//  CatAccounting
//
//  Created by ran on 2017/9/20.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CATAccount.h"

typedef NS_ENUM(NSInteger, CATAccountFeedLoc) {
    CATAccountFeedLocNormal = 0,
    CATAccountFeedLocBottom
};

@interface CATBillDayFeed : NSObject

@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, strong) NSString *exp;
@property (nonatomic, strong) NSString *inc;
@property (nonatomic, strong, readonly) NSArray<CATAccount *> *accountList;

- (void)caculateAccountDataAndSignLocation;
- (void)addAccount:(CATAccount *)account;
- (void)removeAccount:(CATAccount *)account;

- (BOOL)haveExp;
- (BOOL)haveInc;

@end

@interface CATAccount (ListShow)

@property (nonatomic, assign) CATAccountFeedLoc loc;

@end
