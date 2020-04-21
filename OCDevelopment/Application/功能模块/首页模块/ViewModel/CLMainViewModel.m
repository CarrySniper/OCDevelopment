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
	self.isLoading = YES;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		self.page = 1;
		self.haveMore = YES;
		[self.dataArray removeAllObjects];
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
		return;
	}
	self.isLoading = YES;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
		self.isLoading = NO;
	});
	
}

- (void)aaaa {
	NSLog(@"%@", NSStringFromSelector(_cmd));
}
@end
