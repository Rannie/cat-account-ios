//
//  CATBillPresenter.m
//  CatAccounting
//
//  Created by ran on 2017/10/16.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATBillPresenter.h"
#import "CATAddBillViewController.h"

@interface CATBillPresenter ()
@property (nonatomic, strong) UIWindow *billWindow;
@property (nonatomic, strong) CATAddBillViewController *addVC;
@end

@implementation CATBillPresenter

+ (instancetype)presenter {
    static dispatch_once_t onceToken;
    static CATBillPresenter *presenter;
    dispatch_once(&onceToken, ^{
        presenter = [[self alloc] initPresenter];
    });
    return presenter;
}

- (instancetype)initPresenter {
    self = [super init];
    if (self) {
        _billWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _billWindow.windowLevel = UIWindowLevelNormal;
    }
    return self;
}

- (void)presentWithAccount:(CATAccount *)account {
    CATAddBillViewController *addVC = [[CATAddBillViewController alloc] initWithAccount:account];
    self.billWindow.rootViewController = addVC;
    [self.billWindow makeKeyAndVisible];
    [addVC showAnimateWithCompletion:nil];
    self.addVC = addVC;
}

- (void)present {
    [self presentWithAccount:nil];
}

- (void)hide {
    [UIView animateWithDuration:0.4 animations:^{
        self.addVC.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.billWindow resignKeyWindow];
        self.billWindow.hidden = YES;
        self.billWindow.rootViewController = nil;
        self.addVC = nil;
    }];
}

@end
