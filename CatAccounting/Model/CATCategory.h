//
//  CATCategory.h
//  CatAccounting
//
//  Created by ran on 2017/9/13.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CATCategory : NSObject

@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, assign) BOOL builtin;
@property (nonatomic, assign) BOOL income;
@property (nonatomic, assign) NSInteger sortIndex;
@property (nonatomic, strong) NSString *color;

@end
