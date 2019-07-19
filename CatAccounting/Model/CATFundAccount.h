//
//  CATFundAccountDataSet.h
//  CatAccounting
//
//  Created by ran on 2017/10/12.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CATFundAccount : NSObject

@property (nonatomic, strong) NSString *fundAccName;
@property (nonatomic, assign) double totalOutcome;
@property (nonatomic, assign) double totalIncome;
@property (nonatomic, assign) double totalAssets;

@property (nonatomic, assign) NSInteger curYear;
@property (nonatomic, assign) NSInteger curMonth;
@property (nonatomic, assign) double curOutcome;
@property (nonatomic, assign) double curIncome;

@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, strong) UIColor *assColor;

- (void)caculateAssets;

@end
