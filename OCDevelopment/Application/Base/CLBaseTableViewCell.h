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

/**
 设置数据对象
 
 @param model 模型
 */
- (void)setDataWithModel:(CLBaseModel * _Nullable)model;

/** 纯代码 注册 */
+ (void)registerForTableView:(UITableView *)tableView;

/** 纯代码 获取Cell(复用、可选复用) */
+ (instancetype)dequeueReusable:(UITableView *)tableView;
+ (instancetype)dequeueReusable:(UITableView *)tableView identifier:(NSString *)identifier;

/** Xib 注册 */
+ (void)registerXibForTableView:(UITableView *)tableView;

/** Xib 获取Cell */
+ (instancetype)dequeueXibReusable:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

// MARK: - 系统默认Cell
+ (instancetype)defualtTableViewCell:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
