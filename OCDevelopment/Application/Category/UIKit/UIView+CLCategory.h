//
//  UIView+CLCategory.h
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define SCREEN_BOUNDS       [UIScreen mainScreen].bounds
#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height

#define IS_IPHONE_X         [UIView isiPhoneXSeries]

#define SAVE_ARE_TOP        (IS_IPHONE_X ? 24.0f : 0.0f)
#define SAVE_ARE_BOTTOM     (IS_IPHONE_X ? 34.0f : 0.0f)

#define STATUS_HEIGHT       (IS_IPHONE_X ? 44.0f : 20.0f)
#define TABBAR_HEIGHT       (SAVE_ARE_BOTTOM + 49.0f)
#define TOP_BAR_HEIGHT      (STATUS_HEIGHT + 44.0f)

@interface UIView (CLCategory)

- (void)setBackgroundImage:(UIImage *)image;

+ (BOOL)isiPhoneXSeries;

+ (instancetype)viewFromXib;

+ (instancetype)createLine;

/**
 根据view获取顶层ViewController
 */
- (UIViewController *)topViewController;

@end

NS_ASSUME_NONNULL_END
