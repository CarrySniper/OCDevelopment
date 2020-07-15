//
//  UITabBarController+CLTheme.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/6/18.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLThemeManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITabBarController (CLTheme)

- (void)setThemeWithModel:(CLThemeModel *)model;

@end

NS_ASSUME_NONNULL_END
