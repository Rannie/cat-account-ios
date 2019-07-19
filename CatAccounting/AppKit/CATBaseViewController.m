//
//  CATBaseViewController.m
//  CatAccounting
//
//  Created by ran on 2017/9/12.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATBaseViewController.h"
#import <UMMobClick/MobClick.h>

@interface CATKeyboardHelperInternal : NSObject
+ (instancetype)helper;
@end

@interface CATBaseViewController ()

@end

@implementation CATBaseViewController

- (void)didInitialized {
    [super didInitialized];
    [CATKeyboardHelperInternal helper];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorMakeWithHex(CAT_BG_GRAY);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass(self.class)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass(self.class)];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registerConflictGestureScroll:(UIScrollView *)scroll {
    [scroll.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configPopGesture {
    //这个可能导致乱栈。
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    NSUInteger count = self.navigationController.viewControllers.count;
    if (count > 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    /**
     * 乱栈处理
     if (count > 2 && self.navigationItem.leftBarButtonItem != nil) {
     // 连续隐藏导航栏时，连续手势返回会造成栈乱，因此禁止后一个手势返回。
     // 但在iOS10上，应该没有这个问题了，所以对iOS10以上放开限制，允许手势返回
     MKBaseViewController *previousViewController = self.navigationController.viewControllers[count - 2];
     if ([previousViewController isKindOfClass:[MKBaseViewController class]]) {
     self.navigationController.interactivePopGestureRecognizer.enabled = systemVersion >= 10.0;
     }
     else {
     self.navigationController.interactivePopGestureRecognizer.enabled = YES;
     }
     }
     else if (count > 1 && self.navigationItem.leftBarButtonItem != nil) {
     self.navigationController.interactivePopGestureRecognizer.enabled = YES;
     }
     else {
     self.navigationController.interactivePopGestureRecognizer.enabled = NO;
     }
     **/
}

@end

@implementation CATKeyboardHelperInternal

+ (instancetype)helper {
    static dispatch_once_t onceToken;
    static CATKeyboardHelperInternal *instance;
    dispatch_once(&onceToken, ^{
        instance = [[CATKeyboardHelperInternal alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleKeyboardChangeFrameNotification:)
                                                     name:UIKeyboardDidChangeFrameNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleKeyboardChangeFrameNotification:(NSNotification *)notification {
    // 解决在手写输入时，切换键盘仍显示输入候选框。
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if ([window isKindOfClass:NSClassFromString(@"UITextEffectsWindow")]) {
            [self switchHandwritingCandidateView:window withNotification:notification];
        }
    }
}

- (void)switchHandwritingCandidateView:(UIView *)view withNotification:(NSNotification *)notification {
    for (UIView *subview in view.subviews) {
        if ([NSStringFromClass(subview.class) isEqualToString:@"UIKBHandwritingCandidateView"]) {
            CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
            NSValue *value = [notification.userInfo objectForKey:@"UIKeyboardFrameBeginUserInfoKey"];
            if (value) {
                CGRect frame;
                [value getValue:&frame];
                if (frame.origin.y >= screenHeight) {
                    subview.hidden = NO;
                }
                else {
                    value = [notification.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
                    [value getValue:&frame];
                    if (frame.origin.y >= screenHeight) {
                        subview.hidden = YES;
                    }
                    else {
                        if (frame.size.height >= 252) {
                            subview.hidden = NO;
                        }
                        else {
                            subview.hidden = YES;
                        }
                    }
                }
            }
        }
        if (subview.subviews.count > 0) {
            [self switchHandwritingCandidateView:subview withNotification:notification];
        }
    }
}

@end
