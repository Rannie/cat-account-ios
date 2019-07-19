//
//  CATStaticTableSectionData.m
//  CatAccounting
//
//  Created by ran on 2017/9/29.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATStaticTableSectionData.h"

@implementation CATStaticTableSectionData

- (instancetype)initWithTitle:(NSString *)title staticCellDataList:(NSArray<CATStaticTableCellData *> *)cellDataList {
    self = [super init];
    if (self) {
        _title = title;
        _cellStaticDataList = cellDataList;
        _headerHeight = 20;
        _footerHeight = 0.01;
    }
    return self;
}

@end
