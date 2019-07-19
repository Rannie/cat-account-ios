//
//  CATCategoryDetailViewController.h
//  CatAccounting
//
//  Created by ran on 2017/10/11.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATBaseViewController.h"
#import "CATCategoryDataSet.h"

@interface CATCategoryDetailViewController : CATBaseViewController

@property (nonatomic, strong) CATCategoryDataSet *categoryDataSet;
@property (nonatomic, strong) UIColor *categoryColor;

@end
