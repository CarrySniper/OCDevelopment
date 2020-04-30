//
//  MGJRouter+CL.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/27.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "MGJRouter.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const kMGJUserInfo  		= @"API://User/UserInfo";
static NSString *const kMGJUserFollow  		= @"API://User/Follow";
static NSString *const kMGJUserCollect  	= @"API://User/Collection";
static NSString *const kMGJUserMessage  	= @"API://User/Message";
static NSString *const kMGJUserHomePage  	= @"API://User/PersonalHomePage";
static NSString *const kMGJBlacklist  		= @"API://Blacklist";
static NSString *const kMGJCircleAdd  		= @"API://Circle/Add";
static NSString *const kMGJCircleDetails  	= @"API://Circle/Details";
static NSString *const kMGJCircleReport  	= @"API://Circle/Report";
static NSString *const kMGJSetting  		= @"API://Setting";
static NSString *const kMGJAboutUs  		= @"API://AboutUs";
static NSString *const kMGJFeedback			= @"API://Feedback";
static NSString *const kMGJPassword			= @"API://Password";
static NSString *const kMGJHTML				= @"API://kMGJHTML";

static NSString *const kMGJWaterfall		= @"API://Waterfall";

@interface MGJRouter (CL)

/// 注册路由地址
+ (void)loadRegister;

@end

#pragma mark - 其他类对象
#pragma mark 路由Item
@interface CLRouterItem : NSObject

/// 路由地址
@property (nonatomic, copy) NSString *routerUrlPath;

/// 控制器类名
@property (nonatomic, copy) Class viewControllerClass;

@end

#pragma mark - 内联函数 CG_INLINE NS_INLINE
NS_INLINE CLRouterItem *CLRouterItemMake(NSString *routerUrlPath, Class viewControllerClass) {
	CLRouterItem *item = [CLRouterItem new];
	item.routerUrlPath = routerUrlPath;
	item.viewControllerClass = viewControllerClass;
	return item;
}

NS_ASSUME_NONNULL_END
