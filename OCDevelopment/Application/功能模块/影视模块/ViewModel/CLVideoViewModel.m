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
	
	self.page = 1;
	self.haveMore = YES;
	NSDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setValue:[NSNumber numberWithInteger:self.page] forKey:@"pageNo"];
	[parameters setValue:[NSNumber numberWithInteger:self.pageSize] forKey:@"pageSize"];
	[parameters setValue:@2 forKey:@"type"];
	
	[self.networkHandle requestMethod:AF_GET urlString:REQUEST_API(kUrlVideoLists) parameters:parameters success:^(id  _Nonnull responseObject) {
		NSArray *array = [NSArray yy_modelArrayWithClass:[CLVideoModel class] json:responseObject];
		self.dataArray = [array mutableCopy];
		if (completionHandler) {
			completionHandler();
		}
	} failure:^(NSError * _Nonnull error) {
		if (completionHandler) {
			completionHandler();
		}
	}];
}

/// 加载更多数据
/// @param completionHandler 完成回调
- (void)loadingMoreDataWithCompletionHandler:(CLVoidHandler)completionHandler {
	// 没有更多，不用继续下去
	if (self.haveMore == NO) {
		if (completionHandler) {
			completionHandler();
		}
		return;
	}
	
	self.page++;
	NSDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setValue:[NSNumber numberWithInteger:self.page] forKey:@"pageNo"];
	[parameters setValue:[NSNumber numberWithInteger:self.pageSize] forKey:@"pageSize"];
	[parameters setValue:@2 forKey:@"type"];
	
	[self.networkHandle requestMethod:AF_GET urlString:REQUEST_API(kUrlVideoLists) parameters:parameters success:^(id  _Nonnull responseObject) {
		NSArray *array = [NSArray yy_modelArrayWithClass:[CLVideoModel class] json:responseObject];
		if (array.count == 0) {
			self.haveMore = NO;
		} else {
			[self.dataArray addObjectsFromArray:array];
		}
		if (completionHandler) {
			completionHandler();
		}
	} failure:^(NSError * _Nonnull error) {
		self.page--;
		if (completionHandler) {
			completionHandler();
		}
	}];
}
@end
