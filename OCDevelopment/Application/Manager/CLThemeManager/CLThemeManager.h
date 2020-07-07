//
//  CLThemeManager.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/6/17.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLThemeManager : NSObject

/// 单例
+ (instancetype)sharedInstance;

- (void)setTheme;

/// 解析文件包数据
/// @param fileName 文件名
- (void)parseDataWithFileName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
