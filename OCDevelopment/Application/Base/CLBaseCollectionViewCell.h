//
//  CLBaseCollectionViewCell.h
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLBaseCollectionViewCell : UICollectionViewCell

/// MARK: - 设置数据

/// 设置模型数据对象
/// @param model 模型
- (void)setDataWithModel:(CLBaseModel *)model;

/// MARK: - 纯代码

/// 纯代码注册Cell
/// @param collectionView collectionView
+ (void)registerForCollectionView:(UICollectionView *)collectionView;

/// MARK: - Xib

/// Xib注册Cel
/// @param collectionView collectionView
+ (void)registerXibForCollectionView:(UICollectionView *)collectionView;

/// MARK: - 获取Cell

/// 纯代码获取Cell方法纯代码／Xib 获取cell
/// @param collectionView collectionView
/// @param indexPath 索引
+ (instancetype)dequeueReusable:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
