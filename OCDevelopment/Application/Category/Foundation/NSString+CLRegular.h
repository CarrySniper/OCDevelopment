//
//  NSString+CLRegular.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/6/6.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CLRegular)

/// 字符串截取验证码、邀请码，5-8位数字，格式如：【10086】
- (NSString *)predicateInvitationCode;

/// 字符串截取验证码、邀请码，5-8位数字，格式如：【10086】
/// @param resultBlock 回调，返回匹配的位置，用于标识
- (NSString *)predicateInvitationCode:(void (^)(NSRange range))resultBlock;

@end

NS_ASSUME_NONNULL_END
