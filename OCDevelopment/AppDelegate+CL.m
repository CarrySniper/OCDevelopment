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
	
	/// 路由注册
	[MGJRouter loadRegister];
	
//	[[BKPushManager manager] setupWithOptions:launchOptions];
	[self setupTabBarController];
	[self setupSVProgressHUD];
	[self setupIQKeyboardManager];
	
	/// 通知
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAccountPage) name:kNotification_NeedLogin object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logonInvalidation) name:kNotification_LogonInvalidation object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountClose) name:kNotification_AccountClose object:nil];
}

#pragma mark 配置TabBarController
- (void)setupTabBarController {
	NSArray *array = @[
	CLTabBarItemMaker(CLLocalized(@"首页"), @"CLMainHomeViewController", @"tabbar_normal0", @"tabbar_selected0"),
	CLTabBarItemMaker(CLLocalized(@"视频"), @"CLVideoMainViewController", @"tabbar_normal1", @"tabbar_selected1"),
	CLTabBarItemMaker(CLLocalized(@"我的"), @"CLMineHomeViewController", @"tabbar_normal3", @"tabbar_selected3")
	];
	self.tabBarController = [[CLTabBarController alloc]initWithTabBarItems:array];
	self.tabBarController.selectedIndex = 0;
	[self.window setRootViewController:self.tabBarController];
	[self.window makeKeyAndVisible];
}

#pragma mark - Keyboard
- (void)setupIQKeyboardManager {
    // 单例
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
	// 控制整个功能是否启用
    keyboardManager.enable = YES;
	// 控制点击背景是否收起键盘
    keyboardManager.shouldResignOnTouchOutside = YES;
	// 控制键盘上的工具条文字颜色是否与用户TextField属性一致
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES;
    // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews;
	// 控制是否显示键盘上的工具条
    keyboardManager.enableAutoToolbar = YES;
	// 是否显示占位文字
    keyboardManager.shouldShowToolbarPlaceholder = YES;
	// 设置占位文字的字体
    keyboardManager.placeholderFont = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
	// 输入框距离键盘的距离
    keyboardManager.keyboardDistanceFromTextField = 10.0f;
}

#pragma mark - SVProgressHUD
- (void)setupSVProgressHUD {
	[SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
	[SVProgressHUD setMinimumDismissTimeInterval:2.0f];
	[SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
	[SVProgressHUD setCornerRadius:4.0];
	[SVProgressHUD setMinimumSize:CGSizeMake(100, 100)];
	[SVProgressHUD setBackgroundColor:COLOR_THEME];// colorWithWhite:1.0 alpha:0.9
	[SVProgressHUD setBackgroundLayerColor:[UIColor orangeColor]];
	[SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}

#pragma mark -
#pragma mark 应用将要终止
- (void)applicationWillTerminate:(UIApplication *)application {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kNotification_NeedLogin object:nil];
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
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotification_NeedLogin object:nil];
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
	activity.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypePostToFacebook,UIActivityTypePostToTwitter];
	// 分享回调
	activity.completionWithItemsHandler = completionHandler;
	// 弹出分享页面
	[[[UIApplication sharedApplication].keyWindow.rootViewController currentViewController] presentViewController:activity animated:YES completion:^{
		
	}];
}

#pragma mark - 判断是否第一次启动
+ (BOOL)isFirstLaunching {
    // 1.从Info.plist中取出版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [NSString stringWithFormat:@"%@(%@)", infoDictionary[@"CFBundleShortVersionString"], infoDictionary[@"CFBundleVersion"]];
    // 2.从沙盒中取出上次存储的版本号
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"ApplicationVersion"];
    
    if ([version isEqualToString:saveVersion]) { // 不是第一次使用这个版本
        // 直接进入
        return NO;
    } else { // 版本号不一样：第一次使用新版本
        // 将新版本号写入沙盒
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"ApplicationVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 显示版本新特性界面
        return YES;
    }
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
+ (NSDictionary *)getAppInfo {
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	return infoDictionary;
}

@end
