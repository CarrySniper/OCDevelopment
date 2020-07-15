//
//  CLThemeManager.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/6/17.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLThemeModel.h"

/// 通知名称，在自定义UITabBarController，UINavigationController实现监听
static NSString * _Nonnull const kNotification_CLThemeDidChange = @"kNotification_CLThemeDidChange";

NS_ASSUME_NONNULL_BEGIN

/// 只做导航栏、选项栏的主题。不做复杂的主题切换，不需要那么高级的操作
@interface CLThemeManager : NSObject

/// 当前模型
@property (nonatomic, strong) CLThemeModel *currentModel;

/// 单例
+ (instancetype)sharedInstance;

/// 默认导航栏背景图片
- (UIImage *)defaultNavigationImage;

/// 默认选项栏背景图片
- (UIImage *)defaultTabBarImage;

- (void)setTheme;

- (void)setDefaultTheme;

/// 解析文件包数据
/// @param fileName 文件名
- (NSDictionary *)parseDataWithFileName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
