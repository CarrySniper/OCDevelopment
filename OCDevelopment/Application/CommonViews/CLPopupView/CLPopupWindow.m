//
//  CLPopupWindow.m
//  OCDevelopment
//
//  Created by CarrySniper on 2019/4/18.
//  Copyright © 2019 CarrySniper. All rights reserved.
//

#import "CLPopupWindow.h"

@implementation CLPopupWindow

#pragma mark - init
+ (instancetype)sharedInstance {
	static CLPopupWindow *instance = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
		[instance cl_setup];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
	return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return [CLPopupWindow sharedInstance];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [CLPopupWindow sharedInstance];
}

#pragma mark - 配置
- (void)cl_setup {
	if (@available(iOS 11, *)) {
		/// 显示级别statusBar以上
		self.windowLevel = UIWindowLevelStatusBar + 168;
	} else {
		/// 显示级别Alert
		self.windowLevel = UIWindowLevelAlert;
	}

	/// 设置背景颜色透明
	self.backgroundColor = UIColor.clearColor;
	
	/// 设rootViewController，才能保证状态栏颜色保持一致
	self.rootViewController = [[UIViewController alloc] init];
	self.rootViewController.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
	self.rootViewController.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
	
	/// 设主键并可视化
	[self makeKeyAndVisible];
}

#pragma mark - 更新视图
- (void)updateTheViewHidden {
	if (self.attachedView.subviews.count == 0) {
		/// 无视图之后，隐藏
		self.hidden = YES;
		[self resignKeyWindow];
	} else {
		/// 有视图，显示
		self.hidden = NO;
		[self makeKeyAndVisible];
		/// 只显示最上那一层view，其他view暂时隐藏
		for (UIView *view in self.attachedView.subviews) {
			if ([view isEqual:self.attachedView.subviews.lastObject]) {
				view.hidden = NO;
			} else {
				view.hidden = YES;
			}
		}
	}
}

#pragma mark - 获取弹出视图个数
- (NSUInteger)getPopupViewCount {
	return self.attachedView.subviews.count;
}

#pragma mark - Lazy
#pragma mark 蒙层背景-附件视图
- (UIView *)attachedView {
	return self.rootViewController.view;
}

@end
