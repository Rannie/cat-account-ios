//
//  CATReportViewController.m
//  CatAccounting
//
//  Created by ran on 2017/9/12.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATReportViewController.h"
#import "CATAccountService.h"
#import "CATCategoryDataSet.h"
#import "CATCategory.h"
#import "CATDateBrowserBar.h"
#import "CATReportPieChartCell.h"
#import "CATReportFooterView.h"
#import "CATCategoryDetailViewController.h"
#import "CATFundAccService.h"
@import Charts;

@interface CATFundAccountAxisFormatter : NSObject <IChartAxisValueFormatter>

@end

@implementation CATFundAccountAxisFormatter

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
    NSInteger idx = value/10;
    NSArray *txtList = [[CATFundAccService service] fundNameList];
    NSString *str = txtList[txtList.count-1-idx];
    if (str.length > 3) {
        str = [str substringWithRange:NSMakeRange(0, 3)];
    }
    return str;
}

@end

typedef NS_ENUM(NSInteger, ReportViewType) {
    ReportViewTypePie = 0,
    ReportViewTypeBar
};

static NSString * const kReportPieChartCellIdentifier = @"kReportPieChartCellIdentifier";

@interface CATReportViewController () <ChartViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CATDateBrowserBar *dateBar;
@property (nonatomic, strong) UITableView *chartTable;
@property (nonatomic, strong) PieChartView *pieChartView;
@property (nonatomic, strong) HorizontalBarChartView *barChartView;

@property (nonatomic, assign) NSInteger curYear;
@property (nonatomic, assign) NSInteger curMonth;

@property (nonatomic, strong) NSArray *categoryDataSets;
@property (nonatomic, strong) PieChartDataSet *pieChartDataSet;
@property (nonatomic, assign) double totalNumber;

@property (nonatomic, strong) NSArray *fundAccDataSets;

@end

@implementation CATReportViewController

#pragma mark - Life Cycle
- (void)didInitialized {
    [super didInitialized];
    self.title = @"报表";
    [self setCurDate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchChartDataSetAndUpdate];
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:UIImageMake(@"icon_share")
//                                                             style:UIBarButtonItemStylePlain
//                                                            target:self
//                                                            action:@selector(onShareItemClicked:)];
//    self.navigationItem.rightBarButtonItem = item;
}

- (void)initSubviews {
    [super initSubviews];
    self.chartTable.tableHeaderView = self.dateBar;
    [self.view addSubview:self.chartTable];
    [self.chartTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)onShareItemClicked:(id)sender {
    [QMUITips showWithText:@"暂未开放" inView:self.view hideAfterDelay:CAT_TIPS_SHOWTIME];
}

- (void)setCurDate {
    NSDate *now = [NSDate date];
    self.curYear = now.year;
    self.curMonth = now.month;
}

- (void)onDateLeftBtnClicked:(id)sender {
    NSDate *now = [NSDate date];
    if (self.curYear == now.year && self.curMonth == now.month) {
        self.dateBar.rightBtn.hidden = NO;
    }
    
    if (self.curMonth == 1) {
        self.curYear -= 1;
        self.curMonth = 12;
    } else {
        self.curMonth -= 1;
    }
    
    [self fetchChartDataSetAndUpdate];
}

- (void)onDateRightBtnClicked:(id)sender {
    if (self.curMonth == 12) {
        self.curYear += 1;
        self.curMonth = 1;
    } else {
        self.curMonth +=1;
    }
    
    NSDate *now = [NSDate date];
    if (self.curYear == now.year && self.curMonth == now.month) {
        self.dateBar.rightBtn.hidden = YES;
    }
    
    [self fetchChartDataSetAndUpdate];
}

- (void)fetchChartDataSetAndUpdate {
    self.dateBar.dateLabel.text = [NSString stringWithFormat:@"%04zd年%02zd月", self.curYear, self.curMonth];
    // pie chart
    [[CATAccountService service] fetchOutCategoryAccountsWithYear:self.curYear month:self.curMonth completion:^(NSArray<CATCategoryDataSet *> *dataSets, double total) {
        self.categoryDataSets = dataSets;
        self.totalNumber = total;
        [self transferDatasetsToPieChart];
        [self.chartTable reloadSection:ReportViewTypePie withRowAnimation:UITableViewRowAnimationFade];
        if (!CATIsEmptyArray(dataSets)) {
            [self.pieChartView animateWithYAxisDuration:1.0 easingOption:ChartEasingOptionEaseOutBack];
        }
    }];
    // bar chart
    [[CATAccountService service] fetchFundAccountsWithYear:self.curYear month:self.curMonth completion:^(NSArray<CATFundAccount *> *dataSets) {
        self.fundAccDataSets = [dataSets reverseObjectEnumerator].allObjects;
        [self transferDatasetsToHorBarChart];
        [self.barChartView animateWithYAxisDuration:1.8];
    }];
}

- (void)transferDatasetsToHorBarChart {
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:self.fundAccDataSets.count];
    [self.fundAccDataSets enumerateObjectsUsingBlock:^(CATFundAccount * _Nonnull funAccDataSet, NSUInteger idx, BOOL * _Nonnull stop) {
        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:idx*10 y:funAccDataSet.curOutcome];
        BarChartDataSet *set = [[BarChartDataSet alloc] initWithValues:@[entry] label:funAccDataSet.fundAccName];
        set.colors = @[[[CATFundAccService service].accColors reverseObjectEnumerator].allObjects[idx]];
        set.valueTextColor = UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK);
        set.valueFont = UIFontMake(10.0f);
        set.valueFormatter = [[ChartDefaultValueFormatter alloc] initWithFormatter:[CATUtil numberFormatter]];
        [values addObject:set];
    }];
    
    BarChartData *data = [[BarChartData alloc] initWithDataSets:values];
    data.barWidth = 6.5f;
    self.barChartView.data = data;
}

- (void)transferDatasetsToPieChart {
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSString *centerStr = [NSString stringWithFormat:@"总支出\n%.02f", self.totalNumber];
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:centerStr];
    [centerText setAttributes:@{NSFontAttributeName: UIFontMake(13.0f),
                                NSForegroundColorAttributeName: UIColorMakeWithHex(CAT_THEME_COLOR),
                                NSParagraphStyleAttributeName: paragraphStyle}
                        range:NSMakeRange(0, centerText.length)];
    [centerText addAttributes:@{NSFontAttributeName: UIFontMake(14.0f),
                                NSForegroundColorAttributeName: UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK)}
                        range:NSMakeRange(0, 3)];
    self.pieChartView.centerAttributedText = centerText;
    
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:self.categoryDataSets.count];
    NSMutableArray *catColor = [NSMutableArray arrayWithCapacity:self.categoryDataSets.count];
    [self.categoryDataSets enumerateObjectsUsingBlock:^(CATCategoryDataSet * _Nonnull cateData, NSUInteger idx, BOOL * _Nonnull stop) {
        PieChartDataEntry *entry = [[PieChartDataEntry alloc] initWithValue:cateData.totalCost label:cateData.category.name];
        [values addObject:entry];
        [catColor addObject:UIColorMakeWithHex(cateData.category.color)];
    }];
    
    NSArray *colors;
    if (values.count) {
        colors = [catColor copy];
    } else { // fake a empty entry
        PieChartDataEntry *emptyEntry = [[PieChartDataEntry alloc] initWithValue:1.0 label:@"CATEmptyEntry"];
        [values addObject:emptyEntry];
        colors = @[[self emptyColor]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@"类别"];
    dataSet.drawIconsEnabled = NO;
    dataSet.drawValuesEnabled = NO;
    dataSet.sliceSpace = CATOnePixel;
    dataSet.colors = colors;
    self.pieChartDataSet = dataSet;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    self.pieChartView.data = data;
}

- (void)chartValueSelected:(ChartViewBase *)chartView entry:(PieChartDataEntry *)entry highlight:(ChartHighlight *)highlight {
    [chartView highlightValues:nil];
    if (chartView == self.pieChartView) {
        if (CATIsEqualString(entry.label, @"CATEmptyEntry")) {
            return;
        }
        NSInteger index = [self.pieChartDataSet.values indexOfObject:entry];
        CATCategoryDataSet *cateData = self.categoryDataSets[index];
        CATCategoryDetailViewController *detailVC = [[CATCategoryDetailViewController alloc] init];
        detailVC.categoryDataSet = cateData;
        detailVC.categoryColor = [self.pieChartDataSet colorAtIndex:index];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - TableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ReportViewTypeBar+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    switch (section) {
        case ReportViewTypePie:
            count = self.categoryDataSets.count;
            break;
        case ReportViewTypeBar:
            count = 0;
            break;
        default:
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSInteger section = indexPath.section;
    if (section == ReportViewTypePie) {
        CATCategoryDataSet *cateData = self.categoryDataSets[indexPath.row];
        CATReportPieChartCell *pieCell = [tableView dequeueReusableCellWithIdentifier:kReportPieChartCellIdentifier forIndexPath:indexPath];
        pieCell.cateColor = [self.pieChartDataSet colorAtIndex:indexPath.row];
        pieCell.cateName = cateData.category.name;
        pieCell.percentText = [NSString stringWithFormat:@"%.02f%%", cateData.percent*100];
        pieCell.totalText = [CATUtil formattedNumberString:@(cateData.totalCost)];
        cell = pieCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView;
    switch (section) {
        case ReportViewTypePie:
            headerView = self.pieChartView;
            break;
        case ReportViewTypeBar:
            headerView = [[UIView alloc] init];
            headerView.backgroundColor = UIColorWhite;
            [headerView addSubview:self.barChartView];
            [self.barChartView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(15, 5, 15, 5));
            }];
            break;
        default:
            break;
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0;
    switch (section) {
        case ReportViewTypePie:
            height = 230.f;
            break;
        case ReportViewTypeBar:
            height = 210.0f;
            break;
        default:
            break;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CATReportFooterView *footerView = [[CATReportFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    NSString *footerText;
    if (section == ReportViewTypePie) {
        footerText = @"支出类别饼图";
    } else if (section == ReportViewTypeBar) {
        footerText = @"账户支出柱状图";
    }
    footerView.footerLabel.text = footerText;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    if (section == ReportViewTypePie) {
        NSInteger index = indexPath.row;
        CATCategoryDataSet *cateData = self.categoryDataSets[index];
        CATCategoryDetailViewController *detailVC = [[CATCategoryDetailViewController alloc] init];
        detailVC.categoryDataSet = cateData;
        detailVC.categoryColor = [self.pieChartDataSet colorAtIndex:index];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - Getters
- (CATDateBrowserBar *)dateBar {
    if (_dateBar == nil) {
        _dateBar = [[CATDateBrowserBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [_dateBar.leftBtn addTarget:self action:@selector(onDateLeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_dateBar.rightBtn addTarget:self action:@selector(onDateRightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        NSDate *now = [NSDate date];
        if (self.curYear == now.year && self.curMonth == now.month) {
            _dateBar.rightBtn.hidden = YES;
        }
    }
    return _dateBar;
}

- (UITableView *)chartTable {
    if (_chartTable == nil) {
        _chartTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _chartTable.delegate = self;
        _chartTable.dataSource = self;
        _chartTable.backgroundColor = UIColorClear;
        _chartTable.backgroundView.backgroundColor = UIColorClear;
        _chartTable.tableFooterView = [UIView new];
        _chartTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chartTable.showsVerticalScrollIndicator = NO;
        [_chartTable registerClass:[CATReportPieChartCell class] forCellReuseIdentifier:kReportPieChartCellIdentifier];
    }
    return _chartTable;
}

- (PieChartView *)pieChartView {
    if (_pieChartView == nil) {
        _pieChartView = [[PieChartView alloc] init];
        _pieChartView.backgroundColor = UIColorWhite;
        [_pieChartView setExtraOffsetsWithLeft:5.f top:5.f right:5.f bottom:5.f];
        _pieChartView.drawSliceTextEnabled = NO;
        _pieChartView.drawCenterTextEnabled = YES;
        _pieChartView.chartDescription.enabled = NO;
        _pieChartView.rotationAngle = 0.0;
        _pieChartView.rotationEnabled = YES;
        _pieChartView.highlightPerTapEnabled = YES;
        _pieChartView.drawHoleEnabled = YES;
        _pieChartView.delegate = self;
        _pieChartView.legend.enabled = NO;
        _pieChartView.holeRadiusPercent = 0.44;
        _pieChartView.transparentCircleRadiusPercent = 0.47;
    }
    return _pieChartView;
}

- (HorizontalBarChartView *)barChartView {
    if (_barChartView == nil) {
        _barChartView = [[HorizontalBarChartView alloc] init];
        _barChartView.backgroundColor = UIColorWhite;
        _barChartView.chartDescription.enabled = NO;
        _barChartView.drawGridBackgroundEnabled = NO;
        _barChartView.pinchZoomEnabled = NO;
        _barChartView.delegate = self;
        _barChartView.drawBarShadowEnabled = NO;
        _barChartView.drawValueAboveBarEnabled = YES;
        _barChartView.rightAxis.enabled = NO;
        _barChartView.legend.enabled = YES;
        _barChartView.legend.textColor = UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK);
        _barChartView.userInteractionEnabled = NO;
        
        ChartYAxis *leftAxis = _barChartView.leftAxis;
        leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
        leftAxis.axisLineColor = UIColorGray;
        leftAxis.axisLineWidth = CATOnePixel;
        leftAxis.gridLineWidth = CATOnePixel;
        leftAxis.gridColor = UIColorGray;
        leftAxis.labelTextColor = UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK);
        leftAxis.drawAxisLineEnabled = YES;
        leftAxis.drawGridLinesEnabled = YES;
        leftAxis.spaceTop = 0.15;
        leftAxis.axisMinimum = 0.0;
        
        leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:[CATUtil numberFormatter]];
        
        ChartXAxis *xAxis = _barChartView.xAxis;
        xAxis.valueFormatter = [[CATFundAccountAxisFormatter alloc] init];
        xAxis.drawAxisLineEnabled = NO;
        xAxis.drawGridLinesEnabled = NO;
        xAxis.labelPosition = XAxisLabelPositionBottom;
        xAxis.drawLimitLinesBehindDataEnabled = YES;
        xAxis.labelTextColor = UIColorMakeWithHex(CAT_TEXT_COLOR_BLACK);
        
        _barChartView.fitBars = YES;
    }
    return _barChartView;
}

- (UIColor *)emptyColor {
    return UIColorMakeWithHex(@"#e0e0e0");
}

@end
