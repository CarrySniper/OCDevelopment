//
//  CLWaterfallViewModel.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/27.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLWaterfallViewModel.h"

@implementation CLWaterfallViewModel

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
		self.dataArray = [[self getData] mutableCopy];
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
		NSArray *array = [self getData];
		[self.dataArray addObjectsFromArray:array];
		if (completionHandler) {
			completionHandler();
		}
		self.isLoading = NO;
	});
}

- (NSArray *)getData {
    NSArray *imageArray = @[
                            @"http://g.hiphotos.baidu.com/image/w%3D310/sign=6f9ce22079ec54e741ec1c1f89399bfd/9d82d158ccbf6c81cea943f6be3eb13533fa4015.jpg",
                            @"http://b.hiphotos.baidu.com/image/pic/item/4bed2e738bd4b31cc6476eb985d6277f9e2ff8bd.jpg",
                            @"http://c.hiphotos.baidu.com/image/pic/item/94cad1c8a786c9174d18e030cb3d70cf3bc7579b.jpg",
                            @"http://e.hiphotos.baidu.com/image/w%3D310/sign=79bc1b1a950a304e5222a6fbe1c9a7c3/d1160924ab18972b50a46fd4e4cd7b899e510a15.jpg",
                            @"http://c.hiphotos.baidu.com/image/w%3D310/sign=05e2c867272dd42a5f0907aa333a5b2f/7dd98d1001e93901f3f7103079ec54e737d196c3.jpg",
                            @"http://e.hiphotos.baidu.com/image/w%3D310/sign=3914596cf1deb48ffb69a7dfc01e3aef/d0c8a786c9177f3ea3e73f0072cf3bc79e3d56e8.jpg",
                            @"http://c.hiphotos.baidu.com/image/w%3D310/sign=8cc67b8cc91349547e1eee65664e92dd/4610b912c8fcc3ce11e40a3e9045d688d43f2093.jpg",
                            @"http://c.hiphotos.baidu.com/image/w%3D310/sign=93e1c429952bd40742c7d5fc4b889e9c/3812b31bb051f8191cdd594bd8b44aed2e73e733.jpg",
                            @"http://b.hiphotos.baidu.com/image/pic/item/4bed2e738bd4b31cc6476eb985d6277f9e2ff8bd.jpg",
                            @"http://c.hiphotos.baidu.com/image/pic/item/94cad1c8a786c9174d18e030cb3d70cf3bc7579b.jpg",
                            @"http://e.hiphotos.baidu.com/image/w%3D310/sign=3914596cf1deb48ffb69a7dfc01e3aef/d0c8a786c9177f3ea3e73f0072cf3bc79e3d56e8.jpg",
                            @"http://c.hiphotos.baidu.com/image/w%3D310/sign=93e1c429952bd40742c7d5fc4b889e9c/3812b31bb051f8191cdd594bd8b44aed2e73e733.jpg",
                            @"http://e.hiphotos.baidu.com/image/w%3D310/sign=d4507def9d3df8dca63d8990fd1072bf/d833c895d143ad4b758c35d880025aafa40f0603.jpg",
                            @"http://c.hiphotos.baidu.com/image/w%3D310/sign=702acce2552c11dfded1b92253266255/d62a6059252dd42a3ac70aaa013b5bb5c8eab8e0.jpg",
                            @"http://h.hiphotos.baidu.com/image/w%3D310/sign=75ff59cd19d5ad6eaaf962ebb1ca39a3/b64543a98226cffcb9f3ddbbbb014a90f703eada.jpg",
                            @"http://e.hiphotos.baidu.com/image/w%3D310/sign=11386163f1deb48ffb69a7dfc01e3aef/d0c8a786c9177f3e8bcb070f72cf3bc79f3d5631.jpg",
                            @"http://f.hiphotos.baidu.com/image/w%3D310/sign=8ed508bbd358ccbf1bbcb33b29d8bcd4/8694a4c27d1ed21b33ff8fecaf6eddc451da3f80.jpg",
                            @"http://b.hiphotos.baidu.com/image/w%3D310/sign=ad40ca82c9ef76093c0b9f9e1edca301/5d6034a85edf8db16aa7b27b0b23dd54564e7420.jpg",
                            @"http://e.hiphotos.baidu.com/image/w%3D310/sign=79bc1b1a950a304e5222a6fbe1c9a7c3/d1160924ab18972b50a46fd4e4cd7b899e510a15.jpg",
                            @"http://c.hiphotos.baidu.com/image/w%3D310/sign=05e2c867272dd42a5f0907aa333a5b2f/7dd98d1001e93901f3f7103079ec54e737d196c3.jpg",
                            @"http://g.hiphotos.baidu.com/image/w%3D310/sign=6f9ce22079ec54e741ec1c1f89399bfd/9d82d158ccbf6c81cea943f6be3eb13533fa4015.jpg",
                            @"http://e.hiphotos.baidu.com/image/w%3D310/sign=79bc1b1a950a304e5222a6fbe1c9a7c3/d1160924ab18972b50a46fd4e4cd7b899e510a15.jpg"
                            ];
	
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *urlString in imageArray) {
        CLWaterfallModel *model = [CLWaterfallModel new];
        model.imageUrl = urlString;
        model.title = [urlString lastPathComponent];
        [array addObject:model];
    }
	return array;
}

@end
