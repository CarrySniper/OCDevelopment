//
//  CLWaterfallModel.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/27.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLWaterfallModel : CLBaseModel

/// 标题
@property (nonatomic, copy) NSString *title;

/// 图片链接
@property (nonatomic, copy) NSString *imageUrl;

/// 图片尺寸大小
@property (nonatomic, assign) CGSize imageSize;

@end

NS_ASSUME_NONNULL_END
