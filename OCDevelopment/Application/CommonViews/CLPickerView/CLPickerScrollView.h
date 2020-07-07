//
//  CLPickerScrollView.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/6/15.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLPickerModel.h"

NS_ASSUME_NONNULL_BEGIN

@class CLPickerScrollView;

#pragma mark - Protocol
@protocol CLPickerScrollViewProtocol <NSObject>

/// 更新选中项
/// @param scrollView 列表
/// @param selectArray 选中对象
- (void)pickerScrollView:(CLPickerScrollView *)scrollView updateSelectArray:(NSArray *)selectArray;

/// 当前第几页代理
/// @param scrollView 列表
/// @param currentPage 当前第几页
- (void)pickerScrollView:(CLPickerScrollView *)scrollView currentPage:(NSUInteger)currentPage;

@end

#pragma mark - Class
@interface CLPickerScrollView : UIScrollView

/// 文本颜色
@property (nonatomic, strong) UIColor *textColor;

/// 文本选中颜色
@property (nonatomic, strong) UIColor *textSelectColor;

/// 代理协议
@property (nonatomic, weak) id <CLPickerScrollViewProtocol> pickerProtocol;

/// 设置数据源
/// @param currentModels 当前选择项
/// @param dataSource 总数据
- (void)setCurrentModels:(NSArray<CLPickerModel *> * _Nullable)currentModels dataSource:(NSArray<CLPickerModel *> *)dataSource;

/// 返回上一级列表
/// @return 是否能返回，不能返回则是第一级。
- (BOOL)scrollLastPage;

@end

NS_ASSUME_NONNULL_END
