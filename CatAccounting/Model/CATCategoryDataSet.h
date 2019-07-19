//
//  CATCategoryDataSet.h
//  CatAccounting
//
//  Created by ran on 2017/9/28.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CATAccount, CATCategory;
@interface CATCategoryDataSet : NSObject

@property (nonatomic, strong) CATCategory *category;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, strong) NSArray *accountList;
@property (nonatomic, assign) float totalCost;
@property (nonatomic, assign) float percent; //0.00 ~ 1.00

- (void)appendAccount:(CATAccount *)account;
- (void)caculateTotal;
- (void)caculatePercent:(float)sum;

@end
