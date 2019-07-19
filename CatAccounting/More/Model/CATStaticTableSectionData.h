//
//  CATStaticTableSectionData.h
//  CatAccounting
//
//  Created by ran on 2017/9/29.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CATStaticTableCellData;
@interface CATStaticTableSectionData : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, strong) NSArray <CATStaticTableCellData *> *cellStaticDataList;
@property (nonatomic, strong) id accessoryObject;

- (instancetype)initWithTitle:(NSString *)title staticCellDataList:(NSArray <CATStaticTableCellData *> *)cellDataList;

@end
