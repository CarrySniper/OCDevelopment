//
//  NSString+CLCategory.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/5/5.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "NSString+CLCategory.h"

@implementation NSString (CLCategory)

#pragma mark - 修剪字符串，去掉两边的空格
- (NSString *)trimSpaces {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - 转译字符，编码非法字符(iOS9+)
- (NSString *)charactersEncoding {
	return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end
