//
//  CLBaseViewModel.m
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLBaseViewModel.h"

@implementation CLBaseViewModel

#pragma mark - Lazy
- (AFNetworkHandle *)networkHandle {
	if (!_networkHandle) {
		_networkHandle = [[AFNetworkHandle alloc]init];
		_networkHandle.containerView = self.interfaceView;
	}
	return _networkHandle;
}

- (NSMutableArray *)dataArray {
	if (!_dataArray) {
		_dataArray = [NSMutableArray array];
	}
	return _dataArray;
}

#pragma mark - Init
- (instancetype)init
{
	self = [super init];
	if (self) {
		self.page = 1;
		self.pageSize = 20;
		self.haveMore = NO;
		self.isLoading = NO;

		NSString *tableName = NSStringFromClass(self.class);
		[[CLFMDBManager sharedInstance] autoDeleteDataWithTable:tableName completionHandler:^(BOOL successful) {
			
		}];
	}
	return self;
}

#pragma mark - Method
/// 加载/刷新数据
/// @param completionHandler 完成回调
- (void)loadingDataWithCompletionHandler:(CLVoidHandler)completionHandler {
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

/// 加载更多数据
/// @param completionHandler 完成回调
- (void)loadingMoreDataWithCompletionHandler:(CLVoidHandler)completionHandler {
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

/// 加载数据完成回调，在请求前调用
/// @param completionHandler 完成回调
- (void)loadingCompletionHandler:(CLVoidHandler)completionHandler {
	__weak __typeof(self)weakSelf = self;
	self.networkHandle.completionHandler = ^{
		if (completionHandler) {
			completionHandler();
		}
		weakSelf.isLoading = NO;
	};
}

@end

@implementation CLBaseViewModel (CLFMDB)

#pragma mark 保存/更新数据
- (void)updateSqliteModels:(NSArray<CLBaseModel *> *)models primaryKey:(NSString * _Nonnull)primaryKey needRefresh:(BOOL)needRefresh completionHandler:(CLFMDBBoolHandler)completionHandler {
	// 没有数据，返回
	if (models.count == 0) {
		if (completionHandler) {
			completionHandler(YES);
		}
		return;
	}
	NSString *tableName = NSStringFromClass(self.class);
	NSMutableArray *dataArray = [NSMutableArray array];
	for (CLBaseModel *model in models) {
		@autoreleasepool {
			NSMutableDictionary *modelData = [NSMutableDictionary dictionary];
			[modelData setValue:model.objectId forKey:primaryKey];
			[modelData setValue:[model archiveModel] forKey:[CLFMDBManager sharedInstance].dataKey];// 归档
			[dataArray addObject:modelData];
		}
	}
	/// FMDB存储
	[[CLFMDBManager sharedInstance] updateDataWithTable:tableName primaryKey:primaryKey dataArray:dataArray needRefresh:needRefresh completionHandler:completionHandler];
}

#pragma mark 获取数据库所有数据
- (void)getSqliteModelsWithPrimaryKey:(NSString * _Nonnull)primaryKey completionHandler:(CLModelArrayHandler)completionHandler {
	NSString *tableName = NSStringFromClass(self.class);
	/// FMDB查询
	[[CLFMDBManager sharedInstance] selectDataWithTable:tableName completionHandler:^(NSArray<NSData *> * _Nullable dataArray) {
		NSMutableArray *array = [NSMutableArray array];
		for (NSData *data in dataArray) {
			CLBaseModel *model = [CLBaseModel unarchiverModelWithData:data];// 读档
			if (model) {
				[array addObject:model];
			} else {
				NSLog(@"读档失败");
			}
		}
		if (completionHandler) {
			completionHandler(array);
		}
	}];
}

#pragma mark 清除表数据
- (void)deleteSqliteWithCompletionHandler:(CLFMDBBoolHandler)completionHandler {
	NSString *tableName = NSStringFromClass(self.class);
	/// FMDB删除
	[[CLFMDBManager sharedInstance] deleteAllDataWithTable:tableName completionHandler:completionHandler];
}

@end
