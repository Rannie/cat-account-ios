//
//  CATAddBillViewController.h
//  CatAccounting
//
//  Created by ran on 2017/9/13.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATBaseViewController.h"

@class CATAccount;
@interface CATAddBillViewController : CATBaseViewController

- (instancetype)initWithAccount:(CATAccount *)account;

- (void)showAnimateWithCompletion:(dispatch_block_t)completion;

@end
