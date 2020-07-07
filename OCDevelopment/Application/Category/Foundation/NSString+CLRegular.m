//
//  NSString+CLRegular.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/6/6.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "NSString+CLRegular.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (CLRegular)

#pragma mark - 字符串截取验证码、邀请码，5-8位数字，格式如：【10086】
- (NSString *)predicateInvitationCode {
	return [self predicateInvitationCode:nil];
}

#pragma mark - 字符串截取验证码、邀请码，5-8位数字，格式如：【10086】
- (NSString *)predicateInvitationCode:(void (^)(NSRange range))resultBlock {
	NSString *regular = @"【\\d{5,8}】";
	NSError *error = NULL;
	NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regular options:NSRegularExpressionAnchorsMatchLines error:&error];
	NSTextCheckingResult *result = [expression firstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
	if (result && !error) {
		resultBlock ? resultBlock(result.range) : nil;
		return [(NSString *)self substringWithRange:result.range];
	} else {
		return nil;
	}
}

@end
