//
//  CLFileManager.m
//  MVVMdemo
//
//  Created by CL on 2018/11/19.
//  Copyright © 2018 CL. All rights reserved.
//

#import "CLFileManager.h"

@implementation CLFileManager

+ (instancetype)manager {
	return [[self alloc] init];
}

- (instancetype)init
{
	static CLFileManager *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [super init];
		
		instance.fileManager = [NSFileManager defaultManager];
	});
	return instance;
}

#pragma mark - 获取本地文件内容
+ (NSString *)readLocalFileWithName:(NSString *)name ofType:(NSString *)type  {
	// 获取文件路径
	NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
	// 将文件数据化
	NSData *data = [[NSData alloc] initWithContentsOfFile:path];
	
	return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - 获取缓存文件的大小
- (NSString *)readCacheSize {
	// 获取Caches目录路径
	NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
	long long folderSize = [self folderSizeAtPath:cachePath];
	if (folderSize == 0) {
		return @"0MB";
	}
	return [NSByteCountFormatter stringFromByteCount:folderSize countStyle:NSByteCountFormatterCountStyleMemory];
}

#pragma mark - 遍历文件夹获得文件夹大小
- (float)folderSizeAtPath:(NSString *)folderPath {
	if (![self.fileManager fileExistsAtPath:folderPath])
		return 0;
	
	long long folderSize = 0 ;
	if ([self.fileManager fileExistsAtPath:folderPath]) {
		// 目录下的文件计算大小
		NSArray *childrenFile = [self.fileManager subpathsAtPath:folderPath];
		for (NSString *fileName in childrenFile) {
			NSString *absolutePath = [folderPath stringByAppendingPathComponent:fileName];
			folderSize += [self.fileManager attributesOfItemAtPath:absolutePath error:nil].fileSize;
		}
	}
	return folderSize;
}

#pragma mark - 计算单个文件的大小
- (long long)fileSizeAtPath:(NSString *)filePath {
	if ([self.fileManager fileExistsAtPath :filePath]){
		return [[self.fileManager attributesOfItemAtPath :filePath error : nil] fileSize];
	}
	return 0;
}

#pragma mark - 清除缓存
- (void)clearCache {
	// 获取Caches目录路径
	NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
	NSArray *childrenFile = [self.fileManager subpathsAtPath:cachePath];
	for (NSString *fileName in childrenFile) {
		NSError * error = nil ;
		//获取文件全路径
		NSString *fileAbsolutePath = [cachePath stringByAppendingPathComponent:fileName];
		if ([self.fileManager fileExistsAtPath:fileAbsolutePath]) {
			[self.fileManager removeItemAtPath:fileAbsolutePath error :&error];
		}
	}
	// 获取Temp目录路径
	NSString *tempPath = NSTemporaryDirectory();
	NSArray *childrenFiles = [self.fileManager subpathsAtPath:tempPath];
	for (NSString *fileName in childrenFiles) {
		NSError * error = nil ;
		//获取文件全路径
		NSString *fileAbsolutePath = [tempPath stringByAppendingPathComponent:fileName];
		if ([self.fileManager fileExistsAtPath:fileAbsolutePath]) {
			[self.fileManager removeItemAtPath:fileAbsolutePath error :&error];
		}
	}
}

@end
