//
//  CLCornerRadius.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/19.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//离屏渲染on-screen-rendering了，通过模拟器->debug->Color Off-screen Rendered（黄色的小圆角没有显示了，说明这个不是离屏渲染了）

@interface UIView (CLCornerRadius)

/// 添加阴影效果，带圆角
/// @param color 阴影颜色
/// @param radius 阴影半径
/// @param opacity 阴影不透明度
/// @param offset 阴影偏移量
/// @param cornerRadius 图层圆角
- (void)cl_setShadowColor:(UIColor *)color radius:(CGFloat)radius shadowOpacity:(float)opacity shadowOffset:(CGSize)offset cornerRadius:(CGFloat)cornerRadius;

@end

@interface UIImage (CLCornerRadius)

/// 绘制图片圆角
/// @param rect 大小
/// @param cornerRadius 圆角
- (UIImage *)cl_drawCornerInRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius;

@end

@interface UIImageView (CLCornerRadius)

/// 设置网络图片，带圆角
/// @param urlString 图片地址
/// @param placeholderImage 占位图
/// @param cornerRadius 圆角大小
- (void)cl_setImage:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage cornerRadius:(CGFloat)cornerRadius;

@end

@interface UIButton (CLCornerRadius)

/// 设置图标网络图片，带圆角
/// @param urlString  图片地址
/// @param placeholderImage 占位图
/// @param cornerRadius 圆角大小
/// @param state 状态
- (void)cl_setImage:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage cornerRadius:(CGFloat)cornerRadius state:(UIControlState)state;

/// 设置网络背景图片，带圆角
/// @param urlString  图片地址
/// @param placeholderImage 占位图
/// @param cornerRadius 圆角大小
/// @param state 状态
- (void)cl_setBackgroundImage:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage cornerRadius:(CGFloat)cornerRadius state:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END
