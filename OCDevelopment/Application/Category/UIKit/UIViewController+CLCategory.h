//
//  UIViewController+CLCategory.h
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (CLCategory)

- (void)setNavigationBarTransparency:(BOOL)translucent;
- (void)setNavigationBarTintColor:(UIColor *)tintColor;

- (UIViewController *)currentViewController;

@end

NS_ASSUME_NONNULL_END
