//
//  CATCategory+WCTTableCoding.h
//  CatAccounting
//
//  Created by ran on 2017/9/13.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATCategory.h"
#import <WCDB/WCDB.h>

@interface CATCategory (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(categoryId)
WCDB_PROPERTY(name)
WCDB_PROPERTY(iconName)
WCDB_PROPERTY(builtin)
WCDB_PROPERTY(income)
WCDB_PROPERTY(sortIndex)
WCDB_PROPERTY(color)

@end
