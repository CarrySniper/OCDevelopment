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
	});
	return instance;
}

- (void)setTheme {
	UIImage *backGroundImage = [UIImage imageNamed:@"bottom_tab"];
    backGroundImage = [backGroundImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
	[[CLAppDelegate tabBarController].tabBar setBackgroundImage:backGroundImage];
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

- (void)parseDataWithFileName:(NSString *)fileName {
	/// 获取文件路径
	NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"xml"];
	
	NSDictionary *dict = [NSDictionary dictionaryWithXMLFile:path];
	NSLog(@"%@", dict);
}

@end
