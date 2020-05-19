//
//  UIViewController+CLCategory.m
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "UIViewController+CLCategory.h"

@implementation UIViewController (CLCategory)

#pragma mark 设置导航栏透明，不透明有下划线
- (void)setNavigationBarTransparency:(BOOL)translucent {
	self.navigationController.navigationBar.translucent = translucent;
	if (translucent) {
		[self.navigationController.navigationBar setShadowImage:[UIImage new]];
		[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
	} else {
		[self.navigationController.navigationBar setShadowImage:nil];
		[self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
	}
}

#pragma mark 设置导航栏着色
- (void)setNavigationBarTintColor:(UIColor *)tintColor {
	[self.navigationController.navigationBar setTintColor:tintColor];
	[self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:tintColor}];
}

#pragma mark - getting 方法
UIViewController * CurrentViewController() {
	UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
	return [viewController getCurrentViewControllerWithViewController:viewController];
}

- (UIViewController *)currentViewController {
	return [self getCurrentViewControllerWithViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)getCurrentViewControllerWithViewController:(UIViewController *)viewController {
	while (1) {
        if (viewController.presentedViewController) {
            viewController = viewController.presentedViewController;
        } else if ([viewController isKindOfClass:[UITabBarController class]]) {
            viewController = ((UITabBarController *)viewController).selectedViewController;
        } else if ([viewController isKindOfClass:[UINavigationController class]]) {
            viewController = ((UINavigationController *)viewController).visibleViewController;
        } else {
            break;
        }
    }
    return viewController;
}

@end
