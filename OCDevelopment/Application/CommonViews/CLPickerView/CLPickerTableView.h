//
//  CLPickerTableView.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/6/15.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLPickerModel.h"

NS_ASSUME_NONNULL_BEGIN

@class CLPickerTableView;

@protocol CLPickerTableViewProtocol <NSObject>

/// 选中
/// @param tableView 列表
/// @param selectModel 选中对象
- (void)pickerTableView:(CLPickerTableView *)tableView didSelectModel:(CLPickerModel *)selectModel;

@end

@interface CLPickerTableView : UITableView<UITableViewDelegate, UITableViewDataSource>

/// 代理协议
@property (nonatomic, weak) id <CLPickerTableViewProtocol> pickerProtocol;

/// 文本颜色
@property (nonatomic, strong) UIColor *textColor;

/// 文本选中颜色
@property (nonatomic, strong) UIColor *textSelectColor;

/// 设置数据
/// @param currentModel 当前模型x
/// @param dataSource 数据源
- (void)setCurrentModel:(CLPickerModel * _Nullable)currentModel dataSource:(NSArray<CLPickerModel *> *)dataSource;

@end



#pragma mark - Other
#pragma mark 头部视图
@interface CLPickerSectionHeaderView : UIView

/// 描述
@property (nonatomic, strong) UILabel *label;

@end

#pragma mark Cell视图
@interface CLPickerTableViewCell : UITableViewCell

/// 文本颜色
@property (nonatomic, strong) UIColor *textColor;

/// 文本选中颜色
@property (nonatomic, strong) UIColor *textSelectColor;

@end


NS_ASSUME_NONNULL_END
