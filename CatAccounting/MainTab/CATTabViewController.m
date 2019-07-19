//
//  CATTabViewController.m
//  CatAccounting
//
//  Created by ran on 2017/9/11.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATTabViewController.h"
#import "CATBillViewController.h"
#import "CATReportViewController.h"
#import "CATWalletViewController.h"
#import "CATMoreViewController.h"
#import "CATTabBarItem.h"
#import "CATBillPresenter.h"

#if DEBUG
#import "FLEXManager.h"
#endif

@interface CATTabViewController ()
@property (nonatomic, strong) UIView *customTabBar;
@property (nonatomic, strong) NSArray *itemList;
@property (nonatomic, strong) CATTabBarItem *selectedItem;
@property (nonatomic, strong) CATTabBarItem *addItem;
@end

@implementation CATTabViewController

+ (NSArray *)tabbarIconNames {
    return @[@"icon_tabbar_bill_sel", @"icon_tabbar_wallet_sel", @"icon_tabbar_report_sel", @"icon_tabbar_more_sel"];
}

- (void)didInitialized {
    [super didInitialized];
    
    CATBillViewController *billVC = [[CATBillViewController alloc] init];
    billVC.hidesBottomBarWhenPushed = NO;
    CATNaviController *billNavi = [[CATNaviController alloc] initWithRootViewController:billVC];
    
    CATWalletViewController *walletVC = [[CATWalletViewController alloc] init];
    walletVC.hidesBottomBarWhenPushed = NO;
    CATNaviController *walletNavi = [[CATNaviController alloc] initWithRootViewController:walletVC];
    
    CATReportViewController *reportVC = [[CATReportViewController alloc] init];
    reportVC.hidesBottomBarWhenPushed = NO;
    CATNaviController *reportNavi = [[CATNaviController alloc] initWithRootViewController:reportVC];
    
    CATMoreViewController *moreVC = [[CATMoreViewController alloc] init];
    moreVC.hidesBottomBarWhenPushed = NO;
    CATNaviController *moreNavi = [[CATNaviController alloc] initWithRootViewController:moreVC];
    
    self.viewControllers = @[billNavi, walletNavi, reportNavi, moreNavi];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onThemeChanged:) name:CATThemeDidUpdateNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (AppContext.autoPresentAddBillPage) {
        [[CATBillPresenter presenter] present];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onThemeChanged:(NSNotification *)notification {
    [self.itemList enumerateObjectsUsingBlock:^(CATTabBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *imgName = [CATTabViewController tabbarIconNames][idx];
        item.selectedImage = CATThemeImageMake(imgName);
        [item refreshThemeColor];
    }];
    self.addItem.backgroundColor = UIColorMakeWithHex(CAT_THEME_COLOR);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customTabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TabBarHeight)];
    [self.tabBar addSubview:self.customTabBar];
    
    CATTabBarItem *billItem = [[CATTabBarItem alloc] initWithTitle:@"明细" image:UIImageMake(@"icon_tabbar_bill") selectedImage:CATThemeImageMake(@"icon_tabbar_bill_sel") index:0];
    CATTabBarItem *walletItem = [[CATTabBarItem alloc] initWithTitle:@"钱包" image:UIImageMake(@"icon_tabbar_wallet") selectedImage:CATThemeImageMake(@"icon_tabbar_wallet_sel") index:1];
    CATTabBarItem *reportItem = [[CATTabBarItem alloc] initWithTitle:@"报表" image:UIImageMake(@"icon_tabbar_report") selectedImage:CATThemeImageMake(@"icon_tabbar_report_sel") index:2];
    CATTabBarItem *moreItem = [[CATTabBarItem alloc] initWithTitle:@"更多" image:UIImageMake(@"icon_tabbar_more") selectedImage:CATThemeImageMake(@"icon_tabbar_more_sel") index:3];
    CATTabBarItem *addItem = [[CATTabBarItem alloc] initWithTitle:nil image:UIImageMake(@"icon_tabbar_add") selectedImage:nil index:4];
    addItem.backgroundColor = UIColorMakeWithHex(CAT_THEME_COLOR);
    addItem.layer.cornerRadius = 3;
    self.addItem = addItem;
    
    NSArray *layoutList = @[billItem, walletItem, addItem, reportItem, moreItem];
    self.itemList = @[billItem, walletItem, reportItem, moreItem];
    
    CGFloat itemW = SCREEN_WIDTH/layoutList.count;
    [layoutList enumerateObjectsUsingBlock:^(CATTabBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.customTabBar addSubview:item];
        if (item.index != 4)
        { // normal
            item.frame = CGRectMake(idx*itemW, 1, itemW, TabBarHeight-1);
            @weakify(self)
            @weakify(item)
            [item setSelectedCallback:^{
                @strongify(self)
                @strongify(item)
                self.selectedIndex = item.index;
            }];
        }
        else
        {
            CGFloat addW = 42;
            CGFloat marginH = (itemW-addW)/2.0;
            CGFloat marginV = 7;
            item.frame = CGRectMake(itemW*idx+marginH, marginV, addW, TabBarHeight-2*marginV);
            [item setSelectedCallback:^{
                [[CATBillPresenter presenter] present];
            }];
        }
    }];
    
    billItem.selected = YES;
    self.selectedItem = billItem;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    CATTabBarItem *item = self.itemList[selectedIndex];
    if (self.selectedItem == item) {
        return;
    }
    [super setSelectedIndex:selectedIndex];
    self.selectedItem.selected = NO;
    item.selected = YES;
    self.selectedItem = item;
}

- (void)viewDidLayoutSubviews {
    for (UIView *view in self.tabBar.subviews) {
        if (view != self.customTabBar) {
            [view removeFromSuperview];
        }
    }
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
#if DEBUG
    if (motion == UIEventSubtypeMotionShake) {
        FLEXManager *plugManager = [FLEXManager sharedManager];
        if (plugManager.isHidden) {
            [plugManager showExplorer];
        } else {
            [plugManager hideExplorer];
        }
    }
#endif
}

@end
