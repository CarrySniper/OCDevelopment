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

#pragma mark - 修剪字符串，去掉两边的空格
- (NSString *)trimSpaces;

@end

NS_ASSUME_NONNULL_END
