//
//  CLDefine.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/22.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLDefine.h"

@implementation CLDefine

// MARK: - 时间格式化
CLStringType kDateFormatOfYM                 	= @"yyyy-MM";
CLStringType kDateFormatOfYMD                 	= @"yyyy-MM-dd";
CLStringType kDateFormatOfYMDHM               	= @"yyyy-MM-dd HH:mm";
CLStringType kDateFormatOfYMDHMS              	= @"yyyy-MM-dd HH:mm:ss";

// MARK: - 通知类型
// MARK: 账号相关
CLStringType kNotification_ToLogin            	= @"kNotification_ToLogin";
CLStringType kNotification_Update             	= @"kNotification_Update";
CLStringType kNotification_Blacklist          	= @"kNotification_Blacklist";
CLStringType kNotification_LogonInvalidation 	= @"kNotification_LogonInvalidation";
CLStringType kNotification_AccountClose    		= @"kNotification_AccountClose";
CLStringType kNotification_LoginSuccess       	= @"kNotification_LoginSuccess";

// MARK: 推送开关
CLStringType kNotification_PushStatus         	= @"kNotification_PushStatus";
CLStringType kNotification_ClickPush          	= @"kNotification_ClickPush";

// MARK: 运行状态相关
CLStringType kNotification_EnterForeground    	= @"kNotification_EnterForeground";
CLStringType kNotification_EnterBackground    	= @"kNotification_EnterBackground";

@end
