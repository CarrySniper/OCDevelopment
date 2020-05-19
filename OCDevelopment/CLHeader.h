//
//  CLHeader.h
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#ifndef CLHeader_h
#define CLHeader_h

// FIXME: - 配置应用信息
#define kAppLanguage			@"zh-CN"
#define kApplyName				@"finance"
#define kCircleCategoryId		@"158"
#define kDeviceType				@"iphone"
#define kApiVersion				@"1.0.0"

#define APPLE_ID				@""
#define UMENG_APP_KEY			@"5d9080384ca357ae84000e2a"

#define COLOR_UP           		[UIColor colorHexString:@"#E82B4D"]
#define COLOR_DOWN           	[UIColor colorHexString:@"#6EDE32"]
#define COLOR_FLAT           	[UIColor colorHexString:@"#A1A1A1"]
// FIXME: - 配置提示语
#define TEXT_NEED_LOGIN         		@"用户未登录"
#define TEXT_LOADING       				@"数据加载中"
#define TEXT_NO_DATA         			@"没有相关数据"

// FIXME: - 配置图片
#define IMAGE_AVATAR 					[UIImage imageNamed:@"avatar"]				// 本地头像
#define IMAGE_NAVIGATION_BACK 			[UIImage imageNamed:@"navigation_back"]			// 导航栏返回按钮图标
#define IMAGE_MORE 						[UIImage imageNamed:@"my_icon_more"]			// 更多图标
#define IMAGE_APPICON 					[UIImage imageNamed:@"logo_about"]			// 本地logo
#define IMAGE_PLACEHOLDER 				[UIImage imageNamed:@"image_placeholder"]	// 本地图片占位图
#define IMAGE_NO_DATA 					[UIImage imageNamed:@"empty_content"]		// 没有数据占位图


/*=========================== TOAST ===========================*/
#define SHOW_TOAST_INFO(text) 			[SVProgressHUD showInfoWithStatus:text];dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{[SVProgressHUD dismiss];});
//#define SHOW_TOAST_SUCCESS(text) 		SHOW_TOAST_INFO(text)
//#define SHOW_TOAST_ERROR(text) 			SHOW_TOAST_INFO(text)
//#define SHOW_ERROR(error) 				SHOW_TOAST_ERROR(error.localizedDescription)
//
//#define SHOW_LOADING(view) 				[SVProgressHUD show];
//#define HIDE_LOADING(view) 				[SVProgressHUD dismiss];

//#ifndef __OPTIMIZE__  //__OPTIMIZE__ 是release 默认会加的宏
//#define NSLog(fmt,...)  NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
//#else
//#define NSLog(...){}
//#endif

#define WEAKSELF        typeof(self)            __weak weakSelf = self;
#define BKAppDelegate	(AppDelegate *)[UIApplication sharedApplication].delegate


#endif /* CLHeader_h */
