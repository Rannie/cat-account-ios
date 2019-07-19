//
//  CATWebViewController.m
//  CatAccounting
//
//  Created by ran on 2017/9/15.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATWebViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface CATWebViewController () <WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation CATWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.requestUrlString) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrlString]];
        [self.webView loadRequest:request];
    }
    else if (self.htmlString) {
        [self.webView loadHTMLString:self.htmlString baseURL:self.htmlBaseUrl];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)initSubviews {
    [super initSubviews];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *controller = [[WKUserContentController alloc] init];
    configuration.userContentController = controller;
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    self.webView.allowsBackForwardNavigationGestures = YES;    //允许右滑返回上个链接，左滑前进
    self.webView.allowsLinkPreview = YES; //允许链接3D Touch
//    self.webView.customUserAgent = @"CatUA/1.0.0"; //自定义UA，UIWebView就没有此功能，后面会讲到通过其他方式实现
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];

    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight+StatusBarHeight, SCREEN_WIDTH, 15)];
    self.progressView.progressViewStyle = UIProgressViewStyleDefault;
    self.progressView.trackTintColor = UIColorClear;
    self.progressView.progressTintColor = UIColorBlue;
    [self.view addSubview:self.progressView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (CATIsEqualString(keyPath, @"estimatedProgress")) {
        CATLog(@"loading -- %.2f", self.webView.estimatedProgress);
        self.progressView.progress = self.webView.estimatedProgress;
    }
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    CATLog(@"finish load");
    self.progressView.progress = 0.0;
    @weakify(self)
    [webView evaluateJavaScript:@"document.title" completionHandler:^(NSString * _Nullable string, NSError * _Nullable error) {
        @strongify(self)
        self.title = string;
    }];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = !webView.canGoBack;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
