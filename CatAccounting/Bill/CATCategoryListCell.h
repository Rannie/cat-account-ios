//
//  CATCategoryListCell.h
//  CatAccounting
//
//  Created by ran on 2017/9/13.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CATCategoryIconView.h"

#define kCategoryItemHeight 66

@interface CATCategoryListCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CATCategoryIconView *iconView;

@end
