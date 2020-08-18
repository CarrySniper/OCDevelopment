//
//  CLToastView.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/8/4.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define CLToastShow(message) 	[[CLToastView shareInstance] showWithMessage:message duration:2 position:(CLToastPosition_Center)];
#define CLToastHide 			[[CLToastView shareInstance] hide];

NS_ASSUME_NONNULL_BEGIN

/// MARK: - 位置枚举
typedef NS_ENUM(NSUInteger, CLToastPosition) {
    CLToastPosition_Top = 0,
    CLToastPosition_Center,
    CLToastPosition_Bottom
};

@interface CLToastView : UIView

/// 字体颜色，默认whiteColor
@property (nonatomic, strong) UIColor *textColor;

/// 字体，默认15
@property (nonatomic, strong) UIFont *font;

/// 创建声明单例方法
+ (instancetype)shareInstance;

/// 弹出并显示Toast
/// @param message 文本内容
/// @param duration 显示时间
/// @param position 位置
- (void)showWithMessage:(NSString *)message duration:(CGFloat)duration position:(CLToastPosition)position;

/// 隐藏Toast
- (void)hide;

@end

NS_ASSUME_NONNULL_END
