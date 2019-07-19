//
//  CATCategoryDetailViewController.m
//  CatAccounting
//
//  Created by ran on 2017/10/11.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATCategoryDetailViewController.h"
#import "CATAccountService.h"
#import "CATCategory.h"
#import "CATCategoryHeaderView.h"
#import "CATFeedDayView.h"
#import "CATFeedAccountCell.h"
#import "CATBillPresenter.h"

static NSString * const kCATFeedAccountCellIdentifier = @"kCATFeedAccountCellIdentifier";

@interface CATCategoryDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) CATCategoryHeaderView *headerView;
@property (nonatomic, strong) UITableView *categoryTable;

@property (nonatomic, strong) NSMutableArray *feedsList;

@end

@implementation CATCategoryDetailViewController

#pragma mark - Life Cycle
- (void)initSubviews {
    [super initSubviews];
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.categoryTable];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(NavigationBarHeight+StatusBarHeight);
        make.left.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [self.categoryTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.left.right.and.bottom.mas_equalTo(self.view);
    }];
}

- (UIImage *)navigationBarBackgroundImage {
    return [UIImage imageWithColor:self.categoryColor];
}

- (UIImage *)navigationBarShadowImage {
    return [UIImage imageWithColor:self.categoryColor];
}

- (UIColor *)navigationBarTintColor {
    return UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK_DARKEN);
}

- (UIColor *)titleViewTintColor {
    return UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK_DARKEN);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@支出详情", self.categoryDataSet.category.name];
    [self fetchDataAndUpdate];
    [CATNotificationCenter addObserver:self selector:@selector(fetchDataAndUpdate) name:CATEditingBillVCDidUpdateAccountNotification object:nil];
}

- (void)dealloc {
    [CATNotificationCenter removeObserver:self];
}

- (void)fetchDataAndUpdate {
    [[CATAccountService service] fetchMonthOutcomeFeedsWithYear:self.categoryDataSet.year
                                                          month:self.categoryDataSet.month
                                                       category:self.categoryDataSet.category.name
                                                     completion:^(NSArray<CATBillDayFeed *> *feeds, double total, float percent) {
                                                         self.feedsList = [NSMutableArray arrayWithArray:feeds];
                                                         self.headerView.totalLabel.text = [NSString stringWithFormat:@"支出金额: %@", [CATUtil formattedNumberString:@(total)]];
                                                         self.headerView.percentLabel.text = [NSString stringWithFormat:@"支出占比: %.2f%%", percent*100];
                                                         [self.categoryTable reloadData];
                                                         [self checkEmpty];
                                                     }];
}

- (void)checkEmpty {
    if (self.feedsList.count == 0) {
        [QMUITips showInfo:@"当前类别无数据" inView:CATKeyWindow hideAfterDelay:0.7];
        [self back];
    }
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.feedsList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CATBillDayFeed *dayFeed = self.feedsList[section];
    return dayFeed.accountList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    CATBillDayFeed *feed = self.feedsList[indexPath.section];
    CATAccount *account = feed.accountList[indexPath.row];
    
    CATFeedAccountCell *accountCell = [tableView dequeueReusableCellWithIdentifier:kCATFeedAccountCellIdentifier forIndexPath:indexPath];
    accountCell.categoryIcon.icon = UIImageMake(account.category.iconName);
    accountCell.categoryLabel.text = account.categoryName;
    accountCell.amountLabel.text = [NSString stringWithFormat:@"%@", account.amount];
    accountCell.remarkLabel.text = account.accountDes;
    if (account.loc == CATAccountFeedLocNormal) {
        [accountCell showBottomLine];
    }
    
    cell = accountCell;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CATFeedDayView *dayHeader = [[CATFeedDayView alloc] init];
    CATBillDayFeed *feed = self.feedsList[section];
    dayHeader.dayInfoLabel.text = [NSString stringWithFormat:@"%02zd月%02zd日", feed.month, feed.day];
    
    NSMutableString *totalTxt = [NSMutableString string];
    if ([feed haveInc])
        [totalTxt appendFormat:@"收入：%@", feed.inc];
    if ([feed haveExp]) {
        [totalTxt appendFormat:@"支出：%@", feed.exp];
    }
    dayHeader.totalLabel.text = [totalTxt copy];
    return dayHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CATBillDayFeed *dayFeed = self.feedsList[indexPath.section];
        CATAccount *account = dayFeed.accountList[indexPath.row];
        BOOL success = [[CATAccountService service] removeAccount:account];
        if (success) {
            [self fetchDataAndUpdate];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CATBillDayFeed *dayFeed = self.feedsList[indexPath.section];
    CATAccount *account = dayFeed.accountList[indexPath.row];
    [[CATBillPresenter presenter] presentWithAccount:account];
}

#pragma mark - Getters
- (UITableView *)categoryTable {
    if (_categoryTable == nil) {
        _categoryTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _categoryTable.delegate = self;
        _categoryTable.dataSource = self;
        _categoryTable.backgroundColor = UIColorClear;
        _categoryTable.backgroundView.backgroundColor = UIColorClear;
        _categoryTable.tableFooterView = [UIView new];
        _categoryTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _categoryTable.showsVerticalScrollIndicator = NO;
        [_categoryTable registerClass:[CATFeedAccountCell class] forCellReuseIdentifier:kCATFeedAccountCellIdentifier];
    }
    return _categoryTable;
}

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = self.categoryColor;
        _bgView.alpha = 0.04f;
    }
    return _bgView;
}

- (CATCategoryHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[CATCategoryHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _headerView.backgroundColor = self.categoryColor;
    }
    return _headerView;
}

@end
