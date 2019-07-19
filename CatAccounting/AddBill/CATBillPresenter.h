//
//  CATBillPresenter.h
//  CatAccounting
//
//  Created by ran on 2017/10/16.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CATAccount;
@interface CATBillPresenter : NSObject

+ (instancetype)presenter;

- (void)present;
- (void)presentWithAccount:(CATAccount *)account;
- (void)hide;

@end
