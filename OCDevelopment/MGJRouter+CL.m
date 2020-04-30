//
//  MGJRouter+CL.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/27.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "MGJRouter+CL.h"

#import "CLWaterfallViewController.h"

@implementation MGJRouter (CL)

//	[MGJRouter openURL:@"LWT://Test3/PushMainVC"withUserInfo:@{ @"navigationVC" : self.navigationController,
//																@"block":^(NSString * text){NSLog(@"%@",text); },
//	} completion:nil];

+ (void)loadRegister {
	NSArray *viewControllers = @[
		CLRouterItemMake(kMGJWaterfall, CLWaterfallViewController.class),
	];
	
	for (CLRouterItem *item in viewControllers) {
		Class viewControllerClass = item.viewControllerClass;
		[MGJRouter registerURLPattern:item.routerUrlPath toHandler:^(NSDictionary *routerParameters) {
			CLBaseViewController *viewController = [[viewControllerClass alloc] init];
			viewController.routerParameters = routerParameters;
			UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
			[[rootViewController currentViewController].navigationController pushViewController:viewController animated:YES];
		}];
	}
}

@end

#pragma mark - Item
@implementation CLRouterItem

@end
