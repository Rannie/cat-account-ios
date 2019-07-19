//
//  CATAccount+WCTTableCoding.h
//  CatAccounting
//
//  Created by ran on 2017/9/13.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATAccount.h"
#import <WCDB/WCDB.h>

@interface CATAccount (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(accountId)
WCDB_PROPERTY(year)
WCDB_PROPERTY(month)
WCDB_PROPERTY(day)
WCDB_PROPERTY(amount)
WCDB_PROPERTY(accountDes)
WCDB_PROPERTY(type)
WCDB_PROPERTY(categoryName)
WCDB_PROPERTY(modifyTime)
WCDB_PROPERTY(createTime)
WCDB_PROPERTY(assFundAccount)

@end
