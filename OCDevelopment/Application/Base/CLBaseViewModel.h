//
//  CLBaseViewModel.h
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLBaseModel.h"
#import "CLFMDBManager.h"
#import "AFNetworkHandle.h"
#import "CLVideoModel.h"
NS_ASSUME_NONNULL_BEGIN

// MARK: - 模版别名
typedef void (^CLModelHandler)(BOOL succeeded, CLBaseModel *_Nullable model);
typedef void (^CLModelArrayHandler)(NSArray<CLBaseModel *> *_Nullable dataArray);

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

/// 加载数据完成回调，在请求前调用
/// @param completionHandler 完成回调
- (void)loadingCompletionHandler:(CLVoidHandler)completionHandler;

@end

@interface CLBaseViewModel (CLFMDB)

/// 保存/更新数据
/// @param models 模型数组
/// @param primaryKey 主键
/// @param needRefresh 是否需要刷新时间
/// @param completionHandler 完成回调
- (void)updateSqliteModels:(NSArray<CLBaseModel *> *)models
				primaryKey:(NSString * _Nonnull)primaryKey
			   needRefresh:(BOOL)needRefresh
		 completionHandler:(CLFMDBBoolHandler)completionHandler;

/// 获取数据库所有数据
/// @param primaryKey 主键
/// @param completionHandler 完成回调
- (void)getSqliteModelsWithPrimaryKey:(NSString * _Nonnull)primaryKey
					completionHandler:(CLModelArrayHandler)completionHandler;

/// 清除表数据，看需求使用
/// @param completionHandler 完成回调
- (void)deleteSqliteWithCompletionHandler:(CLFMDBBoolHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
