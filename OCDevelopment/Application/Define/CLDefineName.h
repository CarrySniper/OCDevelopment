//
//  CLDefineName.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/17.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#ifndef CLDefineName_h
#define CLDefineName_h


// MARK: - 时间格式化
static NSString *const kDateFormatOfYM                 	= @"yyyy-MM";
static NSString *const kDateFormatOfYMD                 = @"yyyy-MM-dd";
static NSString *const kDateFormatOfYMDHM               = @"yyyy-MM-dd HH:mm";
static NSString *const kDateFormatOfYMDHMS              = @"yyyy-MM-dd HH:mm:ss";

// MARK: - 通知类型
// MARK: 账号相关
static NSString *const kNotification_ToLogin            = @"kNoti_ToLogin";
static NSString *const kNotification_Update             = @"kNoti_Update";
static NSString *const kNotification_Blacklist          = @"kNoti_Blacklist";
static NSString *const kNotification_LogonInvalidation 	= @"kNoti_LogonInvalidation";
static NSString *const kNotification_AccountClose    	= @"kNoti_AccountClose";
static NSString *const kNotification_LoginSuccess       = @"kNoti_LoginSuccess";

// MARK: 推送开关
static NSString *const kNotification_PushStatus         = @"kNoti_PushStatus";
static NSString *const kNotification_ClickPush          = @"kNoti_ClickPush";

// MARK: 运行状态相关
static NSString *const kNotification_EnterForeground    = @"kNoti_EnterForeground";
static NSString *const kNotification_EnterBackground    = @"kNoti_EnterBackground";

#endif /* CLDefineName_h */
