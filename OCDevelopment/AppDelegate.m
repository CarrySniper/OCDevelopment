//
//  AppDelegate.m
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "AppDelegate.h"
#import "CLLanguageManager.h"
#import "CLCalendarManager.h"
#import "NSString+CLEncode.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[self setupWithOptions:launchOptions];
//	[UIApplication sharedApplication]

	NSDate *one = [[CLCalendarManager sharedInstance] dateFromString:@"2019-12-31" dateFormat:kDateFormatOfYMD];
	NSDate *two = [[CLCalendarManager sharedInstance] dateFromString:@"2020-01-01" dateFormat:kDateFormatOfYMD];
	if ([[CLCalendarManager sharedInstance] isSameWeek:one date2:two]) {
		NSLog(@"同一周");
	} else {
		NSLog(@"不同一周");
	}//{"code":0,"data":{"uid":10123,"age":"十八"}}
	NSString *result = @"qEYj/dy5RtyeJw7susgFsSCrTInFTBafpADgj8I9Zwysz1uC2hkg4E9NaRB62zP7";
//	NSString *result = @"yh+5PewM2Kmhi/+ow9hlwN1ldmxK+D4P1YFyMaVrj3q9iN/6cYnJDC6GH5nPTTHC";
//	NSString *result = [@"{\"code\":0,\"data\":{\"uid\":10123,\"age\":\"十八\"}}" AESEncryptWithKey:@"wgrwgwggg"];
	NSData *jiemi = [result dataAESDecryptWithKey:@"1500306782158961"];

	NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jiemi options:NSJSONReadingMutableContainers error:nil];
	
	NSLog(@"IS_PRODUCATION = %@ SERVER_HOST = %@", IS_PRODUCATION ? @"生产环境" : @"开发环境", SERVER_HOST);
	
	NSLog(@"系统语言：%@", [[CLLanguageManager sharedInstance] systemLanguage]);
	NSLog(@"当前语言：%@", [[CLLanguageManager sharedInstance] currentLanguage]);
	NSLog(@"测试语言：%@", CLLocalized(@"apple"));
	
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
