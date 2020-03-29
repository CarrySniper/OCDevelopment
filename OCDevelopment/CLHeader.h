//
//  CLHeader.h
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#ifndef CLHeader_h
#define CLHeader_h

// FIXME: - 配置信息
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
#define IMAGE_NAVIGATION_BACK 			[UIImage imageNamed:@"icon_back_wh"]			// 导航栏返回按钮图标
#define IMAGE_MORE 						[UIImage imageNamed:@"my_icon_more"]			// 更多图标
#define IMAGE_APPICON 					[UIImage imageNamed:@"logo_about"]			// 本地logo
#define IMAGE_PLACEHOLDER 				[UIImage imageNamed:@"image_placeholder"]	// 本地图片占位图
#define IMAGE_NO_DATA 					[UIImage imageNamed:@"无数据"]		// 没有数据占位图

// FIXME: - 时间格式化
static NSString *const kDateFormatOfYM                 	= @"yyyy-MM";
static NSString *const kDateFormatOfYMD                 = @"yyyy-MM-dd";
static NSString *const kDateFormatOfYMDHM               = @"yyyy-MM-dd HH:mm";
static NSString *const kDateFormatOfYMDHMS              = @"yyyy-MM-dd HH:mm:ss";

// FIXME: - 通知类型
static NSString *kNotification_ToLogin                  = @"kNoti_ToLogin";
static NSString *kNotification_Update             		= @"kNoti_Update";
static NSString *kNotification_Blacklist             	= @"kNoti_Blacklist";
static NSString *kNotification_LogonInvalidation    	= @"kNoti_LogonInvalidation";
static NSString *kNotification_AccountClose    			= @"kNoti_AccountClose";
static NSString *kNotification_LoginSuccess             = @"kNoti_LoginSuccess";
//推送开关
static NSString  *kNotification_PushStatus              = @"kNoti_PushStatus";
static NSString  *kNotification_ClickPush               = @"kNoti_ClickPush";

//显示前台
static NSString  *kNotification_EnterForeground         = @"kNoti_EnterForeground";
static NSString  *kNotification_EnterBackground         = @"kNoti_EnterBackground";

/*=========================== TOAST ===========================*/
//#define SHOW_TOAST_INFO(text) 			[SVProgressHUD showInfoWithStatus:text];dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{[SVProgressHUD dismiss];});
//#define SHOW_TOAST_SUCCESS(text) 		SHOW_TOAST_INFO(text)
//#define SHOW_TOAST_ERROR(text) 			SHOW_TOAST_INFO(text)
//#define SHOW_ERROR(error) 				SHOW_TOAST_ERROR(error.localizedDescription)
//
//#define SHOW_LOADING(view) 				[SVProgressHUD show];
//#define HIDE_LOADING(view) 				[SVProgressHUD dismiss];

#ifndef __OPTIMIZE__  //__OPTIMIZE__ 是release 默认会加的宏
#define NSLog(fmt,...)  NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define NSLog(...){}
#endif

#define WEAKSELF        typeof(self)            __weak weakSelf = self;
#define BKAppDelegate	(AppDelegate *)[UIApplication sharedApplication].delegate

// FIXME: - 拼接IP
#define SERVER_HOST         	@"https://data.beijingjgmy.cn"
#define REQUEST_API(__api)      [NSString stringWithFormat:@"%@%@", SERVER_HOST, __api]

//------------ request url -----------
// 静态常量比宏定义好，修改后编译速度不影响，修改宏定义预编译耗时长

//FIXME: - 全局配置数据
static NSString *const kUrlClassify             = @"/classify";                     // 获取系统各分类
static NSString *const kUrlNationCodeList       = @"/configs/nationcode";           // 获取国际码列表
static NSString *const kUrlSMSCode       		= @"/new_api/NewSms/newSend";       // 获取验证码
static NSString *const kUrlImageUpload       	= @"/yapi/user/multiple_upload";    // 获取验证码

//FIXME: - 用户关注粉丝
static NSString *const kUrlUserFollowList       = @"/yapi/user/userFollowList";    	// 用户关注列表
static NSString *const kUrlUserFansList       	= @"/yapi/user/userFollowedList";   // 用户粉丝列表
static NSString *const kUrlUserFollowersCount   = @"/yapi/user/getUserFollowCount"; // 获取用户关注总数
static NSString *const kUrlUserFansCount       	= @"/yapi/user/getUserFollowedCount";// 获取用户被关注总数
static NSString *const kUrlUserFollow       	= @"/new_api/Circle/follow";   		// 增加/取消关注

//FIXME: - 用户
static NSString *const kUrlUserLogin            = @"/user/communal/login";          // 登录
static NSString *const kUrlUserRegister         = @"/user/communal/register";       // 注册
static NSString *const kUrlUserPasswordReset    = @"/user/communal/passwordReset";  // 用户密码重置
static NSString *const kUrlUserInfo             = @"/api/user/profile/userInfo";    // 获取用户信息GET
static NSString *const kUrlUserEdit             = @"/api/user/profile/userInfo";    // 修改用户信息POST

//FIXME: - 人物专栏
static NSString *const kUrlCharacterLists          = @"/yapi/news/character_column";

//FIXME: - 圈子 1.0.0版本
static NSString *const kUrlCircleLists          = @"/new_api/Circle/index";         // 圈子列表
static NSString *const kUrlCircleDetails        = @"/new_api/Circle/view";          // 圈子详情
static NSString *const kUrlCircleAdd        	= @"/new_api/Circle/add_Circle";   	// 添加帖子
static NSString *const kUrlCircleDelete        	= @"/new_api/Circle/del_circle";   	// 删除帖子
static NSString *const kUrlCircleCount        	= @"/new_api/Circle/count";   		// 统计数量
static NSString *const kUrlCircleAddZan        	= @"/new_api/Circle/setZans";   	// 添加点赞
static NSString *const kUrlCircleCancelZan      = @"/new_api/Circle/unsetZans";   	// 取消点赞
static NSString *const kUrlCircleCollectionList = @"/new_api/Circle/collection";   	// 添加收藏
static NSString *const kUrlCircleCollection     = @"/new_api/Circle/add_collection";// 添加收藏POST object_id / 取消收藏GET id
static NSString *const kUrlCircleCommentDel		= @"/new_api/Circle/del_comment";  	// 举报/删除帖子
static NSString *const kUrlCircleCommentAdd		= @"/new_api/Circle/add_comment";  	// 添加/回复/修改评论
static NSString *const kUrlCirclePullBlack		= @"/new_api/Circle/pullBlack";  	// 拉黑用户

static NSString *const kUrlKxian				= @"/yapi/Virtual/huobiproKline";
static NSString *const kUrlCurrencyInfo			= @"/yapi/Plate/currency_info";

#endif /* CLHeader_h */
