//
//  CATCategoryService.h
//  CatAccounting
//
//  Created by ran on 2017/9/12.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CATCategory.h"

@interface CATCategoryService : NSObject

@property (nonatomic, strong, readonly) NSArray<CATCategory *> *outcomeCategoryList;
@property (nonatomic, strong, readonly) NSArray<CATCategory *> *incomeCategoryList;

+ (instancetype)service;

- (CATCategory *)queryCategoryWithName:(NSString *)cateName income:(BOOL)isIncome;
- (void)addCustomCategoryWithName:(NSString *)name income:(BOOL)isIncome;
- (NSArray<CATCategory *> *)fetchCustomCategoriesWithIncome:(BOOL)isIncome;

@end
