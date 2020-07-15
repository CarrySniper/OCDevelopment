//
//  CLThemeModel.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/6/18.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLThemeModel : NSObject

/// 导航栏背景
@property (nonatomic, copy) UIImage *navigationImage;

/// 导航栏着色
@property (nonatomic, copy) UIColor *navigationTintColor;

/// 选项栏背景
@property (nonatomic, copy) UIImage *tabbarImage;

/// 选项栏图标内边距
@property (nonatomic, assign) UIEdgeInsets tabbarInsets;

/// 选项栏Item正常状态图标数组
@property (nonatomic, strong) NSArray<UIImage *> *normalImages;

/// 选项栏Item选择状态图标数组
@property (nonatomic, strong) NSArray<UIImage *> *selectedImages;

@end

NS_ASSUME_NONNULL_END
