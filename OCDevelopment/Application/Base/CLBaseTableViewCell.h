//
//  CLBaseTableViewCell.h
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLBaseTableViewCell : UITableViewCell

/// MARK: - 设置数据

/// 设置模型数据对象
/// @param model 模型
- (void)setDataWithModel:(CLBaseModel * _Nullable)model;

/// MARK: - 纯代码

/// 纯代码 注册Cell
/// @param tableView tableView
+ (void)registerForTableView:(UITableView *)tableView;

/// 纯代码获取Cell方法
/// @param tableView tableView
+ (instancetype)dequeueReusable:(UITableView *)tableView;

/// 纯代码获取Cell方法，指定identifier，可不复用
/// @param tableView tableView
/// @param identifier 标识
+ (instancetype)dequeueReusable:(UITableView *)tableView identifier:(NSString *)identifier;

/// MARK: - Xib

/// Xib 注册Cell
/// @param tableView tableView
+ (void)registerXibForTableView:(UITableView *)tableView;

/** Xib 获取Cell */

/// Xib 获取Cell
/// @param tableView tableView
/// @param indexPath 索引
+ (instancetype)dequeueXibReusable:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

/// MARK: - 系统默认Cell


/// 获取系统默认Cell
/// @param tableView tableView
+ (instancetype)defualtTableViewCell:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
