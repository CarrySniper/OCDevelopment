//
//  CLBaseViewController.h
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLBaseViewController : UIViewController

/// 路由传参
@property (nonatomic, strong) NSDictionary *routerParameters;

@end

NS_ASSUME_NONNULL_END
