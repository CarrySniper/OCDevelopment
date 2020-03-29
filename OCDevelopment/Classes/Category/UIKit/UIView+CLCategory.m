//
//  UIView+CLCategory.m
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "UIView+CLCategory.h"

@implementation UIView (CLCategory)

#pragma mark - setter
- (void)setBackgroundImage:(UIImage *)image {
	self.contentMode = UIViewContentModeScaleAspectFill;
	self.layer.contents = (id)image.CGImage;
}


#pragma mark - getter
+ (BOOL)isiPhoneXSeries {
	if (@available(iOS 11.0, *)) {
		UIWindow *window = [[UIApplication sharedApplication] keyWindow];
		if (window.safeAreaInsets.bottom > 0.0) {
			return YES;
		}
	}
	return NO;
}

+ (instancetype)viewFromXib {
	return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

+ (instancetype)createLine {
	UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
	lineView.backgroundColor = COLOR_LINE;
	return lineView;
}

#pragma mark - 顶级控制器，用于跳转页面等操作
- (UIViewController *)topViewController {
	UIView *next = self;
	while ((next = [next superview])) {
		UIResponder *nextResponder = [next nextResponder];
		if ([nextResponder isKindOfClass:[UIViewController class]]) {
			return (UIViewController *)nextResponder;
		}
	}
	return nil;
}

@end
