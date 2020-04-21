//
//  CLBaseViewModel.h
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLBaseModel.h"
#import "AFNetworkHandle.h"

NS_ASSUME_NONNULL_BEGIN

// MARK: - 模版别名
typedef void (^CLModelHandler)(BOOL succeeded, CLBaseModel *_Nullable model);

#pragma mark - Class
@interface CLBaseViewModel : NSObject

/// 分页数据
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) BOOL haveMore;

/// 是否正在加载中
@property (nonatomic, assign) BOOL isLoading;

/// 加载的数据
@property (nonatomic, strong) NSMutableArray *dataArray;

/// 网络请求处理
@property (nonatomic, strong) AFNetworkHandle *networkHandle;

/// 当前交互试图
@property (nonatomic, weak) UIView *interfaceView;


/// MARK: - 方法

/// 加载/刷新数据
/// @param completionHandler 完成回调
- (void)loadingDataWithCompletionHandler:(CLVoidHandler)completionHandler;

/// 加载更多数据
/// @param completionHandler 完成回调
- (void)loadingMoreDataWithCompletionHandler:(CLVoidHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
