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
	return [[self alloc] init];
}

- (instancetype)init
{
	static CLPopupWindow *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [super init];
		[instance cl_setup];
	});
	return instance;
}

#pragma mark - 配置
- (void)cl_setup {
	
	// 显示级别statusBar以上
	self.windowLevel = UIWindowLevelStatusBar + 1;
	
	// 设置背景颜色透明
	self.backgroundColor = UIColor.clearColor;
	
	// 设rootViewController，才能保证状态栏颜色保持一致
	self.rootViewController = [UIViewController new];
	
	// 设主键并可视化
	[self makeKeyAndVisible];
	
	// 添加遮盖层
	[self addSubview:self.attachedView];
}

#pragma mark - 更新视图
- (void)updateTheView {
	if (self.attachedView.subviews.count == 0) {
		/// 无视图之后，隐藏
		self.attachedView.hidden = YES;
		self.hidden = YES;
		[self resignKeyWindow];
	} else {
		/// 有视图，显示
		self.attachedView.hidden = NO;
		self.hidden = NO;
		[self makeKeyAndVisible];
		/// 只显示最上那一层view，其他view暂时隐藏
		for (UIView *view in self.attachedView.subviews) {
			view.hidden = YES;
		}
		UIView *view = self.attachedView.subviews.lastObject;
		view.hidden = NO;
	}
}

#pragma mark - Lazy
#pragma mark 蒙层背景-附件视图
- (UIView *)attachedView {
	if (!_attachedView) {
		_attachedView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
		_attachedView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
	}
	return _attachedView;
}

@end
