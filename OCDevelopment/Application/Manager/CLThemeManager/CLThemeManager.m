//
//  CLThemeManager.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/6/17.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLThemeManager.h"
#import "XMLDictionary.h"

#import "UITabBarController+CLTheme.h"

@interface CLThemeManager ()

@end

@implementation CLThemeManager

+ (instancetype)sharedInstance {
	return [[self alloc] init];
}

- (instancetype)init
{
	static CLThemeManager *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [super init];
		[instance setDefaultTheme];
	});
	return instance;
}

- (void)setTheme {
	NSDictionary *dict = [[CLThemeManager sharedInstance] parseDataWithFileName:@"resource"];
	
	
	/// 背景图片，顺序top_tab，bottom_tab，sidebar，profile_tab
	NSMutableArray *backgroundImages = [NSMutableArray array];
	NSArray *background_theme = dict[@"background_theme"];
	for (NSDictionary *background in background_theme) {
		[backgroundImages addObject:[UIImage imageNamed:background[@"background_image"]]];
	}
	/// 选项栏图标
	NSMutableArray *normalImages = [NSMutableArray array];
	NSMutableArray *selectedImages = [NSMutableArray array];
	NSArray *tab_theme = dict[@"tab_theme"];
	for (NSDictionary *tabbarItem in tab_theme) {
		[normalImages addObject:[UIImage imageNamed:tabbarItem[@"image_normal"]]];
		[selectedImages addObject:[UIImage imageNamed:tabbarItem[@"image_pressed"]]];
	}
	
	UIImage *top_tab = [backgroundImages objectAtIndex:0];
	top_tab = [top_tab resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
	UIImage *bottom_tab = [backgroundImages objectAtIndex:1];
	bottom_tab = [bottom_tab resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
	
	/// 构造主题模型，用于传值
	CLThemeModel *model = [CLThemeModel new];
	model.navigationImage = top_tab;
	model.navigationTintColor = UIColor.whiteColor;
	model.tabbarImage = bottom_tab;
	model.normalImages = normalImages;
	model.selectedImages = selectedImages;
	model.tabbarInsets = UIEdgeInsetsMake(-5, -5, -5, -5);
	self.currentModel = model;
	
	UITabBarController *tabBarController = [CLAppDelegate tabBarController];
	[tabBarController setThemeWithModel:model];
	
	/// 发起切换通知
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotification_CLThemeDidChange object:model];
}

- (void)setDefaultTheme {
	/// 构造主题模型，用于传值
	CLThemeModel *model = [CLThemeModel new];
	model.navigationImage = [self defaultNavigationImage];
	model.navigationTintColor = COLOR_TITLE;
	model.tabbarImage = [self defaultTabBarImage];
	model.tabbarInsets = UIEdgeInsetsMake(0, 0, 0, 0);
	/// 选项栏图标
	NSMutableArray *normalImages = [NSMutableArray array];
	NSMutableArray *selectedImages = [NSMutableArray array];
	for (int i = 0; i < 5; i++) {
		UIImage *normalImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_normal%d", i]];
		UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_selected%d", i]];
		if (normalImage) {
			[normalImages addObject:normalImage];
		}
		if (selectedImage) {
			[selectedImages addObject:selectedImage];
		}
	}
	model.normalImages = normalImages;
	model.selectedImages = selectedImages;
	self.currentModel = model;
	
	UITabBarController *tabBarController = [CLAppDelegate tabBarController];
	[tabBarController setThemeWithModel:model];
	/// 发起切换通知
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotification_CLThemeDidChange object:model];
}

/// 默认导航栏背景图片
- (UIImage *)defaultNavigationImage {
	return [UIImage navigationImage];
}

/// 默认选项栏背景图片
- (UIImage *)defaultTabBarImage {
	return [UIImage tabbarImage];
}


//从本地xml文件中解析城市信息

- (NSString *)readLocalXMLWithFileName:(NSString *)fileName {
	/// 获取文件路径
	NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"xml"];
	/// 将文件数据化
	NSData *data = [[NSData alloc] initWithContentsOfFile:path];
	/// 解码
	return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)parseDataWithFileName:(NSString *)fileName {
	/// 获取文件路径
	NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"xml"];
	
	NSDictionary *dict = [NSDictionary dictionaryWithXMLFile:path];
	NSLog(@"%@", dict);
	return dict;
}

@end
