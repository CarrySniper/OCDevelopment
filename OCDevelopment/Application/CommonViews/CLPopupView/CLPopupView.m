//
//  CLPopupView.m
//  OCDevelopment
//
//  Created by CarrySniper on 2019/4/18.
//  Copyright © 2019 CarrySniper. All rights reserved.
//

#import "CLPopupView.h"
#import "CLPopupWindow.h"
#import <Masonry/Masonry.h>

#pragma mark - @interface
@interface CLPopupView ()<UIGestureRecognizerDelegate>

/// 单击手势隐藏
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

/// CLPopupWindow的覆盖层
@property (nonatomic, strong) UIView *cl_windowAttachedView;

/// 视图容器，self加载在这里
@property (nonatomic, strong) UIView *cl_containerView;

@end

#pragma mark - @implementation
@implementation CLPopupView

- (instancetype)init
{
	self = [super init];
	if (self) {
		[self cl_base_setup];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self cl_base_setup];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self cl_base_setup];
	}
	return self;
}

- (void)dealloc {
	_cl_containerView = nil;
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

#pragma mark - 配置
- (void)cl_base_setup {
	/// 设置默认type
	self.type = CLPopupViewTypeCustom;
	
	/// 设置点击外部隐藏
	self.hideWhenTouchOutside = YES;
	
	/// 获取CLPopupWindow attachedView
	self.cl_windowAttachedView = [CLPopupWindow sharedInstance].attachedView;
}

#pragma mark - 显示
- (void)show {
	/// 添加视图
	[self.cl_windowAttachedView addSubview:self.cl_containerView];
	[self.cl_containerView addSubview:self];
	
	/// 约束类型
	switch (self.type) {
		case CLPopupViewTypeAlert: {
			[self mas_updateConstraints:^(MASConstraintMaker *make) {
				make.center.equalTo(self.cl_containerView);
			}];
		}
			break;
		case CLPopupViewTypeSheet: {
			[self mas_updateConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self.cl_containerView);
				make.bottom.equalTo(self.cl_containerView);
			}];
		}
			break;
		default:
			break;
	}
	
	/// 更新视图CLPopupWindow
	[[CLPopupWindow sharedInstance] updateTheView];
	/// 显示动画
	self.alpha = 0.6;
	self.transform = CGAffineTransformMakeScale(1.0, 1.0);
	[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
		self.transform = CGAffineTransformIdentity;
		self.alpha = 1.0;
	} completion:^(BOOL finished) {
	}];
}

#pragma mark - 隐藏
- (void)hide {
	[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
		self.transform = CGAffineTransformIdentity;
		self.alpha = 0.6;
	} completion:^(BOOL finished) {
		[self removeFromSuperview];
		[self.cl_containerView removeFromSuperview];
		/// 更新视图CLPopupWindow
		[[CLPopupWindow sharedInstance] updateTheView];
	}];
}

#pragma mark - 点击事件
- (void)tapAction:(UITapGestureRecognizer *)recognizer {
	if (self.hideWhenTouchOutside == YES) {
		[self hide];
	}
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	/// 只在点击cl_containerView的时候才运行触发隐藏
	return (touch.view == self.cl_containerView);
}

#pragma mark - lazy
#pragma mark 容器
- (UIView *)cl_containerView {
	if (!_cl_containerView) {
		_cl_containerView= [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
		_cl_containerView.backgroundColor = UIColor.clearColor;
		[_cl_containerView addGestureRecognizer:self.tapGesture];
	}
	return _cl_containerView;
}

#pragma mark 隐藏手势
- (UITapGestureRecognizer *)tapGesture {
	if (!_tapGesture) {
		_tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
		_tapGesture.cancelsTouchesInView = NO;
		_tapGesture.delegate = self;
	}
	return _tapGesture;
}

@end
