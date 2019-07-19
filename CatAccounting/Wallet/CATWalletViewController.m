//
//  CATWalletViewController.m
//  CatAccounting
//
//  Created by ran on 2017/10/16.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATWalletViewController.h"
#import "CATAccountHeaderView.h"
#import "CATFundAccService.h"
#import "CATFundAccCell.h"
#import "CATBudgetHeaderView.h"
#import "CATBudgetTitleView.h"
#import "CATBudgetService.h"
#import "CATMonthBudgetCell.h"
#import "CATCateBudgetCell.h"

typedef NS_ENUM(NSInteger, CATWalletSection) {
    CATWalletSectionFundAcc = 0,
    CATWalletSectionMonthBudget,
    CATWalletSectionCateBudgetSeted,
    CATWalletSectionCateBudgetUnseted
};

static NSString * const kCATFundAccCellIdentifier = @"kCATFundAccCellIdentifier";
static NSString * const kCATMonthBudgetCellIdentifier = @"kCATMonthBudgetCellIdentifier";
static NSString * const kCATCateBudgetCellIdentifier = @"kCATCateBudgetCellIdentifier";

@interface CATWalletViewController () <UITableViewDelegate, UITableViewDataSource, CATBudgetHeaderViewDelegate>

@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CATAccountHeaderView *accHeaderView;
@property (nonatomic, strong) CATBudgetHeaderView *budgetHeaderView;
@property (nonatomic, strong) CATBudgetTitleView *setedBudgetTitleView;
@property (nonatomic, strong) CATBudgetTitleView *unsetedBudgetTitleView;

@property (nonatomic, strong) NSArray *accountList;
@property (nonatomic, strong) CATBudget *monthBudget;
@property (nonatomic, strong) NSArray *setedCateBudgets;
@property (nonatomic, strong) NSArray *unsetedCateBudgets;

@end

@implementation CATWalletViewController

#pragma mark - Life Cycle
- (void)didInitialized {
    [super didInitialized];
    self.title = @"钱包";
    self.accountList = [CATFundAccService service].fundAccList;
}

- (void)initSubviews {
    [super initSubviews];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchAccountData];
    [self fetchBudgetData];
}

- (void)fetchAccountData {
    __block NSDecimalNumber *outcome = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    __block NSDecimalNumber *income = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    __block NSDecimalNumber *assets = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    [self.accountList enumerateObjectsUsingBlock:^(CATFundAccount * _Nonnull fundAcc, NSUInteger idx, BOOL * _Nonnull stop) {
        outcome = [outcome decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", fundAcc.totalOutcome]]];
        income = [income decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", fundAcc.totalIncome]]];
        assets = [assets decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", fundAcc.totalAssets]]];
    }];
    
    NSString *outString = [CATUtil formattedNumberString:@([outcome doubleValue])];
    NSString *inString = [CATUtil formattedNumberString:@([income doubleValue])];
    NSString *assetsString = [CATUtil formattedNumberString:@([assets doubleValue])];
    
    self.accHeaderView.outcomeStr = [NSString stringWithFormat:@"总支出\n¥ %@", outString];
    self.accHeaderView.incomeStr = [NSString stringWithFormat:@"总收入\n¥ %@", inString];
    self.accHeaderView.assetsStr = [NSString stringWithFormat:@"余额\n¥ %@", assetsString];
    [self.tableView reloadData];
}

- (void)fetchBudgetData {
    NSDate *date = [NSDate date];
    [[CATBudgetService service] fetchAllBudgetsWithYear:date.year month:date.month completion:^(CATBudget *monthBudget, NSArray<CATBudget *> *setBudgetList, NSArray<CATBudget *> *unsetBudgetList) {
        self.monthBudget = monthBudget;
        self.setedCateBudgets = setBudgetList;
        self.unsetedCateBudgets = unsetBudgetList;
        [self.tableView reloadData];
    }];
}

#pragma mark - Actions
- (void)budgetHeaderViewDidClickUseLastButton:(CATBudgetHeaderView *)headerView {
    CATLastBudgetStatus status = [[CATBudgetService service] getLastBudgetStatus];
    if (status == CATLastBudgetStatusNone) {
        [QMUITips showInfo:@"上个月没有预算信息" inView:self.view hideAfterDelay:0.7];
    } else if (status == CATLastBudgetStatusUnSet) {
        [QMUITips showInfo:@"上个月未设置预算" inView:self.view hideAfterDelay:0.7];
    } else {
        QMUIAlertController *alert = [[QMUIAlertController alloc] initWithTitle:@"提示" message:@"是否要用上月预算方案覆盖当前方案？" preferredStyle:QMUIAlertControllerStyleAlert];
        [alert addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
        [alert addAction:[QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
            NSDate *date = [NSDate date];
            [[CATBudgetService service] followLastBudgetsWithCurYear:date.year month:date.month];
            [self fetchBudgetData];
        }]];
        [alert showWithAnimated:YES];
    }
}

- (void)budgetHeaderViewDidClickClearButton:(CATBudgetHeaderView *)headerView {
    if (CATIsEmptyString(self.monthBudget.budgetAmount) && CATIsEmptyArray(self.setedCateBudgets)) {
        return;
    }
    
    QMUIAlertController *alert = [[QMUIAlertController alloc] initWithTitle:@"注意" message:@"确定要删除当前月份所有预算？" preferredStyle:QMUIAlertControllerStyleAlert];
    [alert addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
    [alert addAction:[QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
        NSDate *now = [NSDate date];
        [[CATBudgetService service] clearAllBudgetsWithYear:now.year month:now.month];
        [self fetchBudgetData];
    }]];
    [alert showWithAnimated:YES];
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == CATWalletSectionFundAcc) {
        return self.accountList.count;
    } else if (section == CATWalletSectionMonthBudget) {
        return 1;
    } else if (section == CATWalletSectionCateBudgetSeted) {
        return self.setedCateBudgets.count;
    } else {
        return self.unsetedCateBudgets.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView;
    if (section == CATWalletSectionFundAcc) {
        headerView = self.accHeaderView;
        [self.accHeaderView refreshBackgroundColor];
    } else if (section == CATWalletSectionMonthBudget) {
        headerView = self.budgetHeaderView;
        [self.budgetHeaderView refreshThemeColor];
    } else if (section == CATWalletSectionCateBudgetSeted) {
        headerView = self.setedBudgetTitleView;
    } else {
        headerView = self.unsetedBudgetTitleView;
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == CATWalletSectionFundAcc) {
        CATFundAccCell *accCell = [tableView dequeueReusableCellWithIdentifier:kCATFundAccCellIdentifier forIndexPath:indexPath];
        CATFundAccount *account = self.accountList[indexPath.row];
        [accCell bindFundAcc:account];
        cell = accCell;
    } else if (indexPath.section == CATWalletSectionMonthBudget) {
        CATMonthBudgetCell *monthCell = [tableView dequeueReusableCellWithIdentifier:kCATMonthBudgetCellIdentifier forIndexPath:indexPath];
        [monthCell bindMonthBudget:self.monthBudget];
        cell = monthCell;
    } else if (indexPath.section == CATWalletSectionCateBudgetSeted) {
        CATCateBudgetCell *cateCell = [tableView dequeueReusableCellWithIdentifier:kCATCateBudgetCellIdentifier forIndexPath:indexPath];
        CATBudget *budget = self.setedCateBudgets[indexPath.row];
        [cateCell bindBudget:budget];
        cell = cateCell;
    } else {
        CATCateBudgetCell *cateCell = [tableView dequeueReusableCellWithIdentifier:kCATCateBudgetCellIdentifier forIndexPath:indexPath];
        CATBudget *budget = self.unsetedCateBudgets[indexPath.row];
        [cateCell bindBudget:budget];
        cell = cateCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section >= CATWalletSectionMonthBudget) {
        CATBudget *budget;
        NSString *title;
        if (indexPath.section == CATWalletSectionMonthBudget) {
            budget = self.monthBudget;
            title = @"月度预算";
        } else if (indexPath.section == CATWalletSectionCateBudgetSeted) {
            budget = self.setedCateBudgets[indexPath.row];
            title = budget.categoryName;
        } else {
            budget = self.unsetedCateBudgets[indexPath.row];
            title = budget.categoryName;
        }
        
        QMUIDialogTextFieldViewController *dialogViewController = [[QMUIDialogTextFieldViewController alloc] init];
        dialogViewController.title = title;
        dialogViewController.enablesSubmitButtonAutomatically = NO;
        dialogViewController.textField.placeholder = @"预算金额";
        dialogViewController.textField.text = budget.budgetAmount;
        dialogViewController.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        dialogViewController.textField.keyboardType = UIKeyboardTypeNumberPad;
        dialogViewController.textField.maximumTextLength = 8;
        [dialogViewController addCancelButtonWithText:@"取消" block:nil];
        @weakify(self)
        [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
            @strongify(self)
            QMUIDialogTextFieldViewController *textDialog = (QMUIDialogTextFieldViewController *)aDialogViewController;
            NSString *amountStr = textDialog.textField.text;
            if (CATIsEqualString(amountStr, @"")) {
                amountStr = nil;
            }
            
            if (budget.type == CATBudgetTypeMonth)
            {
                double setedSum = [[CATBudgetService service] getSumWithBudgets:self.setedCateBudgets];
                if ([amountStr doubleValue] < setedSum) {
                    [QMUITips showError:[NSString stringWithFormat:@"月度预算不得低于类别预算总额 (%.0f)", setedSum] inView:CATKeyWindow hideAfterDelay:1.5];
                    return;
                }
                budget.budgetAmount = amountStr;
            }
            else
            {
                budget.budgetAmount = amountStr;
                if ([self.setedCateBudgets containsObject:budget]) {
                    double setedSum = [[CATBudgetService service] getSumWithBudgets:self.setedCateBudgets];
                    if ([self.monthBudget.budgetAmount doubleValue] < setedSum) {
                        self.monthBudget.budgetAmount = [NSString stringWithFormat:@"%.0f", setedSum];
                        [[CATBudgetService service] updateBudget:self.monthBudget];
                    }
                } else {
                    NSMutableArray *content = [NSMutableArray arrayWithArray:self.setedCateBudgets];
                    [content addObject:budget];
                    double setedSum = [[CATBudgetService service] getSumWithBudgets:content];
                    if ([self.monthBudget.budgetAmount doubleValue] < setedSum) {
                        self.monthBudget.budgetAmount = [NSString stringWithFormat:@"%.0f", setedSum];
                        [[CATBudgetService service] updateBudget:self.monthBudget];
                    }
                }
            }
            [[CATBudgetService service] updateBudget:budget];
            [self fetchBudgetData];
            
            [textDialog hide];
        }];
        [dialogViewController show];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == CATWalletSectionFundAcc) {
        return kHeaderViewHeight;
    } else if (section == CATWalletSectionMonthBudget) {
        return kBudgetHeaderViewHeight;
    } else if (section == CATWalletSectionCateBudgetSeted) {
        return self.setedCateBudgets.count?kBudgetTitleHeight:0.0f;
    } else {
        return self.unsetedCateBudgets.count?kBudgetTitleHeight:0.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == CATWalletSectionFundAcc) {
        return 20.0f;
    }
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == CATWalletSectionFundAcc) {
        return 55.0;
    } else if (indexPath.section == CATWalletSectionMonthBudget) {
        return kMonthBudgetHeight;
    } else {
        return kCateBudgetHeight;
    }
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
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.bounces = NO;
        [_tableView registerClass:[CATFundAccCell class] forCellReuseIdentifier:kCATFundAccCellIdentifier];
        [_tableView registerClass:[CATMonthBudgetCell class] forCellReuseIdentifier:kCATMonthBudgetCellIdentifier];
        [_tableView registerClass:[CATCateBudgetCell class] forCellReuseIdentifier:kCATCateBudgetCellIdentifier];
    }
    return _tableView;
}

- (UIView *)topBgView {
    if (_topBgView == nil) {
        _topBgView = [[UIView alloc] init];
        _topBgView.backgroundColor = UIColorMakeWithHex(CAT_THEME_COLOR);
    }
    return _topBgView;
}

- (CATAccountHeaderView *)accHeaderView {
    if (_accHeaderView == nil) {
        _accHeaderView = [[CATAccountHeaderView alloc] init];
    }
    return _accHeaderView;
}

- (CATBudgetHeaderView *)budgetHeaderView {
    if (_budgetHeaderView == nil) {
        _budgetHeaderView = [[CATBudgetHeaderView alloc] init];
        _budgetHeaderView.delegate = self;
    }
    return _budgetHeaderView;
}

- (CATBudgetTitleView *)setedBudgetTitleView {
    if (_setedBudgetTitleView == nil) {
        _setedBudgetTitleView = [[CATBudgetTitleView alloc] init];
        _setedBudgetTitleView.titleLabel.text = @"类别预算";
    }
    return _setedBudgetTitleView;
}

- (CATBudgetTitleView *)unsetedBudgetTitleView {
    if (_unsetedBudgetTitleView == nil) {
        _unsetedBudgetTitleView = [[CATBudgetTitleView alloc] init];
        _unsetedBudgetTitleView.titleLabel.text = @"类别预算";
    }
    return _unsetedBudgetTitleView;
}

@end
