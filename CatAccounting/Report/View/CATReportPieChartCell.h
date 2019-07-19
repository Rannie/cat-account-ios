//
//  CATReportPieChartCell.h
//  CatAccounting
//
//  Created by ran on 2017/9/28.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

@interface CATReportPieChartCell : QMUITableViewCell

@property (nonatomic, strong) UIColor *cateColor;
@property (nonatomic, strong) NSString *cateName;
@property (nonatomic, strong) NSString *percentText;
@property (nonatomic, strong) NSString *totalText;

@end
