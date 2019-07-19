//
//  CATWebViewController.h
//  CatAccounting
//
//  Created by ran on 2017/9/15.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATBaseViewController.h"

@interface CATWebViewController : CATBaseViewController
@property (nonatomic, strong) NSString *requestUrlString;
@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, strong) NSURL *htmlBaseUrl;
@end
