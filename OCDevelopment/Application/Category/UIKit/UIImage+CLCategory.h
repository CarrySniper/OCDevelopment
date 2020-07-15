//
//  UIImage+CLCategory.h
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CLCategory)

/// 导航栏背景图片
+ (UIImage *)navigationImage;

/// 选项栏背景图片
+ (UIImage *)tabbarImage;

/// 加载Bundlew图片
/// 内存自动释放，用在使用次数不多的地方
/// 如果重复引用：[UIImage imageNamed:@"myBundle.bundle/avatar"];
///
/// @param bundleName Bundle文件名
/// @param imageName 图片文件名
/// @return image
+ (UIImage *)imageWithBundleName:(NSString *)bundleName imageName:(NSString *)imageName;

#pragma mark - 根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color;

#pragma mark - 等比率缩放图片
- (UIImage *)scalingToMaxPixel:(CGFloat)maxPixel;

@end

NS_ASSUME_NONNULL_END
