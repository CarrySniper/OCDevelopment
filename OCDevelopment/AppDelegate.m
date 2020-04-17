//
//  AppDelegate.m
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "AppDelegate.h"
#import "CLLanguageManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[self setupWithOptions:launchOptions];
//	[UIApplication sharedApplication]
	NSLog(@"SERVER_HOST = %@", SERVER_HOST);
	
	NSLog(@"系统语言：%@", [[CLLanguageManager sharedInstance] systemLanguage]);
	NSLog(@"当前语言：%@", [[CLLanguageManager sharedInstance] currentLanguage]);
	NSLog(@"测试语言：%@", CLLocalized(@"apple"));
	
//	KLTypeRed
//	[self.window addSubview:self.launchView];
	// 启动图片延时: 1秒
	NSTimer *connectionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
	[[NSRunLoop currentRunLoop] addTimer:connectionTimer forMode:NSDefaultRunLoopMode];
	do{
		[[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.3]];
	}while (!done);
	return YES;
}

BOOL done;
- (void)timerFired:(NSTimer *)timer {
	done = YES;
}


@end
