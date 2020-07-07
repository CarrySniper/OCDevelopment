//
//  CLPickerToolView.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/6/13.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CLPickerToolView;

@protocol CLPickerToolViewProtocol <NSObject>

/// 确认事件
/// @param toolView 列表
- (void)pickerToolViewWithConfirmAction:(CLPickerToolView *)toolView;

/// 返回事件
/// @param toolView 列表
- (void)pickerToolViewWithBackAction:(CLPickerToolView *)toolView;

@end

@interface CLPickerToolView : UIView

/// 代理协议
@property (nonatomic, weak) id <CLPickerToolViewProtocol> pickerProtocol;

/// 标题
@property (nonatomic, copy) NSString *title;

/// 类型
@property (nonatomic, copy) NSString *typeName;

/// 内容
@property (nonatomic, copy) NSString *address;

/// 返回按钮图标（图文只能存在一个）
@property (nonatomic, strong) UIImage *backImage;

/// 返回按钮文本（图文只能存在一个）
@property (nonatomic, copy) NSString *backText;

/// 标题颜色
@property (nonatomic, strong) UIColor *titleColor;

/// 文字颜色
@property (nonatomic, strong) UIColor *textColor;

/// 确认按钮颜色
@property (nonatomic, strong) UIColor *confirmTextColor;


@end

NS_ASSUME_NONNULL_END
