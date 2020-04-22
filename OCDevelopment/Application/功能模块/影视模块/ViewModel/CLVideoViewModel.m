//
//  CLVideoViewModel.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/21.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLVideoViewModel.h"

@implementation CLVideoViewModel

#pragma mark - Method
/// 加载/刷新数据
/// @param completionHandler 完成回调
- (void)loadingDataWithCompletionHandler:(CLVoidHandler)completionHandler {
	
	// 正在加载中，不需要重复加载
	if (self.isLoading == YES) {
		return;
	}
	
	// 获取本地数据库数据显示
	[self getSqliteModelsWithPrimaryKey:@"objectId" completionHandler:^(NSArray<CLBaseModel *> * _Nullable dataArray) {
		self.dataArray = [dataArray mutableCopy];
		if (completionHandler) {
			completionHandler();
		}
	}];
	
	/// 加载数据完成回调，在请求前调用
	[self loadingCompletionHandler:completionHandler];
	
	self.page = 1;
	self.haveMore = YES;
	self.isLoading = YES;
	
	NSDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setValue:[NSNumber numberWithInteger:self.page] forKey:@"pageNo"];
	[parameters setValue:[NSNumber numberWithInteger:self.pageSize] forKey:@"pageSize"];
	[parameters setValue:@2 forKey:@"type"];
	
	[self.networkHandle requestMethod:AF_GET urlString:REQUEST_API(kUrlVideoLists) parameters:parameters success:^(id  _Nonnull responseObject) {
		NSArray *array = [NSArray yy_modelArrayWithClass:[CLVideoModel class] json:responseObject];
		// 删除数据库原数据，更新数据
		[self deleteSqliteWithCompletionHandler:^(BOOL successful) {
			if (successful) {
				[self updateSqliteModels:array primaryKey:@"objectId" completionHandler:^(BOOL successful) {
					NSLog(@"数据保存成功");
				}];
			}
		}];
		
		self.dataArray = [array mutableCopy];
	} failure:^(NSError * _Nonnull error) {
	}];
}

/// 加载更多数据
/// @param completionHandler 完成回调
- (void)loadingMoreDataWithCompletionHandler:(CLVoidHandler)completionHandler {
	
	// 正在加载中，不需要重复加载
	if (self.isLoading == YES) {
		return;
	}
	
	// 没有更多，不用继续下去
	if (self.haveMore == NO) {
		if (completionHandler) {
			completionHandler();
		}
		self.isLoading = NO;
		return;
	}
	
	/// 加载数据完成回调，在请求前调用
	[self loadingCompletionHandler:completionHandler];
	
	self.page++;
	self.isLoading = YES;
	
	NSDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setValue:[NSNumber numberWithInteger:self.page] forKey:@"pageNo"];
	[parameters setValue:[NSNumber numberWithInteger:self.pageSize] forKey:@"pageSize"];
	[parameters setValue:@2 forKey:@"type"];
	
	[self.networkHandle requestMethod:AF_GET urlString:REQUEST_API(kUrlVideoLists) parameters:parameters success:^(id  _Nonnull responseObject) {
		NSArray *array = [NSArray yy_modelArrayWithClass:[CLVideoModel class] json:responseObject];
		[self updateSqliteModels:array primaryKey:@"objectId" completionHandler:^(BOOL successful) {
			NSLog(@"数据保存成功");
		}];
		if (array.count == 0) {
			self.haveMore = NO;
		} else {
			[self.dataArray addObjectsFromArray:array];
		}
	} failure:^(NSError * _Nonnull error) {
		self.page--;
	}];
}


@end
