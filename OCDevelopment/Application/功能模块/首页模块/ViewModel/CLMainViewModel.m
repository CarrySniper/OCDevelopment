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
	[self.dataArray removeAllObjects];
	
	self.page = 1;
	self.haveMore = YES;
	for (long i = 0; i < self.pageSize; i++) {
		@autoreleasepool {
			CLBaseModel *model = [CLBaseModel new];
			model.objectId = [NSString stringWithFormat:@"name = %ld", i];
			[self.dataArray addObject:model];
		}
	}
	if (completionHandler) {
		completionHandler();
	}
}

/// 加载更多数据
/// @param completionHandler 完成回调
- (void)loadingMoreDataWithCompletionHandler:(CLVoidHandler)completionHandler {
	self.page++;
	for (long i = (self.page-1)*self.pageSize; i < self.page*self.pageSize; i++) {
		@autoreleasepool {
			CLBaseModel *model = [CLBaseModel new];
			model.objectId = [NSString stringWithFormat:@"name = %ld", i];
			[self.dataArray addObject:model];
		}
	}
	if (completionHandler) {
		completionHandler();
	}
}

@end
