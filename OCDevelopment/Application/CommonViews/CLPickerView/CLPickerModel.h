//
//  CLPickerModel.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/6/15.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark 数据通用模型
@interface CLPickerModel : NSObject

/// key - ID
@property (nonatomic, copy) NSString *key;

/// value - City
@property (nonatomic, copy) NSString *value;

/// 下一级数据
@property (nonatomic, strong) NSArray<CLPickerModel *> * _Nullable nextData;

@end

NS_ASSUME_NONNULL_END
