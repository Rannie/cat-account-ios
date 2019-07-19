//
//  CATCategoryDataSet.m
//  CatAccounting
//
//  Created by ran on 2017/9/28.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATCategoryDataSet.h"
#import "CATAccount.h"

@interface CATCategoryDataSet ()

@property (nonatomic, strong) NSMutableArray *setList;

@end

@implementation CATCategoryDataSet

- (instancetype)init {
    self = [super init];
    if (self) {
        _setList = [NSMutableArray array];
    }
    return self;
}

- (void)caculateTotal {
    @autoreleasepool {
        __block NSDecimalNumber *sum = [NSDecimalNumber decimalNumberWithString:@"0.00"];
        [_setList enumerateObjectsUsingBlock:^(CATAccount * _Nonnull account, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDecimalNumber *cost = [NSDecimalNumber decimalNumberWithString:account.amount];
            sum = [sum decimalNumberByAdding:cost];
        }];
        _totalCost = [sum doubleValue];
    }
}

- (void)caculatePercent:(float)sum {
    self.percent = (float)(self.totalCost/sum);
}

- (void)appendAccount:(CATAccount *)account { 
    [_setList addObject:account];
}

- (NSArray *)accountList {
    return [_setList copy];
}

@end
