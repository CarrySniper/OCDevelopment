//
//  CLDefine.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/22.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "CLDefineTypedef.h"
#import "CLDefineUrl.h"

/*假如宏定义比较多,建议用FOUNDATION_EXPORT。
.h 文件中 -------------
typedef NSString *KLTypeStr NS_STRING_ENUM;
 
FOUNDATION_EXPORT KLTypeStr const KLTypeStringRed;
 
.m 文件中 --------------
NSString * const KLTypeStringRed = @"红色";
*/

NS_ASSUME_NONNULL_BEGIN

@interface CLDefine : NSObject

typedef NSString * const CLStringType NS_STRING_ENUM;

// MARK: - 字段
FOUNDATION_EXPORT CLStringType kFieldOfId;							// ID
FOUNDATION_EXPORT CLStringType kFieldOfUserId;						// 用户ID
FOUNDATION_EXPORT CLStringType kFieldOfUserName;					// 用户名称
FOUNDATION_EXPORT CLStringType kFieldOfUserEmail;					// 用户邮箱
FOUNDATION_EXPORT CLStringType kFieldOfPhone;						// 手机
FOUNDATION_EXPORT CLStringType kFieldOfAccount;						// 账号
FOUNDATION_EXPORT CLStringType kFieldOfPassword;					// 密码
FOUNDATION_EXPORT CLStringType kFieldOfCode;						// 代码
FOUNDATION_EXPORT CLStringType kFieldOfNationCode;					// 国家代码
FOUNDATION_EXPORT CLStringType kFieldOfMode;						// 模式
FOUNDATION_EXPORT CLStringType kFieldOfType;						// 类型

FOUNDATION_EXPORT CLStringType kFieldOfPageNo;						// 分页页码
FOUNDATION_EXPORT CLStringType kFieldOfPageSize;					// 分页大小

FOUNDATION_EXPORT CLStringType kFieldOfCreatedAt;					// 创建时间
FOUNDATION_EXPORT CLStringType kFieldOfUpdatedAt;					// 更新时间
FOUNDATION_EXPORT CLStringType kFieldOfACL;							// 认证

// MARK: - 时间格式化
FOUNDATION_EXPORT CLStringType kDateFormatOfYM;						// 年-月
FOUNDATION_EXPORT CLStringType kDateFormatOfYMD;					// 年-月-日
FOUNDATION_EXPORT CLStringType kDateFormatOfYMDHM;					// 年-月-日 时:分
FOUNDATION_EXPORT CLStringType kDateFormatOfYMDHMS;					// 年-月-日 时:分:秒
FOUNDATION_EXPORT CLStringType kDateFormatOfHMS;					// 时:分:秒
FOUNDATION_EXPORT CLStringType kDateFormatOfHM;						// 时:分
FOUNDATION_EXPORT CLStringType kDateFormatOfMS;						// 分:秒

// MARK: - 通知类型
// MARK: 账号相关
FOUNDATION_EXPORT CLStringType kNotification_NeedLogin;				// 需要登录
FOUNDATION_EXPORT CLStringType kNotification_LoginSuccess;			// 登录成功
FOUNDATION_EXPORT CLStringType kNotification_Blacklist;				// 黑名单
FOUNDATION_EXPORT CLStringType kNotification_LogonInvalidation;		// 登录失效
FOUNDATION_EXPORT CLStringType kNotification_AccountClose;			// 封号

// MARK: 推送开关
FOUNDATION_EXPORT CLStringType kNotification_PushStatus;			// 推送状态
FOUNDATION_EXPORT CLStringType kNotification_ClickPush;				// 点击开关

// MARK: 运行状态相关
FOUNDATION_EXPORT CLStringType kNotification_EnterForeground;		// 进入前台
FOUNDATION_EXPORT CLStringType kNotification_EnterBackground;		// 进入后台


@end

NS_ASSUME_NONNULL_END
