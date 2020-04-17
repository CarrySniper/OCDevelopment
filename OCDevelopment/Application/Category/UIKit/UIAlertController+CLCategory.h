//
//  UIAlertController+CLCategory.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/6.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (CLCategory)

/// 显示警告框，只有一个“确定”按钮
/// @param title 标题
/// @param message 信息
/// @param actionHander 操作回调
+ (void)showAlertWithTitle:(NSString * _Nullable)title
				   message:(NSString * _Nullable)message
			  actionHander:(void (^_Nullable)(UIAlertAction *action))actionHander;

/// 显示警告框，默认一个“取消”按钮和自定义按钮
/// @param title 标题
/// @param message 信息
/// @param handerName 处理按钮名称
/// @param actionHander 处理回调
+ (void)showAlertWithTitle:(NSString * _Nullable)title
				   message:(NSString * _Nullable)message
				handerName:(NSString * _Nullable)handerName
			  actionHander:(void (^_Nullable)(UIAlertAction *action))actionHander;

/// 显示操作列表框，默认一个“取消”按钮和列表按钮
/// @param title 标题
/// @param message 信息
/// @param handerNameArray 处理按钮名称列表
/// @param actionHander 处理回调
+ (void)showActionSheetWithTitle:(NSString * _Nullable)title
						 message:(NSString * _Nullable)message
				 handerNameArray:(NSArray<NSString *> * _Nullable)handerNameArray
					actionHander:(void (^_Nullable)(UIAlertAction *action, NSUInteger selectedIndex))actionHander;

@end

NS_ASSUME_NONNULL_END
