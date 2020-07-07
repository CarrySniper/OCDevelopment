//
//  CLPickerView.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/6/1.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLPopupView.h"
#import "CLPickerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLPickerView : CLPopupView

/// 标题
@property (nonatomic, copy) NSString *title;

/// 类型
@property (nonatomic, copy) NSString *typeName;

/// 返回按钮图标
@property (nonatomic, strong) UIImage *backImage;

/// 标题颜色
@property (nonatomic, strong) UIColor *titleColor;

/// 文字颜色
@property (nonatomic, strong) UIColor *textColor;

/// 文本选中颜色
@property (nonatomic, strong) UIColor *textSelectColor;

/// 确认按钮颜色
@property (nonatomic, strong) UIColor *confirmTextColor;

/// 设置数据
/// @param currentModels 当前选择模型数组
/// @param dataSource 数据源，没有设置，默认使用area.json数据
- (void)setCurrentModels:(NSArray<CLPickerModel *> * _Nullable)currentModels
			  dataSource:(NSArray<CLPickerModel *> * _Nullable)dataSource;

/// 显示视图
/// @param completionHandler 回调
- (void)showViewWithCompletionHandler:(void(^)(NSArray<CLPickerModel *> * _Nullable selectArray))completionHandler;

///  默认本地文件数据
+ (NSArray *)defaultData;

@end

NS_ASSUME_NONNULL_END
