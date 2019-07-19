//
//  CATBillViewController.m
//  CatAccounting
//
//  Created by ran on 2017/9/12.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATBillViewController.h"
#import "CATAccountService.h"
#import "CATMonthDataView.h"
#import "CATFeedDayView.h"
#import "CATFeedAccountCell.h"
#import "CATCategory.h"
#import "CATBillListEmptyView.h"
#import "CATBillPresenter.h"

#define kAddButtonSize 40

static NSString * const kCATFeedAccountCellIdentifier = @"kCATFeedAccountCellIdentifier";

@interface CATBillViewController () <CATMonthDataViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CATMonthDataView *monthBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CATBillListEmptyView *listEmptyView;

@property (nonatomic, assign) NSInteger curYear;
@property (nonatomic, assign) NSInteger curMonth;
@property (nonatomic, assign) BOOL showingListEmptyView;

@property (nonatomic, strong) NSMutableArray *feedsList;

@end

@implementation CATBillViewController

#pragma mark - Life Cycle
- (void)didInitialized {
    [super didInitialized];
    self.title = @"账簿";
    [self setCurDate];
}

- (void)initSubviews {
    [super initSubviews];
    [self.view addSubview:self.monthBar];
    [self.monthBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(NavigationBarHeight+StatusBarHeight);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(65);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.monthBar.mas_bottom);
        make.left.and.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
}

- (void)dealloc {
    [CATNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.monthBar hideNext];
    
    [CATNotificationCenter addObserver:self
                              selector:@selector(onDidAddNotificationReceived:)
                                  name:CATEditingBillVCDidAddAccountNotification
                                object:nil];
    [CATNotificationCenter addObserver:self
                              selector:@selector(onDidUpdateNotificationReceived:)
                                  name:CATEditingBillVCDidUpdateAccountNotification
                                object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateMonthAndFetchData];
}

- (void)setCurDate {
    NSDate *now = [NSDate date];
    self.curYear = now.year;
    self.curMonth = now.month;
}

- (void)showEmptyView {
    [self.view addSubview:self.listEmptyView];
    [self.listEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.tableView);
    }];
    self.showingListEmptyView = YES;
}

- (void)hideEmptyView {
    [self.listEmptyView removeFromSuperview];
    self.showingListEmptyView = NO;
}

#pragma mark - Actions
- (void)updateMonthAndFetchData {
    self.monthBar.yearText = [NSString stringWithFormat:@"%04zd年", self.curYear];
    self.monthBar.monthText = [NSString stringWithFormat:@"%02zd月", self.curMonth];
    [self fetchFeedsAndUpdateUI];
}

- (void)fetchFeedsAndUpdateUI {
    [[CATAccountService service] fetchMonthFeedsWithYear:self.curYear month:self.curMonth completion:^(NSArray<CATBillDayFeed *> *feeds) {
        self.feedsList = [NSMutableArray arrayWithArray:feeds];
        [self.tableView reloadData];
        [self caculateExpAndIncome];
        [self checkEmptyView];
    }];
}

- (void)caculateExpAndIncome {
    NSString *exp, *inc;
    [[CATAccountService service] caculateFeeds:self.feedsList totalExp:&exp totalInc:&inc];
    self.monthBar.expenditure = exp;
    self.monthBar.income = inc;
}

- (void)checkEmptyView {
    if (self.feedsList.count == 0) {
        if (!self.showingListEmptyView) [self showEmptyView];
    } else {
        [self hideEmptyView];
    }
}

- (void)onDidAddNotificationReceived:(NSNotification *)notification {
    if (self.tabBarController.selectedViewController != self.navigationController) {
        self.tabBarController.selectedIndex = 0;
        return;
    }
    
    NSDictionary *userInfo = notification.userInfo;
    if ([userInfo[@"year"] integerValue] == self.curYear
        && [userInfo[@"month"] integerValue] == self.curMonth) {
        [self fetchFeedsAndUpdateUI];
    }
}

- (void)onDidUpdateNotificationReceived:(NSNotification *)notification {
    [self fetchFeedsAndUpdateUI];
}

- (void)dataViewShouldAddMonth:(CATMonthDataView *)dataView {
    [CATUtil getNextMonthWithCurYear:self.curYear month:self.curMonth result:^(NSInteger year, NSInteger month, BOOL haveNext) {
        self.curYear = year;
        self.curMonth = month;
        if (!haveNext) {
            [dataView hideNext];
        }
        [self updateMonthAndFetchData];
    }];
}

- (void)dataViewShouldReduceMonth:(CATMonthDataView *)dataView {
    [CATUtil getPrevMonthWithCurYear:self.curYear month:self.curMonth result:^(NSInteger year, NSInteger month, BOOL haveNext) {
        self.curYear = year;
        self.curMonth = month;
        if (haveNext) {
            [dataView showNext];
        }
        [self updateMonthAndFetchData];
    }];
}

#pragma mark - TableView Delegate & DataSource
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
    accountCell.categoryIcon.highlightColor = UIColorMakeWithHex(account.category.color);
    accountCell.categoryIcon.state = CategoryIconStateHighlight;
    accountCell.categoryLabel.text = account.categoryName;
    UIColor *color = account.type ? UIColorMakeWithHex(@"4caf50"):UIColorMakeWithHex(@"e57373");
    accountCell.amountLabel.text = [NSString stringWithFormat:@"%@", account.amount];
    accountCell.amountLabel.textColor = color;
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
        if ([feed haveInc]) [totalTxt appendString:@" "];
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
            [dayFeed removeAccount:account];
            if (dayFeed.accountList.count) {
                [tableView beginUpdates];
                [dayFeed caculateAccountDataAndSignLocation];
                [tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView endUpdates];
            } else {
                [self.feedsList removeObject:dayFeed];
                [tableView reloadData];
                [self checkEmptyView];
            }
            [self caculateExpAndIncome];
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
- (CATBillListEmptyView *)listEmptyView {
    if (_listEmptyView == nil) {
        _listEmptyView = [[CATBillListEmptyView alloc] init];
    }
    return _listEmptyView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorClear;
        _tableView.backgroundView.backgroundColor = UIColorClear;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[CATFeedAccountCell class] forCellReuseIdentifier:kCATFeedAccountCellIdentifier];
    }
    return _tableView;
}

- (CATMonthDataView *)monthBar {
    if (_monthBar == nil) {
        _monthBar = [[CATMonthDataView alloc] init];
        _monthBar.delegate = self;
    }
    return _monthBar;
}

@end
