//
//  CATBillFeed.m
//  CatAccounting
//
//  Created by ran on 2017/9/20.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATBillFeed.h"

@interface CATBillDayFeed ()

@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation CATBillDayFeed

- (instancetype)init {
    self = [super init];
    if (self) {
        _list = [NSMutableArray array];
    }
    return self;
}

- (void)caculateAccountDataAndSignLocation {
    @autoreleasepool {
        __block NSDecimalNumber *exp = [NSDecimalNumber decimalNumberWithString:@"0.00"];
        __block NSDecimalNumber *inc = [NSDecimalNumber decimalNumberWithString:@"0.00"];
        [self.list enumerateObjectsUsingBlock:^(CATAccount * _Nonnull account, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:account.amount];
            if (account.type == CATAccountTypePay) {
                exp = [exp decimalNumberByAdding:amount];
            } else {
                inc = [inc decimalNumberByAdding:amount];
            }
            
            if (idx != self.list.count-1) {
                account.loc = CATAccountFeedLocNormal;
            } else {
                account.loc = CATAccountFeedLocBottom;
            }
        }];
        
        self.exp = [exp stringValue];
        self.inc = [inc stringValue];
    }
}

- (BOOL)haveExp {
    return [self.exp floatValue] > 0.00;
}

- (BOOL)haveInc {
    return [self.inc floatValue] > 0.00;
}

- (void)addAccount:(CATAccount *)account {
    [self.list addObject:account];
}

- (void)removeAccount:(CATAccount *)account {
    [self.list removeObject:account];
}

- (NSArray<CATAccount *> *)accountList {
    return self.list;
}

@end

static void *kFeedLocKey = &kFeedLocKey;
@implementation CATAccount (ListShow)

- (void)setLoc:(CATAccountFeedLoc)loc {
    [self setAssociateValue:@(loc) withKey:kFeedLocKey];
}

- (CATAccountFeedLoc)loc {
    return [[self getAssociatedValueForKey:kFeedLocKey] integerValue];
}

@end
