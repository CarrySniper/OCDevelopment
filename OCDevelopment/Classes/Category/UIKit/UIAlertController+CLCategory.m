//
//  UIAlertController+CLCategory.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/6.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "UIAlertController+CLCategory.h"

@implementation UIAlertController (CLCategory)

#pragma mark -
#pragma mark 显示警告框，只有一个“确定”按钮
+ (void)showAlertWithTitle:(NSString * _Nullable)title
				   message:(NSString * _Nullable)message
			  actionHander:(void (^_Nullable)(UIAlertAction *action))actionHander
{
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:actionHander];
	[cancelAction setValue:COLOR_THEME forKey:@"titleTextColor"];
	[alertController addAction:cancelAction];
	
	[[self currentViewController] presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 显示警告框，默认一个“取消”按钮和自定义按钮
+ (void)showAlertWithTitle:(NSString * _Nullable)title
				   message:(NSString * _Nullable)message
				handerName:(NSString * _Nullable)handerName
			  actionHander:(void (^_Nullable)(UIAlertAction *action))actionHander
{
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	
	if (handerName) {
		UIAlertAction *optionAction = [UIAlertAction actionWithTitle:handerName style:UIAlertActionStyleDefault handler:actionHander];
		[optionAction setValue:COLOR_BLACK forKey:@"titleTextColor"];
		[alertController addAction:optionAction];
	}
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
	[cancelAction setValue:COLOR_THEME forKey:@"titleTextColor"];
	[alertController addAction:cancelAction];
	
	[[self currentViewController] presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -
#pragma mark 显示操作列表框，默认一个“取消”按钮和列表按钮
+ (void)showActionSheetWithTitle:(NSString * _Nullable)title
						 message:(NSString * _Nullable)message
				 handerNameArray:(NSArray<NSString *> * _Nullable)handerNameArray
					actionHander:(void (^_Nullable)(UIAlertAction *action, NSUInteger selectedIndex))actionHander
{
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:[self isPad] ? UIAlertControllerStyleAlert:UIAlertControllerStyleActionSheet];
	
	for (NSString *title in handerNameArray) {
		UIAlertAction *optionAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			if (actionHander) {
				actionHander(action, [handerNameArray indexOfObject:action.title]);
			}
		}];
		[optionAction setValue:COLOR_BLACK forKey:@"titleTextColor"];
		[alertController addAction:optionAction];
	}
	
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
	[cancelAction setValue:COLOR_THEME forKey:@"titleTextColor"];
	[alertController addAction:cancelAction];
	[[self currentViewController] presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - getting 方法
+ (UIViewController *)currentViewController {
	UIViewController *currentViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
	while (currentViewController.presentedViewController) {
		currentViewController = currentViewController.presentedViewController;
	}
	if ([currentViewController isKindOfClass:[UITabBarController class]]) {
		currentViewController = [(UITabBarController *)currentViewController selectedViewController];
	}
	if ([currentViewController isKindOfClass:[UINavigationController class]]) {
		currentViewController = [(UINavigationController *)currentViewController topViewController];
	}
	return currentViewController;
}

+ (BOOL)isPad {
	return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

@end
