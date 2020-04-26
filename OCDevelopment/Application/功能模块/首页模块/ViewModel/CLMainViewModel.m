//
//  CLMainViewModel.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/18.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLMainViewModel.h"

@implementation CLMainViewModel

#pragma mark - Method
/// 加载/刷新数据
/// @param completionHandler 完成回调
- (void)loadingDataWithCompletionHandler:(CLVoidHandler)completionHandler {
	
	// 正在加载中，不需要重复加载
	if (self.isLoading == YES) {
		return;
	}
//	NSMutableArray *array = [NSMutableArray array];
//	CLBaseModel *model = [[CLBaseModel alloc]init];
//	model.objectId = @"a111";
//	[array addObject:model];
//
//	CLBaseModel *model1 = [CLBaseModel new];
//	model1.objectId = [NSString stringWithFormat:@"name = 99"];
//	[array addObject:model1];
//
//	[self updateSqliteModels:array primaryKey:@"objectId" needRefresh:YES completionHandler:^(BOOL successful) {
//		NSLog(@"数据保存成功");
//	}];
	
	// 获取本地数据库数据显示
	[self getSqliteModelsWithPrimaryKey:@"objectId" completionHandler:^(NSArray<CLBaseModel *> * _Nullable dataArray) {
		self.dataArray = [dataArray mutableCopy];
		if (completionHandler) {
			completionHandler();
		}
	}];
	
	self.isLoading = YES;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		self.page = 1;
		self.haveMore = YES;
		
		NSMutableArray *array = [NSMutableArray array];
		for (long i = 0; i < self.pageSize; i++) {
			@autoreleasepool {
				CLBaseModel *model = [CLBaseModel new];
				model.objectId = [NSString stringWithFormat:@"name = %ld", i];
				[array addObject:model];
			}
		}
		self.dataArray = array;
		// 更新数据
		[self updateSqliteModels:self.dataArray primaryKey:@"objectId" needRefresh:YES completionHandler:^(BOOL successful) {
			NSLog(@"数据保存成功");
		}];
		if (completionHandler) {
			completionHandler();
		}
		self.isLoading = NO;
	});
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
	self.isLoading = YES;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		self.page++;
		NSMutableArray *array = [NSMutableArray array];
		for (long i = (self.page-1)*self.pageSize; i < self.page*self.pageSize; i++) {
			@autoreleasepool {
				CLBaseModel *model = [CLBaseModel new];
				model.objectId = [NSString stringWithFormat:@"name = %ld", i];
				[array addObject:model];
			}
		}
		[self.dataArray addObjectsFromArray:array];
		[self updateSqliteModels:array primaryKey:@"objectId" needRefresh:NO completionHandler:^(BOOL successful) {
			NSLog(@"数据保存成功");
		}];
		if (completionHandler) {
			completionHandler();
		}
		self.isLoading = NO;
	});
}

- (void)aaaa {
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
