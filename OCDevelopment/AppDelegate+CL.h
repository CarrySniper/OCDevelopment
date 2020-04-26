//
//  AppDelegate+CL.h
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN


@interface AppDelegate (CL)

/// 配置
/// @param launchOptions 启动选项
- (void)setupWithOptions:(NSDictionary *)launchOptions;

/// 通知显示账号页
+ (void)notificationShowAccountPage;

/// 通知登录失效
+ (void)notificationLogonInvalidation;

/// 跳转到App Store评论页
/// @param appleId appleId
+ (void)gotoTheCommentPageWithAppleId:(NSString *)appleId;

/// 系统自带分享
/// @param title 标题
/// @param content 内容
/// @param image 图片
/// @param URL 链接
/// @param completionHandler 回调
+ (void)shareWithTitle:(NSString * _Nullable)title
			   content:(NSString * _Nullable)content
				 image:(UIImage * _Nullable)image
				   URL:(NSURL * _Nullable)URL
	 completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)completionHandler;

/// 判断是否第一次启动
+ (BOOL)isFirstLaunching;

//app 相关信息
+ (NSString *)appName;
+ (NSString *)appVersion;
+ (NSString *)appBuildVersion;
+ (CGFloat)systemVersion;

@end

NS_ASSUME_NONNULL_END
