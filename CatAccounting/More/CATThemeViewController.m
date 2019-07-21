//
//  CATThemeViewController.m
//  CatAccounting
//
//  Created by ran on 2017/11/1.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATThemeViewController.h"
#import "CATThemeManager.h"
#import "CATThemeCell.h"

@interface CATThemeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *themeTable;
@property (nonatomic, weak) CATThemeCell *checkedCell;
@property (nonatomic, strong) NSArray *themeList;

@end

@implementation CATThemeViewController

- (void)didInitialized {
    [super didInitialized];
    self.title = @"主题";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.themeList = [CATThemeManager manager].themeList;
}

- (void)initSubviews {
    [super initSubviews];
    [self.view addSubview:self.themeTable];
    [self.themeTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.themeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CATThemeCell *themeCell = [[CATThemeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    id<CATThemeProtocol> theme = self.themeList[indexPath.row];
    [themeCell bindTheme:theme];
    if (theme == [CATThemeManager manager].currentTheme) {
        [themeCell setChecked:YES animated:NO];
        self.checkedCell = themeCell;
    } else {
        [themeCell setChecked:NO animated:NO];
    }
    return themeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CATThemeCell *cell = (CATThemeCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell != self.checkedCell) {
        [cell setChecked:YES animated:YES];
        [self.checkedCell setChecked:NO animated:NO];
        self.checkedCell = cell;
        
        id<CATThemeProtocol> theme = self.themeList[indexPath.row];
        [CATThemeManager manager].currentTheme = theme;
    }
}

- (UITableView *)themeTable {
    if (_themeTable == nil) {
        _themeTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _themeTable.delegate = self;
        _themeTable.dataSource = self;
        _themeTable.backgroundColor = UIColorClear;
        _themeTable.backgroundView.backgroundColor = UIColorClear;
        _themeTable.rowHeight = kThemeCellHeight;
        _themeTable.tableFooterView = [UIView new];
        _themeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _themeTable.showsVerticalScrollIndicator = NO;
    }
    return _themeTable;
}

@end
