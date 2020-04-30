//
//  CLWaterfallViewModel.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/27.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLBaseViewModel.h"
#import "CLWaterfallModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLWaterfallViewModel : CLBaseViewModel

/// MARK: - 方法

/// 加载/刷新数据
/// @param completionHandler 完成回调
- (void)loadingDataWithCompletionHandler:(CLVoidHandler)completionHandler;

/// 加载更多数据
/// @param completionHandler 完成回调
- (void)loadingMoreDataWithCompletionHandler:(CLVoidHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
