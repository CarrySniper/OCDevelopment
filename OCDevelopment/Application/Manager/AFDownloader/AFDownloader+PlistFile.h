//
//  AFDownloader+PlistFile.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/28.
//  Copyright © 2020 CarrySniper. All rights reserved.
//


#import "AFDownloader.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFDownloader (PlistFile)

/// 获取一条记录
/// @param urlString 下载链接
- (NSDictionary *)getPlistDataWithUrlString:(NSString *)urlString;

/// 获取所有记录
- (NSArray *)getAllPlistData;

/// 添加文件数据
/// @param urlString 下载链接
/// @param directoryPath 下载路径
/// @param downloadLength 已下载大小
/// @param totalLength 总文件大小
- (void)addPlistWithUrlString:(NSString *)urlString
				directoryPath:(NSString *)directoryPath
			   downloadLength:(NSUInteger)downloadLength
				  totalLength:(NSUInteger)totalLength;

/// 更新文件记录
/// @param urlString 下载链接
/// @param addDownloadLength 添加下载大小
- (void)updatePlistWithUrlString:(NSString *)urlString
			   addDownloadLength:(NSUInteger)addDownloadLength;

/// 文件是否已下载完成，已完成则返回文件大小
/// @param urlString 下载链接
- (NSUInteger)isDownloadCompleted:(NSString *)urlString;

/// 获取文件总大小
/// @param urlString 下载链接
- (NSUInteger)totalLengthPlistWithUrlString:(NSString *)urlString;

/// 获取文件已下载大小
/// @param urlString 下载链接
- (NSUInteger)downloadLengthPlistWithUrlString:(NSString *)urlString;

/// 删除一个数据
/// @param urlString 下载链接
- (void)deletePlistWithUrlString:(NSString *)urlString;

/// 删除所有数据
- (void)deleteAllPlistData;

@end

NS_ASSUME_NONNULL_END
