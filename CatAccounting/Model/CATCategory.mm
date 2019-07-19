//
//  CATCategory.m
//  CatAccounting
//
//  Created by ran on 2017/9/13.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATCategory.h"
#import <WCDB/WCDB.h>

@interface CATCategory () <WCTTableCoding>

@end

@implementation CATCategory

WCDB_IMPLEMENTATION(CATCategory)

WCDB_SYNTHESIZE(CATCategory, categoryId)
WCDB_SYNTHESIZE(CATCategory, name)
WCDB_SYNTHESIZE(CATCategory, iconName)
WCDB_SYNTHESIZE(CATCategory, builtin)
WCDB_SYNTHESIZE(CATCategory, income)
WCDB_SYNTHESIZE(CATCategory, sortIndex)
WCDB_SYNTHESIZE(CATCategory, color)

WCDB_PRIMARY_AUTO_INCREMENT(CATCategory, categoryId)

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"sortIndex" : @"index"};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSNumber *indexNumber = dic[@"index"];
    if (![indexNumber isKindOfClass:[NSNumber class]]) return NO;
    self.sortIndex = [indexNumber integerValue];
    return YES;
}
- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    dic[@"index"] = @(self.sortIndex);
    return YES;
}

@end
