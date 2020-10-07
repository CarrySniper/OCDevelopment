//
//  CLToastHUD.h
//  YingTaoCommunity
//
//  Created by CarrySniper on 2020/8/10.
//  Copyright © 2020 YingTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLToastView.h"

NS_ASSUME_NONNULL_BEGIN

/// 默认自动隐藏的时间
static NSTimeInterval const kHUDAutoHideAfterDelay = 2.0;

@interface CLToastHUD : NSObject

/// 隐藏所有hud
+ (void)hide;

/// 显示文本，默认的时间后自动隐藏
/// @param tipString 文本
+ (void)showTip:(NSString *)tipString;

/// 显示错误信息
/// @param error 错误对象
+ (void)showTipWithError:(NSError *)error;

/// 显示文本
/// @param tipString 文本
/// @param delay 自动隐藏延时
+ (void)showTip:(NSString *)tipString hideAfterDelay:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END
