//
//  CLCornerRadius.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/19.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLCornerRadius.h"
#import <AFNetworking/UIKit+AFNetworking.h>

@implementation UIView (CLCornerRadius)

/// 添加阴影效果，带圆角
/// @param color 阴影颜色
/// @param radius 阴影半径
/// @param opacity 阴影不透明度
/// @param offset 阴影偏移量
/// @param cornerRadius 图层圆角
- (void)cl_setShadowColor:(UIColor *)color radius:(CGFloat)radius shadowOpacity:(float)opacity shadowOffset:(CGSize)offset cornerRadius:(CGFloat)cornerRadius {
	// 阴影效果要设置不裁剪
	self.clipsToBounds = NO;
	
	// layer
	self.layer.shadowColor = color.CGColor;
	self.layer.shadowOpacity = opacity;
	self.layer.shadowOffset = offset;
	self.layer.shadowRadius = radius;
	
	// 贝塞尔曲线
	UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius];
	self.layer.shadowPath = bezierPath.CGPath;
}

@end

@implementation UIImage (CLCornerRadius)

/// 绘制图片圆角
/// @param rect 大小
/// @param cornerRadius 圆角
- (UIImage *)cl_drawCornerInRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius {
	// 开启上下文
	UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
	// 使用贝塞尔曲线画出一个圆形图
	[[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius] addClip];
	// 绘制
	[self drawInRect:rect];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	// 结束画图
	UIGraphicsEndImageContext();
	return image;
}

@end

@implementation UIImageView (CLCornerRadius)

/// 设置网络图片，带圆角
/// @param urlString 图片地址
/// @param placeholderImage 占位图
/// @param cornerRadius 圆角大小
- (void)cl_setImage:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage cornerRadius:(CGFloat)cornerRadius {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
	__weak __typeof(self)weakSelf = self;
	[self setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
		weakSelf.image = [image cl_drawCornerInRect:weakSelf.bounds cornerRadius:cornerRadius];
	} failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
		weakSelf.image = [placeholderImage cl_drawCornerInRect:weakSelf.bounds cornerRadius:cornerRadius];
	}];
}

@end

@implementation UIButton (CLCornerRadius)

/// 设置图标网络图片，带圆角
/// @param urlString  图片地址
/// @param placeholderImage 占位图
/// @param cornerRadius 圆角大小
/// @param state 状态
- (void)cl_setImage:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage cornerRadius:(CGFloat)cornerRadius state:(UIControlState)state {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
	__weak __typeof(self)weakSelf = self;
	[self setBackgroundImageForState:state withURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
		[weakSelf setImage:[image cl_drawCornerInRect:weakSelf.bounds cornerRadius:cornerRadius] forState:state];
	} failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
		[weakSelf setImage:[placeholderImage cl_drawCornerInRect:weakSelf.bounds cornerRadius:cornerRadius] forState:state];
	}];
}

/// 设置网络背景图片，带圆角
/// @param urlString  图片地址
/// @param placeholderImage 占位图
/// @param cornerRadius 圆角大小
/// @param state 状态
- (void)cl_setBackgroundImage:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage cornerRadius:(CGFloat)cornerRadius state:(UIControlState)state {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
	__weak __typeof(self)weakSelf = self;
	[self setBackgroundImageForState:state withURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
		[weakSelf setBackgroundImage:[image cl_drawCornerInRect:weakSelf.bounds cornerRadius:cornerRadius] forState:state];
	} failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
		[weakSelf setBackgroundImage:[placeholderImage cl_drawCornerInRect:weakSelf.bounds cornerRadius:cornerRadius] forState:state];
	}];
}

@end
