//
//  CLToastHUD.m
//  YingTaoCommunity
//
//  Created by CarrySniper on 2020/8/10.
//  Copyright © 2020 YingTao. All rights reserved.
//

#import "CLToastHUD.h"

@implementation CLToastHUD

+ (void)hide {
	[[CLToastView sharedInstance]hide];
}

+ (void)showTip:(NSString *)tipString {
	[self showTip:tipString hideAfterDelay:kHUDAutoHideAfterDelay];
}

+ (void)showTipWithError:(NSError *)error {
	NSString *tipString = error.localizedDescription;
	if (tipString.length != 0) {
		[self showTip:tipString hideAfterDelay:kHUDAutoHideAfterDelay];
	}
}

/// 显示文本
/// @param tipString 文本
/// @param delay 自动隐藏延时
+ (void)showTip:(NSString *)tipString hideAfterDelay:(NSTimeInterval)delay {
	dispatch_async(dispatch_get_main_queue(), ^{
		[CLToastView sharedInstance].backgroundColor = UIColor.grayColor;
		[CLToastView sharedInstance].textColor = UIColor.whiteColor;
		[CLToastView sharedInstance].font = [UIFont systemFontOfSize:15 weight:(UIFontWeightRegular)];
		[[CLToastView sharedInstance] showWithMessage:tipString duration:delay position:(CLToastPosition_Center)];
	});
}

@end
