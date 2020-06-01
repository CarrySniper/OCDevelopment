//
//  CLAddressView.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/6/1.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLAddressView.h"

@interface CLAddressView ()

/// 完成回调
@property (nonatomic, copy) void(^completionHandler)(NSString *currentModel);

@end

@implementation CLAddressView

+ (instancetype)showViewWithCurrentModel:(NSString *)currentModel
					   completionHandler:(void(^)(NSString *currentModel))completionHandler {
	CLAddressView *view = [[self alloc] init];
	view.type = CLPopupViewTypeSheet;
	view.hideWhenTouchOutside = YES;
	/// 回调
	view.completionHandler = completionHandler;
	
	[view cl_setup];
	[view show];
	return view;// 有次忘了return，编译不报错、运行成功，但是retain崩溃，一直找不到原因
}

- (void)cl_setup {
	// 背景色
	self.backgroundColor = UIColor.whiteColor;
//
//	// 顶部
//	[self addSubview:self.topView];
//	[self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.top.left.right.equalTo(self);
//		make.height.mas_equalTo(44);
//	}];
//
//	// 底部
//	[self addSubview:self.bottomView];
//	[self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.bottom.left.right.equalTo(self);
//		make.height.mas_equalTo(80+SAVE_ARE_BOTTOM);
//	}];
//
//	// 中部
//	[self addSubview:self.containerView];
//	[self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.left.right.equalTo(self);
//		make.top.equalTo(self.topView.mas_bottom);
//		make.bottom.equalTo(self.bottomView.mas_top);
//	}];
//
////	_bottomView.backgroundColor = UIColor.cyanColor;
////	_topView.backgroundColor = UIColor.cyanColor;
}

#pragma mark - 显示并设置，调用父类的show，子类继承的话要用mas_updateConstraints更新约束
- (void)show {
	[super show];
	
	[self mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(SCREEN_WIDTH);
		make.height.mas_equalTo(200);
	}];
}

#pragma mark - 隐藏
- (void)hide {
	[super hide];
}

#pragma mark 完成事件
- (void)doneAction {
	if (self.completionHandler) {
		self.completionHandler(@"");
	}
	[self hide];
}

#pragma make - 添加圆角
- (void)makeCorner {
	[self layoutIfNeeded];
	// 圆角大小
	CGFloat radius = 10.0;
	// 圆角位置
	UIRectCorner corner = UIRectCornerTopLeft | UIRectCornerTopRight;
	// 贝塞尔曲线
	UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
													 byRoundingCorners:corner
														   cornerRadii:CGSizeMake(radius, radius)];
	CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
	maskLayer.frame = self.bounds;
	maskLayer.path = bezierPath.CGPath;
	self.layer.mask = maskLayer;
}

@end
