//
//  CATMoreViewController.m
//  CatAccounting
//
//  Created by ran on 2017/9/12.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATMoreViewController.h"
#import "CATWebViewController.h"
#import "CATStaticTableSectionData.h"
#import "CATStaticTableCellData.h"
#import "UITableViewCell+CATStaticDataBinding.h"
#import "CATAboutViewController.h"
#import "CATFundAccService.h"
#import "CATThemeViewController.h"
#import "UIViewController+KMNavigationBarTransition.h"
#import "CATBudgetService.h"
#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>

static NSString * const kAppKey = @"24692894";
static NSString * const kAppSecret = @"1aa3e0758f2219af50266b10144d8f02";

@interface CATMoreViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <CATStaticTableSectionData *> *staticSections;
@property (nonatomic, strong) CATStaticTableCellData *accCellData;
@property (nonatomic, strong) CATStaticTableCellData *budgetCellData;
@property (nonatomic, strong) CATStaticTableCellData *autoPresentCellData;

@property (nonatomic, strong) YWFeedbackKit *feedbackKit;

@end

@implementation CATMoreViewController

- (void)didInitialized {
    [super didInitialized];
    self.title = @"更多";
    [CATNotificationCenter addObserver:self selector:@selector(onThemeChanged:) name:CATThemeDidUpdateNotification object:nil];
}

- (void)dealloc {
    [CATNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadStaticData];
}

- (void)initSubviews {
    [super initSubviews];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)onThemeChanged:(NSNotification *)notification {
    UINavigationBar *bar = self.km_transitionNavigationBar;
    bar.barTintColor = [QMUICMI navBarBarTintColor];
    [bar setBackgroundImage:[QMUICMI navBarBackgroundImage] forBarMetrics:UIBarMetricsDefault];
    bar.shadowImage = [QMUICMI navBarShadowImage];
    [self.tableView reloadData];
}

- (void)loadStaticData {
    //    CATStaticTableCellData *recomCD = [CATStaticTableCellData staticTableViewCellDataWithIdentifier:@"recommend" image:UIImageMake(@"more_recommend") text:@"推荐给好友" detailText:nil accessoryType:CATStaticTableViewCellAccessoryTypeDisclosureIndicator];
    //    CATStaticTableCellData *cateCD = [CATStaticTableCellData staticTableViewCellDataWithIdentifier:@"category" image:UIImageMake(@"more_cate") text:@"类别设置" detailText:nil accessoryType:CATStaticTableViewCellAccessoryTypeDisclosureIndicator];
    //    CATStaticTableCellData *shotCD = [CATStaticTableCellData staticTableViewCellDataWithIdentifier:@"screenshot" style:UITableViewCellStyleDefault height:TableViewCellNormalHeight image:UIImageMake(@"more_shot") text:@"截屏后提示分享" detailText:nil accessoryType:CATStaticTableViewCellAccessoryTypeSwitch accessoryValueObject:@(1) accessoryTarget:self accessoryAction:@selector(onScreenShotSwitchValueChanged:)];
    
    CATStaticTableCellData *accCD = [CATStaticTableCellData staticTableViewCellDataWithIdentifier:@"account" image:UIImageMake(@"more_account") text:@"默认账户" detailText:[CATFundAccService service].defaultAccount.fundAccName accessoryType:CATStaticTableViewCellAccessoryTypeDisclosureIndicator];
    [accCD addSelectedTarget:self action:@selector(onFundAccCellSelected)];
    self.accCellData = accCD;

    CATStaticTableCellData *budgetCD = [CATStaticTableCellData staticTableViewCellDataWithIdentifier:@"budget" style:UITableViewCellStyleDefault height:50 image:UIImageMake(@"more_budget") text:@"自动沿用上月预算" detailText:nil accessoryType:CATStaticTableViewCellAccessoryTypeSwitch accessoryValueObject:@([CATBudgetService service].autoFollowLastBudget) accessoryTarget:self accessoryAction:@selector(onBudgetSwitchValueChanged:)];
    self.budgetCellData = budgetCD;
    
    CATStaticTableCellData *themeCD = [CATStaticTableCellData staticTableViewCellDataWithIdentifier:@"theme" image:UIImageMake(@"more_theme") text:@"个性主题" detailText:nil accessoryType:CATStaticTableViewCellAccessoryTypeDisclosureIndicator];
    [themeCD addSelectedTarget:self action:@selector(onThemeCellSelected)];
    
    CATStaticTableCellData *autoPresentCD = [CATStaticTableCellData staticTableViewCellDataWithIdentifier:@"autopresent" style:UITableViewCellStyleDefault height:50 image:UIImageMake(@"more_auto") text:@"启动进入添加账目页面" detailText:nil accessoryType:CATStaticTableViewCellAccessoryTypeSwitch accessoryValueObject:@(AppContext.autoPresentAddBillPage) accessoryTarget:self accessoryAction:@selector(onAutoPresentSwithValueChanged:)];
    self.autoPresentCellData = autoPresentCD;
    
    CATStaticTableCellData *suggestCD = [CATStaticTableCellData staticTableViewCellDataWithIdentifier:@"suggest" image:UIImageMake(@"more_suggest") text:@"意见反馈" detailText:nil accessoryType:CATStaticTableViewCellAccessoryTypeDisclosureIndicator];
    [suggestCD addSelectedTarget:self action:@selector(onSuggestCellSelected)];

    CATStaticTableCellData *scoreCD = [CATStaticTableCellData staticTableViewCellDataWithIdentifier:@"score" image:UIImageMake(@"more_appstore") text:@"去 AppStore 评分" detailText:nil accessoryType:CATStaticTableViewCellAccessoryTypeDisclosureIndicator];
    [scoreCD addSelectedTarget:self action:@selector(onScoreCellSelected)];
    
    CATStaticTableCellData *libCD = [CATStaticTableCellData staticTableViewCellDataWithIdentifier:@"lib" image:UIImageMake(@"more_library") text:@"开源库" detailText:nil accessoryType:CATStaticTableViewCellAccessoryTypeDisclosureIndicator];
    [libCD addSelectedTarget:self action:@selector(onLibCellSelected)];
    
    CATStaticTableCellData *aboutCD = [CATStaticTableCellData staticTableViewCellDataWithIdentifier:@"about" image:UIImageMake(@"more_about") text:@"关于" detailText:nil accessoryType:CATStaticTableViewCellAccessoryTypeDisclosureIndicator];
    [aboutCD addSelectedTarget:self action:@selector(onAboutCellSelected)];
    
    CATStaticTableSectionData *sectionOne = [[CATStaticTableSectionData alloc] initWithTitle:nil staticCellDataList:@[accCD, budgetCD, themeCD, autoPresentCD]];
    sectionOne.headerHeight = CAT_MARGIN;
    CATStaticTableSectionData *seciontTwo = [[CATStaticTableSectionData alloc] initWithTitle:nil staticCellDataList:@[suggestCD, scoreCD, libCD, aboutCD]];
    
    self.staticSections = @[sectionOne, seciontTwo];
    [self.tableView reloadData];
}

- (void)onSuggestCellSelected {
    __weak typeof(self) weakSelf = self;
    [self.feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
        if (viewController) {
            viewController.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:viewController animated:YES];
            
            [viewController setCloseBlock:^(UIViewController *aParentController){
                [aParentController.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}

- (YWFeedbackKit *)feedbackKit {
    if (!_feedbackKit) {
        _feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:kAppKey appSecret:kAppSecret];
        _feedbackKit.defaultCloseButtonTitleFont = UIFontMake(0.0);
    }
    return _feedbackKit;
}

- (void)onScoreCellSelected {
    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", @"1308678908"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

- (void)onThemeCellSelected {
    CATThemeViewController *themeVC = [[CATThemeViewController alloc] init];
    [self.navigationController pushViewController:themeVC animated:YES];
}

- (void)onFundAccCellSelected {
    QMUIAlertController *actionSheet = [QMUIAlertController alertControllerWithTitle:@"选择一个账户类型"
                                                                             message:nil
                                                                      preferredStyle:QMUIAlertControllerStyleActionSheet];
    NSArray *sourceList = [[CATFundAccService service] fundAccList];
    [sourceList enumerateObjectsUsingBlock:^(CATFundAccount * _Nonnull fundAccount, NSUInteger idx, BOOL * _Nonnull stop) {
        [actionSheet addAction:[QMUIAlertAction actionWithTitle:fundAccount.fundAccName style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
            [[CATFundAccService service] configDefaultAccountWithName:fundAccount.fundAccName];
            self.accCellData.detailText = fundAccount.fundAccName;
            [self.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
        }]];
    }];
    [actionSheet addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
    [actionSheet showWithAnimated:YES];
}

- (void)onLibCellSelected {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"Library" ofType:@"html"];
    NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];

    CATWebViewController *libVC = [[CATWebViewController alloc] init];
    libVC.htmlString = htmlCont;
    libVC.htmlBaseUrl = baseURL;
    [self.navigationController pushViewController:libVC animated:YES];
}

- (void)onAboutCellSelected {
    CATAboutViewController *aboutVC = [[CATAboutViewController alloc] init];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

- (void)onBudgetSwitchValueChanged:(UISwitch *)sender {
    BOOL autoFollow = sender.isOn;
    self.budgetCellData.accessoryValue = @(autoFollow);
    [CATBudgetService service].autoFollowLastBudget = autoFollow;
}

- (void)onAutoPresentSwithValueChanged:(UISwitch *)sender {
    BOOL autoPresent = sender.isOn;
    self.autoPresentCellData.accessoryValue = @(autoPresent);
    AppContext.autoPresentAddBillPage = autoPresent;
}

#pragma mark - Table View
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CATStaticTableSectionData *sectionData = self.staticSections[indexPath.section];
    CATStaticTableCellData *cellData = sectionData.cellStaticDataList[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellData.identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:cellData.style reuseIdentifier:cellData.identifier];
        cell.textLabel.textColor = UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK);
        cell.detailTextLabel.textColor = UIColorGray;
        cell.detailTextLabel.font = UIFontMake(13.0f);
    }
    [cell cat_bindStaticData:cellData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CATStaticTableSectionData *sectionData = self.staticSections[indexPath.section];
    CATStaticTableCellData *cellData = sectionData.cellStaticDataList[indexPath.row];
    if (cellData.selectedTarget && cellData.selectedAction) {
        [cellData.selectedTarget qmui_performSelector:cellData.selectedAction];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CATStaticTableSectionData *sectionData = self.staticSections[indexPath.section];
    CATStaticTableCellData *cellData = sectionData.cellStaticDataList[indexPath.row];
    return cellData.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.staticSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CATStaticTableSectionData *sectionData = self.staticSections[section];
    return sectionData.cellStaticDataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CATStaticTableSectionData *sectionData = self.staticSections[section];
    return sectionData.headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CATStaticTableSectionData *sectionData = self.staticSections[section];
    return sectionData.footerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorClear;
        _tableView.backgroundView.backgroundColor = UIColorClear;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001f)];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = UIColorSeparator;
    }
    return _tableView;
}

@end
