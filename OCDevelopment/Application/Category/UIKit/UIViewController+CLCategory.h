//
//  UIViewController+CLCategory.h
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (CLCategory)

/// 设置导航栏透明
/// @param translucent 是否透明
/// @param backgroundImage 不透明情况下设置背景图片
- (void)setNavigationBarTransparency:(BOOL)translucent defaultBackgroundImage:(UIImage *_Nullable)backgroundImage;

/// 设置导航栏着色
/// @param tintColor 颜色
- (void)setNavigationBarTintColor:(UIColor *)tintColor;

/// 获取当前视图控制器
UIViewController * CurrentViewController(void);

/// 获取当前视图控制器
- (UIViewController *)currentViewController;

@end

NS_ASSUME_NONNULL_END
