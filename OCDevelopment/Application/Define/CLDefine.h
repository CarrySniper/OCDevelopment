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

// MARK: - 时间格式化
FOUNDATION_EXPORT CLStringType kDateFormatOfYM;
FOUNDATION_EXPORT CLStringType kDateFormatOfYMD;
FOUNDATION_EXPORT CLStringType kDateFormatOfYMDHM;
FOUNDATION_EXPORT CLStringType kDateFormatOfYMDHMS;

// MARK: - 通知类型
// MARK: 账号相关
FOUNDATION_EXPORT CLStringType kNotification_ToLogin;
FOUNDATION_EXPORT CLStringType kNotification_Update;
FOUNDATION_EXPORT CLStringType kNotification_Blacklist;
FOUNDATION_EXPORT CLStringType kNotification_LogonInvalidation;
FOUNDATION_EXPORT CLStringType kNotification_AccountClose;
FOUNDATION_EXPORT CLStringType kNotification_LoginSuccess;

// MARK: 推送开关
FOUNDATION_EXPORT CLStringType kNotification_PushStatus;
FOUNDATION_EXPORT CLStringType kNotification_ClickPush;

// MARK: 运行状态相关
FOUNDATION_EXPORT CLStringType kNotification_EnterForeground;
FOUNDATION_EXPORT CLStringType kNotification_EnterBackground;

@end

NS_ASSUME_NONNULL_END
