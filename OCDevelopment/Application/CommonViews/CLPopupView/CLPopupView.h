//
//  CLPopupView.h
//  OCDevelopment
//
//  Created by CarrySniper on 2019/4/18.
//  Copyright © 2019 CarrySniper. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 弹出视图类型
typedef NS_ENUM(NSUInteger, CLPopupViewType) {
	CLPopupViewTypeCustom = 0,
	CLPopupViewTypeAlert,
	CLPopupViewTypeSheet,
};

@interface CLPopupView : UIView

/// 弹出类型，默认custom
@property (nonatomic, assign) CLPopupViewType type;

/// 当外部被触发时，是否隐藏 默认true
@property (nonatomic, assign) BOOL hideWhenTouchOutside;

/// 显示
- (void)show;

/// 隐藏
- (void)hide;

@end

NS_ASSUME_NONNULL_END
