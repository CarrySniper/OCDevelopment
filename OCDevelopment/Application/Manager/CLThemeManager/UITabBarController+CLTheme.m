//
//  UITabBarController+CLTheme.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/6/18.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "UITabBarController+CLTheme.h"

@implementation UITabBarController (CLTheme)

- (void)setThemeWithModel:(CLThemeModel *)model {

	
	
	[[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
	[[UITabBarItem appearance] setTitleTextAttributes:@{
		NSFontAttributeName : [UIFont boldSystemFontOfSize:10],
		NSForegroundColorAttributeName : COLOR_NORMAL
	} forState:UIControlStateNormal];
	[[UITabBarItem appearance] setTitleTextAttributes:@{
		NSFontAttributeName : [UIFont boldSystemFontOfSize:10],
		NSForegroundColorAttributeName : COLOR_SELECTED
	} forState:UIControlStateSelected];
	
	/// 设置底部tabbar背景图
	[self.tabBar setBackgroundImage:model.tabbarImage];
	
	/// 设置图标
	for (int index = 0; index < MIN(self.viewControllers.count, MIN(model.normalImages.count, model.selectedImages.count)); index++) {
		UIViewController *viewController = [self.viewControllers objectAtIndex:index];
		
		CGSize imageSize;
		viewController.tabBarItem.imageInsets = model.tabbarInsets;
		if (UIEdgeInsetsEqualToEdgeInsets(model.tabbarInsets, UIEdgeInsetsMake(0, 0, 0, 0))) {
			viewController.tabBarItem.title = viewController.title;
			imageSize = CGSizeMake(30, 30);
		} else {
			viewController.tabBarItem.title = @"";
			imageSize = CGSizeMake(40, 40);
		}
		
		UIImage *image = [model.normalImages objectAtIndex:index];
		if (image) {
			viewController.tabBarItem.image = [[self imageResize:image andResizeTo:imageSize] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		}
		UIImage *selectedImage = [model.selectedImages objectAtIndex:index];
		if (selectedImage) {
			viewController.tabBarItem.selectedImage = [[self imageResize:selectedImage andResizeTo:imageSize] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		}
	}
}

- (UIImage *)imageResize :(UIImage *)image andResizeTo:(CGSize)newSize {
	CGFloat scale = [[UIScreen mainScreen]scale];
	UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
	[image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end
