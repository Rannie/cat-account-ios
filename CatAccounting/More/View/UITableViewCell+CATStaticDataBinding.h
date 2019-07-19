//
//  UITableViewCell+CATStaticDataBinding.h
//  CatAccounting
//
//  Created by ran on 2017/9/29.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CATStaticTableCellData.h"

@interface UITableViewCell (CATStaticDataBinding)

- (void)cat_bindStaticData:(CATStaticTableCellData *)staticCellData;

@end
