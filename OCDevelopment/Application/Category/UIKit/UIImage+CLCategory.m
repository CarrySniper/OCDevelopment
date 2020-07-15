//
//  UIImage+CLCategory.m
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "UIImage+CLCategory.h"

@implementation UIImage (CLCategory)

+ (UIImage *)navigationImage {
	UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOP_BAR_HEIGHT)];
	view.backgroundColor = COLOR_NAVIGATION;
	return [self convertToView:view withSize:CGSizeMake(SCREEN_WIDTH, TOP_BAR_HEIGHT)];
}

+ (UIImage *)tabbarImage {
	UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TABBAR_HEIGHT)];
	view.backgroundColor = COLOR_TABBAR;
	return [self convertToView:view withSize:CGSizeMake(SCREEN_WIDTH, TABBAR_HEIGHT)];
}

/// UIView转换成UIImage
/// @param view view
/// @return image
+ (UIImage *)convertToView:(UIView *)view withSize:(CGSize)size {
//	CGSize size = view.bounds.size;
	// 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
	UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

#pragma mark 加载Bundlew图片
+ (UIImage *)imageWithBundleName:(NSString *)bundleName imageName:(NSString *)imageName {
	NSString *resourcePath = [NSString stringWithFormat:@"%@/%@", bundleName, imageName];
	NSString *filePath = [[NSBundle mainBundle] pathForResource:resourcePath ofType:@"png"];
	UIImage *image = [UIImage imageWithContentsOfFile:filePath];
	return image;
}

#pragma mark - 根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color {
	CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

#pragma mark - 等比率缩放图片
- (UIImage *)scalingToMaxPixel:(CGFloat)maxPixel {
	float scale = 1.0;
	if (maxPixel > 0) {
		CGSize size = CGSizeFromString(NSStringFromCGSize(self.size));
		CGFloat maxSize = size.width > size.height ? size.width : size.height;
		scale = maxSize > maxPixel ? maxPixel/maxSize : 1.0;
	}
	
	UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scale, self.size.height * scale));
	[self drawInRect:CGRectMake(0, 0, self.size.width * scale, self.size.height *scale)];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return scaledImage;
}

@end
