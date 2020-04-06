//
//  AppDelegate+CL.m
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "AppDelegate+CL.h"
#import "CLAccountViewController.h"
#import "CLNavigationController.h"

@implementation AppDelegate (CL)

#pragma mark - 配置
- (void)setupWithOptions:(NSDictionary *)launchOptions {
	[[UITextField appearance] setTintColor:COLOR_SELECTED];
	[[UITextView appearance] setTintColor:COLOR_SELECTED];
//	[MGJRouter load];
//	[[BKPushManager manager] setupWithOptions:launchOptions];
	[self setupSVProgressHUD];
	
	/// 通知
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAccountPage) name:kNotification_ToLogin object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logonInvalidation) name:kNotification_LogonInvalidation object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountClose) name:kNotification_AccountClose object:nil];
}

#pragma mark -
#pragma mark 应用将要终止
- (void)applicationWillTerminate:(UIApplication *)application {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kNotification_ToLogin object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kNotification_LogonInvalidation object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kNotification_AccountClose object:nil];
}

#pragma mark 推送注册deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	/// Required - 注册 DeviceToken
//	[UMessage registerDeviceToken:deviceToken];
	NSLog(@"deviceToken=%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
							  stringByReplacingOccurrencesOfString: @">" withString: @""]
							 stringByReplacingOccurrencesOfString: @" " withString: @""]);
}

#pragma mark - 通知
#pragma mark 通知显示账号页
+ (void)notificationShowAccountPage {
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotification_ToLogin object:nil];
}

#pragma mark 通知登录失效
+ (void)notificationLogonInvalidation {
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotification_LogonInvalidation object:nil];
}

#pragma mark -
#pragma mark 显示登陆页
- (void)showAccountPage {
	dispatch_async(dispatch_get_main_queue(), ^{
		Class accountClass = CLAccountViewController.class;
		UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
		if (keyWindow.rootViewController.presentedViewController) {
			if ([(UINavigationController *)keyWindow.rootViewController.presentedViewController viewControllers].firstObject &&
				[[(UINavigationController *)keyWindow.rootViewController.presentedViewController viewControllers].firstObject isKindOfClass:accountClass]) {
				return;
			}
		} else if (keyWindow.rootViewController.presentingViewController) {
			if ([(UINavigationController *)keyWindow.rootViewController.presentingViewController viewControllers].firstObject &&
				[[(UINavigationController *)keyWindow.rootViewController.presentingViewController viewControllers].firstObject isKindOfClass:accountClass]) {
				return;
			}
		}
		CLNavigationController *navigationController = [[CLNavigationController alloc] initWithRootViewController:[[accountClass alloc]init]];
		[keyWindow.rootViewController presentViewController:navigationController animated:YES completion:nil];
	});
}

#pragma mark 登录失效
- (void)logonInvalidation {
	dispatch_async(dispatch_get_main_queue(), ^{
		[CLUser logout];
		[UIAlertController showAlertWithTitle:@"登录失效" message:@"您的身份令牌时效已过\n请重新登录！" handerName:@"重新登录" actionHander:^(UIAlertAction * _Nonnull action) {
			[self showAccountPage];
		}];
	});
}

#pragma mark 封号
- (void)accountClose {
	
}

- (void)setupSVProgressHUD {
//	[SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
//	[SVProgressHUD setMinimumDismissTimeInterval:2.0f];
//	[SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
//	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
//	[SVProgressHUD setCornerRadius:4.0];
//	[SVProgressHUD setMinimumSize:CGSizeMake(100, 100)];
//	[SVProgressHUD setBackgroundColor:COLOR_THEME];// colorWithWhite:1.0 alpha:0.9
//	[SVProgressHUD setBackgroundLayerColor:[UIColor orangeColor]];
//	[SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}
#pragma mark - 跳转到AppStore评论页
+ (void)gotoTheCommentPageWithAppleId:(NSString *)appleId {
	NSString *urlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@&pageNumber=0&sortOrdering=2&mt=8", appleId];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

#pragma mark - 系统自带分享
+ (void)shareWithTitle:(NSString *)title content:(NSString *)content image:(UIImage *)image URL:(NSURL *)URL completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)completionHandler {
	NSMutableArray *activityItems = [NSMutableArray array];
	if (title) {
		[activityItems addObject:title];
	}
	if (content) {
		[activityItems addObject:content];
	}
	if (image) {
		[activityItems addObject:image];
	}
	if (URL) {
		[activityItems addObject:URL];
	}
	UIActivityViewController *activity = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
	// 不需要分享的地方
	activity.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
	// 分享回调
	activity.completionWithItemsHandler = completionHandler;
	// 弹出分享页面
	[[[UIApplication sharedApplication].keyWindow.rootViewController currentViewController] presentViewController:activity animated:YES completion:^{
		
	}];
}

#pragma mark - app 相关信息
+ (NSString *)appName {
	return [[self getAppInfo] objectForKey:@"CFBundleDisplayName"];
}
+ (NSString *)appVersion {
	return [[self getAppInfo] objectForKey:@"CFBundleShortVersionString"];
}
+ (NSString *)appBuildVersion {
	return [[self getAppInfo] objectForKey:@"CFBundleVersion"];
}
+ (CGFloat)systemVersion {
	return [[[UIDevice currentDevice] systemVersion] floatValue];
}
+ (NSDictionary *) getAppInfo {
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	return infoDictionary;
}

@end
