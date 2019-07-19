//
//  CATAboutViewController.m
//  CatAccounting
//
//  Created by ran on 2017/9/30.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATAboutViewController.h"
#import "CATWebViewController.h"

@interface CATAboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end

@implementation CATAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorMakeWithHex(CAT_THEME_COLOR);
    self.title = @"关于";
    self.versionLabel.text = [NSString stringWithFormat:@"v%@", CATApplication.appVersion];
    self.authorLabel.text = @"设计、产品、开发：\n\nHanran Liu";
    [self.authorLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAuthorAreaTapped:)]];
}

- (void)onAuthorAreaTapped:(id)sender {
    CATWebViewController *webVC = [[CATWebViewController alloc] init];
    webVC.requestUrlString = @"https://rannie.bitcron.com/about";
    [self.navigationController pushViewController:webVC animated:YES];
}

@end
