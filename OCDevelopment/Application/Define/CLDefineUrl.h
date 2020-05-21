//
//  CLDefineUrl.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/17.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#ifndef CLDefineUrl_h
#define CLDefineUrl_h

//MARK: - 拼接IP
#ifndef SERVER_HOST
#define SERVER_HOST         	@"请在此前做定义"// 如：https://www.baidu.com
#endif

#define REQUEST_API(__api)      [NSString stringWithFormat:@"%@%@", SERVER_HOST, __api]

//------------ request url -----------
// 静态常量比宏定义好，修改后编译速度不影响，修改宏定义预编译耗时长

//MARK: - 全局配置数据
static NSString * const kUrlClassify             = @"/classify";                     // 获取系统各分类
static NSString * const kUrlNationCodeList       = @"/configs/nationcode";           // 获取国际码列表
static NSString * const kUrlSMSCode       		= @"/new_api/NewSms/newSend";       // 获取验证码
static NSString * const kUrlImageUpload       	= @"/yapi/user/multiple_upload";    // 获取验证码

//MARK: - 用户关注粉丝
static NSString * const kUrlUserFollowList       = @"/yapi/user/userFollowList";    	// 用户关注列表
static NSString * const kUrlUserFansList       	= @"/yapi/user/userFollowedList";   // 用户粉丝列表
static NSString * const kUrlUserFollowersCount   = @"/yapi/user/getUserFollowCount"; // 获取用户关注总数
static NSString * const kUrlUserFansCount       	= @"/yapi/user/getUserFollowedCount";// 获取用户被关注总数
static NSString * const kUrlUserFollow       	= @"/new_api/Circle/follow";   		// 增加/取消关注
 
//MARK: - 用户
static NSString * const kUrlUserLogin            = @"/user/communal/login";          // 登录
static NSString * const kUrlUserRegister         = @"/user/communal/register";       // 注册
static NSString * const kUrlUserPasswordReset    = @"/user/communal/passwordReset";  // 用户密码重置
static NSString * const kUrlUserInfo             = @"/api/user/profile/userInfo";    // 获取用户信息GET
static NSString * const kUrlUserEdit             = @"/api/user/profile/userInfo";    // 修改用户信息POST

//MARK: - 人物专栏
static NSString * const kUrlCharacterLists          = @"/yapi/news/character_column";

//MARK: - 圈子 1.0.0版本
static NSString * const kUrlCircleLists          = @"/new_api/Circle/index";         // 圈子列表
static NSString * const kUrlCircleDetails        = @"/new_api/Circle/view";          // 圈子详情
static NSString * const kUrlCircleAdd        	= @"/new_api/Circle/add_Circle";   	// 添加帖子
static NSString * const kUrlCircleDelete        	= @"/new_api/Circle/del_circle";   	// 删除帖子
static NSString * const kUrlCircleCount        	= @"/new_api/Circle/count";   		// 统计数量
static NSString * const kUrlCircleAddZan        	= @"/new_api/Circle/setZans";   	// 添加点赞
static NSString * const kUrlCircleCancelZan      = @"/new_api/Circle/unsetZans";   	// 取消点赞
static NSString * const kUrlCircleCollectionList = @"/new_api/Circle/collection";   	// 添加收藏
static NSString * const kUrlCircleCollection     = @"/new_api/Circle/add_collection";// 添加收藏POST object_id / 取消收藏GET id
static NSString * const kUrlCircleCommentDel		= @"/new_api/Circle/del_comment";  	// 举报/删除帖子
static NSString * const kUrlCircleCommentAdd		= @"/new_api/Circle/add_comment";  	// 添加/回复/修改评论
static NSString * const kUrlCirclePullBlack		= @"/new_api/Circle/pullBlack";  	// 拉黑用户
 
static NSString * const kUrlKxian				= @"/yapi/Virtual/huobiproKline";
static NSString * const kUrlCurrencyInfo			= @"/yapi/Plate/currency_info";

static NSString * const kUrlVideoLists			= @"/group-app/program/list";

#endif /* CLDefineUrl_h */
