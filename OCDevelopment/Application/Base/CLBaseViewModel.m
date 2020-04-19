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

@end
