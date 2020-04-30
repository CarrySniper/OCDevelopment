//
//  AppDelegate.h
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

/// 选项卡
@property (nonatomic, strong) CLTabBarController *tabBarController;

@end

