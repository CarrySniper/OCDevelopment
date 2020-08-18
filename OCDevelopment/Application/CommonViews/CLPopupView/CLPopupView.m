//
//  CLPopupView.m
//  OCDevelopment
//
//  Created by CarrySniper on 2019/4/18.
//  Copyright © 2019 CarrySniper. All rights reserved.
//

#import "CLPopupView.h"
#import <Masonry/Masonry.h>

#pragma mark - @interface
@interface CLPopupView ()<UIGestureRecognizerDelegate>

/// 单击手势隐藏
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

/// CLPopupWindow的覆盖层
@property (nonatomic, strong) UIView *cl_windowAttachedView;

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
	NSLog(@"%@",NSStringFromSelector(_cmd));
}

#pragma mark - 配置
- (void)cl_base_setup {
	/// 设置默认type
	self.type = CLPopupViewTypeCustom;
	
	/// 设置点击外部隐藏
	self.hideWhenTouchOutside = YES;
	
	/// 获取CLPopupWindow attachedView
	self.cl_windowAttachedView = [CLPopupWindow sharedInstance].attachedView;
	
	/// 添加视图
	[self.cl_windowAttachedView addSubview:self.cl_containerView];
	[self.cl_containerView addSubview:self];
}

#pragma mark - 显示
- (void)show {
	
	/// 约束类型
	if (self.type == CLPopupViewTypeAlert) {
		[self mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self.cl_containerView);
			make.centerY.equalTo(self.cl_containerView).offset(100);
		}];
		/// 放在约束后
		[self.superview layoutIfNeeded];
	} else if (self.type == CLPopupViewTypeSheet) {
		[self mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self.cl_containerView);
			make.bottom.equalTo(self.cl_containerView).offset([UIScreen mainScreen].bounds.size.height/2);
		}];
		/// 放在约束后
		[self.superview layoutIfNeeded];
	}
	
	/// 更新视图CLPopupWindow
	[[CLPopupWindow sharedInstance] updateTheViewHidden];
	
	/// 个数为1，则有显示动画
	if ([[CLPopupWindow sharedInstance] getPopupViewCount] == 1) {
		self.cl_windowAttachedView.alpha = 0;
	}
	self.cl_containerView.alpha = 0;
	[UIView animateWithDuration:0.3 animations:^{
		self.cl_containerView.alpha = 1;
		self.cl_windowAttachedView.alpha = 1;

		if (self.type == CLPopupViewTypeAlert) {
			[self mas_updateConstraints:^(MASConstraintMaker *make) {
				make.centerY.equalTo(self.cl_containerView);
			}];
			/// 放在约束后
			[self.superview layoutIfNeeded];
		} else if (self.type == CLPopupViewTypeSheet) {
			[self mas_updateConstraints:^(MASConstraintMaker *make) {
				make.bottom.equalTo(self.cl_containerView.mas_bottom);
			}];
			/// 放在约束后
			[self.superview layoutIfNeeded];
		}
	} completion:^(BOOL finished) {
		
	}];
}

#pragma mark - 隐藏
- (void)hide {
	[UIView animateWithDuration:0.2 animations:^{
		/// 个数为1，则有隐藏动画
		if ([[CLPopupWindow sharedInstance] getPopupViewCount] == 1) {
			self.cl_windowAttachedView.alpha = 0;
		}
		self.cl_containerView.alpha = 0;
		if (self.type == CLPopupViewTypeAlert) {
			[self mas_updateConstraints:^(MASConstraintMaker *make) {
				make.centerY.equalTo(self.cl_containerView).offset(100);
			}];
			/// 放在约束后
			[self.superview layoutIfNeeded];
		} else if (self.type == CLPopupViewTypeSheet) {
			[self mas_updateConstraints:^(MASConstraintMaker *make) {
				make.bottom.equalTo(self.cl_containerView).offset([UIScreen mainScreen].bounds.size.height/2);
			}];
			/// 放在约束后
			[self.superview layoutIfNeeded];
		}
	} completion:^(BOOL finished) {
		[self removeFromSuperview];
		[self.cl_containerView removeFromSuperview];
		/// 更新视图CLPopupWindow
		[[CLPopupWindow sharedInstance] updateTheViewHidden];
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
