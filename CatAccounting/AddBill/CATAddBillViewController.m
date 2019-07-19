//
//  CATAddBillViewController.m
//  CatAccounting
//
//  Created by ran on 2017/9/13.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATAddBillViewController.h"
#import "CATCategoryService.h"
#import "CATCategoryListCell.h"
#import "CATAccount.h"
#import "CATKeyboardView.h"
#import "CATInfoView.h"
#import "CATDatePickerView.h"
#import "CATAccountService.h"
#import "CATBillPresenter.h"
#import "CATFundAccService.h"
#import "CATSegmentControl.h"

#define kCategoryMinInset   15
#define kInfoTopMargin      30

#define kFakeAddCateId (-100)

static NSString * const kCategoryListCellIdentifier = @"kCategoryListCellIdentifier";

@interface CATAddBillViewController () <UICollectionViewDelegate, UICollectionViewDataSource, CATKeyboardViewDelegate, CATInfoViewDelegate, CATDatePickerViewDelegate>

@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UIScrollView *mainScroll;
@property (nonatomic, strong) UICollectionView *categoryView;
@property (nonatomic, strong) UICollectionViewFlowLayout *categoryLayout;
@property (nonatomic, strong) CATKeyboardView *keyboardView;
@property (nonatomic, strong) CATInfoView *infoView;
@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, strong) QMUIButton *cancelButton;
@property (nonatomic, strong) CATSegmentControl *segControl;

@property (nonatomic, strong) CATDatePickerView *datePickerView;
@property (nonatomic, strong) QMUIAlertController *actionSheet;

@property (nonatomic, strong) NSArray<CATCategory *> *categoryList;
@property (nonatomic, strong) CATAccount *editAccount;
@property (nonatomic, strong) NSMutableString *editingAmount;
@property (nonatomic, assign) BOOL editingMode;

@property (nonatomic, strong) CATCategoryListCell *lastCell;
@end

@implementation CATAddBillViewController

#pragma mark - Life Cycle
- (instancetype)initWithAccount:(CATAccount *)account {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        if (account) {
            _editingMode = YES;
            _editAccount = [account copy];
            _editingAmount = [NSMutableString stringWithString:_editAccount.amount];
        }
    }
    return self;
}

- (void)didInitialized {
    [super didInitialized];
    _editAccount = [[CATAccount alloc] init];
    [_editAccount setDate:[NSDate date]];
    _editingAmount = [NSMutableString string];
    _lastCell = nil;
    _editingMode = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customLayoutViews];
    
    NSArray *cateList = self.editAccount.type?[CATCategoryService service].incomeCategoryList:[CATCategoryService service].outcomeCategoryList;
    self.categoryList = [self installList:cateList];
    
    self.infoView.dateStr = [self.editAccount monthAndDayDes];
    self.infoView.source = self.editAccount.assFundAccount;
    
    if (self.editingMode) {
        self.infoView.remark = self.editAccount.accountDes;
        self.infoView.amount = [NSString stringWithFormat:@"¥%@", [self.editingAmount copy]];
        self.infoView.categoryName = self.editAccount.categoryName;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)initSubviews {
    [super initSubviews];
    [self.view addSubview:self.mainScroll];
    [self.view addSubview:self.naviView];
    
    [self.mainScroll addSubview:self.categoryView];
    [self.mainScroll addSubview:self.infoView];
    [self.mainScroll addSubview:self.keyboardView];
}

- (void)customLayoutViews {
    CGFloat viewHeight = SCREEN_HEIGHT-NavigationBarHeight-StatusBarHeight;
    
    self.mainScroll.frame = CGRectMake(0, StatusBarHeight+NavigationBarHeight, SCREEN_WIDTH, viewHeight);
    self.naviView.frame = CGRectMake(0, 0, SCREEN_WIDTH, StatusBarHeight+NavigationBarHeight);
    
    NSInteger cateCount = MAX([CATCategoryService service].outcomeCategoryList.count, [CATCategoryService service].incomeCategoryList.count)+1;
    NSInteger colCount = floorf((SCREEN_WIDTH-kCategoryMinInset)/(kCategoryItemSize+kCategoryMinInset));
    NSInteger rowCount = ceil((float)cateCount/colCount);
    CGFloat cateHeight = rowCount*(kCategoryItemHeight+kCategoryMinInset)+kCategoryMinInset;
    self.categoryView.frame = CGRectMake(0, 0, SCREEN_WIDTH, cateHeight);
    
    if (cateHeight+kKeyboardViewHeight+kInfoViewHeight > viewHeight)
    {
        self.infoView.frame = CGRectMake(0, cateHeight, SCREEN_WIDTH, kInfoViewHeight);
        self.keyboardView.frame = CGRectMake(0, self.infoView.bottom, SCREEN_WIDTH, kKeyboardViewHeight);
        self.mainScroll.contentSize = CGSizeMake(0, self.keyboardView.bottom);
    }
    else
    {
        self.infoView.frame = CGRectMake(0, viewHeight-kKeyboardViewHeight-kInfoViewHeight, SCREEN_WIDTH, kInfoViewHeight);
        self.keyboardView.frame = CGRectMake(0, viewHeight-kKeyboardViewHeight, SCREEN_WIDTH, kKeyboardViewHeight);
        self.mainScroll.contentSize = CGSizeMake(0, self.keyboardView.bottom);
    }
}

- (void)showAnimateWithCompletion:(dispatch_block_t)completion {
    [UIView animateWithDuration:0.4 animations:^{
        self.categoryView.alpha = 1.0;
        self.naviView.alpha = 1.0;
    } completion:nil];
    
    [UIView animateWithDuration:0.7 animations:^{
        if (self.keyboardView.alpha == 0.0) {
            self.keyboardView.alpha = 1.0;
            self.infoView.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)dismiss:(id)sender {
    [[CATBillPresenter presenter] hide];
}

#pragma mark - Items
- (NSArray *)installList:(NSArray *)list {
    NSMutableArray *content = [NSMutableArray arrayWithArray:list];
    CATCategory *addCate = [[CATCategory alloc] init];
    addCate.name = @"新增";
    addCate.iconName = @"cat_add";
    addCate.categoryId = kFakeAddCateId;
    [content addObject:addCate];
    return [content copy];
}

- (void)transToOutcomeItems {
    self.categoryList = [self installList:[CATCategoryService service].outcomeCategoryList];
    self.editAccount.type = CATAccountTypePay;
    self.editAccount.categoryName = nil;
    self.infoView.categoryName = @"类别";
    [self.categoryView reloadData];
}

- (void)transToIncomeItems {
    self.categoryList = [self installList:[CATCategoryService service].incomeCategoryList];
    self.editAccount.type = CATAccountTypeIncome;
    self.editAccount.categoryName = nil;
    self.infoView.categoryName = @"类别";
    [self.categoryView reloadData];
}

#pragma mark - Info
- (void)infoViewDidClickDateButton {
    self.datePickerView.datePicker.maximumDate = [NSDate date];
    self.datePickerView.datePicker.date = [self.editAccount getAccountDate];
    
    QMUIAlertController *actionSheet = [QMUIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:QMUIAlertControllerStyleActionSheet];
    [actionSheet addCustomView:self.datePickerView];
    [actionSheet showWithAnimated:YES];
    self.actionSheet = actionSheet;
}

- (void)datePickerViewDidSelectedCancelButton:(CATDatePickerView *)datePickerView {
    [self.actionSheet hideWithAnimated:YES];
}

- (void)datePickerView:(CATDatePickerView *)datePickerView didSelectedDate:(NSDate *)date {
    self.editAccount.year = date.year;
    self.editAccount.month = date.month;
    self.editAccount.day = date.day;
    [self.actionSheet hideWithAnimated:YES];
    self.infoView.dateStr = self.editAccount.monthAndDayDes;
}

- (void)infoViewDidClickRemarkButton {
    QMUIDialogTextFieldViewController *dialogViewController = [[QMUIDialogTextFieldViewController alloc] init];
    dialogViewController.title = @"请输入备注";
    dialogViewController.enablesSubmitButtonAutomatically = NO;
    dialogViewController.textField.placeholder = @"备注(25字以内)";
    dialogViewController.textField.text = self.editAccount.accountDes;
    dialogViewController.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    dialogViewController.textField.maximumTextLength = 25;
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    @weakify(self)
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        @strongify(self)
        QMUIDialogTextFieldViewController *textDialog = (QMUIDialogTextFieldViewController *)aDialogViewController;
        [textDialog hide];
        
        NSString *remark = textDialog.textField.text;
        self.editAccount.accountDes = remark;
        self.infoView.remark = remark;
    }];
    [dialogViewController show];
}

- (void)infoViewDidClickSourceButton {
    QMUIAlertController *actionSheet = [QMUIAlertController alertControllerWithTitle:@"选择一个账户类型"
                                                                             message:nil
                                                                      preferredStyle:QMUIAlertControllerStyleActionSheet];
    NSArray *sourceList = [[CATFundAccService service] fundAccList];
    [sourceList enumerateObjectsUsingBlock:^(CATFundAccount * _Nonnull fundAccount, NSUInteger idx, BOOL * _Nonnull stop) {
        [actionSheet addAction:[QMUIAlertAction actionWithTitle:fundAccount.fundAccName style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
            self.editAccount.assFundAccount = fundAccount.fundAccName;
            self.infoView.source = self.editAccount.assFundAccount;
        }]];
    }];
    [actionSheet addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
    [actionSheet showWithAnimated:YES];
}

#pragma mark - Keyboard
- (void)keyboardViewDidClickNumber:(NSString *)number {
    @autoreleasepool {
        NSMutableString *resAmount = [self.editingAmount mutableCopy];
        [resAmount appendString:number];
        if ([resAmount floatValue] > 10000000.0f) return;
        
        if ([self.editingAmount rangeOfString:@"."].location == self.editingAmount.length - 3) return;
        if ([self.editingAmount floatValue] == 0.0f) {
            if ([self.editingAmount containsString:@"."])
                self.editingAmount = [NSMutableString stringWithString:@"0."];
            else
                self.editingAmount = [NSMutableString string];
        }
        
        [self.editingAmount appendString:number];
        [self showAmount];
    }
}

- (void)keyboardViewDidClickDot {
    if ([self.editingAmount containsString:@"."]) return;
    
    [self.editingAmount appendString:@"."];
    [self showAmount];
}

- (void)keyboardViewDidClickClear {
    self.editingAmount = [NSMutableString stringWithString:@"0"];
    [self showAmount];
}

- (void)keyboardViewDidClickBackspace {
    if (self.editingAmount.length <= 1) {
        [self keyboardViewDidClickClear];
    } else {
        [self.editingAmount deleteCharactersInRange:NSMakeRange(self.editingAmount.length-1, 1)];
        [self showAmount];
    }
}

- (void)keyboardViewDidClickReturn {
    NSString *validateStr;
    if (![self.editAccount commitValidate:&validateStr]) {
        [QMUITips showInfo:validateStr inView:self.view hideAfterDelay:CAT_TIPS_SHOWTIME];
        return;
    }
    
    if (!self.editingMode)
    {
        [[CATAccountService service] addAccount:self.editAccount];
        [QMUITips showSucceed:@"添加成功" inView:CATApplication.keyWindow hideAfterDelay:CAT_TIPS_SHOWTIME];
        [self dismiss:nil];
        
        [CATNotificationCenter postNotificationName:CATEditingBillVCDidAddAccountNotification
                                             object:nil
                                           userInfo:@{@"year": @(self.editAccount.year), @"month": @(self.editAccount.month)}];
    }
    else
    {
        [[CATAccountService service] updateAccount:self.editAccount];
        [self dismiss:nil];
        
        [CATNotificationCenter postNotificationName:CATEditingBillVCDidUpdateAccountNotification
                                             object:nil
                                           userInfo:@{@"year": @(self.editAccount.year), @"month": @(self.editAccount.month)}];
    }
}

- (void)showAmount {
    self.infoView.amount = [NSString stringWithFormat:@"¥%@", [self.editingAmount copy]];
    self.editAccount.amount = [self.editingAmount copy];
}

#pragma mark - Collection View
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoryList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CATCategoryListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCategoryListCellIdentifier
                                                                          forIndexPath:indexPath];
    CATCategory *category = self.categoryList[indexPath.row];
    cell.titleLabel.text = category.name;
    cell.iconView.icon = UIImageMake(category.iconName);
    if (category.color) {
        cell.iconView.highlightColor = UIColorMakeWithHex(category.color);
    }
    if (CATIsEqualString(category.name, self.editAccount.categoryName) && self.editingMode) {
        cell.iconView.state = CategoryIconStateHighlight;
        self.lastCell = cell;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CATCategoryListCell *cell = (CATCategoryListCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CATCategory *selectCate = self.categoryList[indexPath.row];
    if (selectCate.categoryId == kFakeAddCateId) {
        [self addCustomCategoryFlow];
        return;
    }
    
    if (cell != self.lastCell) {
        self.lastCell.iconView.state = CategoryIconStateNormal;
        cell.iconView.state = CategoryIconStateHighlight;
        
        self.editAccount.categoryName = selectCate.name;
        self.infoView.categoryName = self.editAccount.categoryName;
        
        self.lastCell = cell;
    }
    [self.mainScroll scrollToBottom];
}

- (void)addCustomCategoryFlow {
    QMUIDialogTextFieldViewController *dialogViewController = [[QMUIDialogTextFieldViewController alloc] init];
    dialogViewController.title = @"请输入类别名称";
    dialogViewController.enablesSubmitButtonAutomatically = YES;
    dialogViewController.textField.placeholder = @"类别名称(4字以内)";
    dialogViewController.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    dialogViewController.textField.maximumTextLength = 3;
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    @weakify(self)
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        @strongify(self)
        QMUIDialogTextFieldViewController *textDialog = (QMUIDialogTextFieldViewController *)aDialogViewController;
        BOOL isIncome = self.editAccount.type;
        NSString *name = textDialog.textField.text;
        if ([[CATCategoryService service] queryCategoryWithName:name income:isIncome]) {
            [QMUITips showInfo:@"该类别已经存在，请勿重复创建" inView:CATKeyWindow hideAfterDelay:CAT_TIPS_SHOWTIME];
            return;
        }
        [[CATCategoryService service] addCustomCategoryWithName:name income:isIncome];
        [textDialog hide];
        
        [QMUITips showInfo:@"添加成功" inView:self.view hideAfterDelay:CAT_TIPS_SHOWTIME];
        NSArray *cateList = self.editAccount.type?[CATCategoryService service].incomeCategoryList:[CATCategoryService service].outcomeCategoryList;
        self.categoryList = [self installList:cateList];
        [self customLayoutViews];
        [self.categoryView reloadData];
    }];
    [dialogViewController show];
}

#pragma mark - Getters
- (UIVisualEffectView *)blurView {
    if (_blurView == nil) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    }
    return _blurView;
}

- (UIView *)naviView {
    if (_naviView == nil) {
        _naviView = [[UIView alloc] init];
        _naviView.backgroundColor = UIColorMakeWithHex(CAT_BG_GRAY);
        
        [_naviView addSubview:self.cancelButton];
        self.cancelButton.frame = CGRectMake(SCREEN_WIDTH-60, StatusBarHeight+10, 45, 24);
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = UIColorGray;
        bottomLine.frame = CGRectMake(0, StatusBarHeight+NavigationBarHeight-CATOnePixel, SCREEN_WIDTH, CATOnePixel);
        [_naviView addSubview:bottomLine];
        
        [_naviView addSubview:self.segControl];
        self.segControl.frame = CGRectMake((SCREEN_WIDTH-self.segControl.expectWidth)/2.0f, StatusBarHeight+8.f, self.segControl.expectWidth, kSegControlHeight);
        
        _naviView.alpha = 0.0;
    }
    return _naviView;
}

- (CATSegmentControl *)segControl {
    if (_segControl == nil) {
        @weakify(self)
        CATSegmentItem *outItem = [[CATSegmentItem alloc] initWithTitle:@"支出" selectAction:^{
            @strongify(self)
            [self transToOutcomeItems];
        }];
        CATSegmentItem *inItem = [[CATSegmentItem alloc] initWithTitle:@"收入" selectAction:^{
            @strongify(self)
            [self transToIncomeItems];
        }];
        
        _segControl = [[CATSegmentControl alloc] initWithSegmentItems:@[outItem, inItem] defaultIndex:self.editAccount.type];
    }
    return _segControl;
}

- (QMUIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:UIColorMakeWithHex(CAT_THEME_COLOR) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.titleLabel.font = UIFontMake(15.0f);
    }
    return _cancelButton;
}

- (UIScrollView *)mainScroll {
    if (_mainScroll == nil) {
        _mainScroll = [[UIScrollView alloc] init];
        _mainScroll.showsVerticalScrollIndicator = NO;
        _mainScroll.alwaysBounceVertical = YES;
    }
    return _mainScroll;
}

- (UICollectionView *)categoryView {
    if (_categoryView == nil) {
        _categoryView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)
                                           collectionViewLayout:self.categoryLayout];
        _categoryView.backgroundColor = UIColorClear;
        _categoryView.scrollEnabled = NO;
        _categoryView.dataSource = self;
        _categoryView.delegate = self;
        [_categoryView registerClass:[CATCategoryListCell class] forCellWithReuseIdentifier:kCategoryListCellIdentifier];
        _categoryView.alpha = 0.0;
    }
    return _categoryView;
}

- (UICollectionViewLayout *)categoryLayout {
    if (_categoryLayout == nil) {
        _categoryLayout = [[UICollectionViewFlowLayout alloc] init];
        _categoryLayout.itemSize = CGSizeMake(kCategoryItemSize, kCategoryItemHeight);
        _categoryLayout.minimumLineSpacing = kCategoryMinInset;
        _categoryLayout.minimumInteritemSpacing = kCategoryMinInset;
        _categoryLayout.sectionInset = UIEdgeInsetsMake(kCategoryMinInset, kCategoryMinInset, kCategoryMinInset, kCategoryMinInset);
    }
    return _categoryLayout;
}

- (CATKeyboardView *)keyboardView {
    if (_keyboardView == nil) {
        _keyboardView = [CATKeyboardView keyboardView];
        _keyboardView.delegate = self;
        _keyboardView.alpha = 0.0;
    }
    return _keyboardView;
}

- (CATInfoView *)infoView {
    if (_infoView == nil) {
        _infoView = [[CATInfoView alloc] init];
        _infoView.delegate = self;
        _infoView.alpha = 0.0;
    }
    return _infoView;
}

- (CATDatePickerView *)datePickerView {
    if (_datePickerView == nil) {
        _datePickerView = [[CATDatePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280)];
        _datePickerView.delegate = self;
        _datePickerView.datePicker.datePickerMode = UIDatePickerModeDate;
    }
    return _datePickerView;
}

@end
