//
//  UIViewController+CLCategory.m
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "UIViewController+CLCategory.h"

@implementation UIViewController (CLCategory)

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

- (void)setNavigationBarTintColor:(UIColor *)tintColor {
	[self.navigationController.navigationBar setTintColor:tintColor];
	[self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:tintColor}];
}

#pragma mark - getting 方法
- (UIViewController *)currentViewController {
	return [self getCurrentViewControllerWithViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)getCurrentViewControllerWithViewController:(UIViewController *)viewController {
	if ([viewController isKindOfClass:[UINavigationController class]]) {
		return [self getCurrentViewControllerWithViewController:[((UINavigationController*) viewController) visibleViewController]];
	}else if ([viewController isKindOfClass:[UITabBarController class]]){
		return [self getCurrentViewControllerWithViewController:[((UITabBarController*) viewController) selectedViewController]];
	} else {
		if (viewController.presentedViewController) {
			return [self getCurrentViewControllerWithViewController:viewController.presentedViewController];
		} else {
			return viewController;
		}
	}
}

@end
