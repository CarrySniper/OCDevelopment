//
//  NSString+CLCategory.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/5/5.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CLCategory)

/// 修剪字符串，去掉两边的空格
- (NSString *)trimSpaces;

/// 转译字符，编码非法字符
- (NSString *)charactersEncoding API_AVAILABLE(ios(9.0));

@end

NS_ASSUME_NONNULL_END
