//
//  AFDownloader.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/28.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "AFDownloaderObject.h"

#define CLCachesDirectory       [[AFDownloader sharedInstance] cachesDirectory]  // 缓存路径
#define CLFileName(URL)         [URL lastPathComponent] // 根据URL获取文件名，xxx.zip
#define CLFilePath(URL)         [CLCachesDirectory stringByAppendingPathComponent:CLFileName(URL)]
#define CLFilesPlistPath        [CLCachesDirectory stringByAppendingPathComponent:@"CLFilesSize.plist"]

NS_ASSUME_NONNULL_BEGIN
#pragma mark - 模版别名
/// 下载完成（成功／失败）
typedef void (^CLDownloaderHandler)(AFDownloaderObject *object);

#pragma mark - Class
@interface AFDownloader : NSObject

/// 最大并发数，0为不限制，默认3
@property (nonatomic, assign) NSInteger maxConcurrentCount;

/// 会话对象
@property (nonatomic, strong) AFURLSessionManager *sessionManager;

/// 文件管理
@property (nonatomic, strong) NSFileManager *fileManager;

/// 文件缓存目录
@property (nonatomic, strong, readonly) NSString *cachesDirectory;

/// 下载中的队列
@property (nonatomic, strong) NSMutableArray<AFDownloaderObject *> *downloadingArray;

/// // 待下载的队列
@property (nonatomic, strong) NSMutableArray<AFDownloaderObject *> *waitingArray;

/// 全部下载集合（下载中/待下载/暂停/已下载……）
@property (nonatomic, strong) NSMutableDictionary<NSString *, AFDownloaderObject *> *downloadsSet;

#pragma mark - method

/// 单例
+ (instancetype)sharedInstance;

/// 获取某条下载数据
/// @param urlString 下载链接
- (NSDictionary *)downloadObjectWithUrlString:(NSString *)urlString;

/// 获取下载列表数据
- (NSArray *)downloadList;

/// 下载文件
/// @param urlString 下载链接
/// @param directory 文件下载完成后保存的目录，如果为nil，默认保存到“.../Library/Caches/AFDownloader”
/// @param state 下载状态回调
/// @param progress 下载进度回调
/// @param completion 下载完成回调
- (void)downloadURL:(NSString *)urlString
		  directory:(NSString *)directory
			  state:(CLDownloadStateHandler)state
		   progress:(CLDownloadProgressHandler) progress
		 completion:(CLDownloadCompletionHandler)completion;


#pragma mark - Downloads

/// 下载下一个文件
- (void)toDowloadNextObject;

/// 挂起指定下载任务
/// @param urlString 下载链接
- (void)suspendDownload:(NSString *)urlString;

/// 挂起全部下载任务
- (void)suspendAllDownloads;

/// 恢复指定下载任务
/// @param urlString 下载链接
- (void)resumeDownload:(NSString *)urlString;

/// 恢复全部下载任务
- (void)resumeAllDownloads;

/// 删除指定下载任务
/// @param urlString 下载链接
- (void)deleteDownload:(NSString *)urlString;

/// 删除全部下载任务
- (void)deleteAllDownloads;

#pragma mark - Files

/// 获取文件绝对路径
/// @param urlString 下载链接
- (NSString *)fileAbsolutePath:(NSString *)urlString;

/// 格式化文件大小
/// @param size 大小
- (NSString *)formatByteCount:(long long)size;

@end

NS_ASSUME_NONNULL_END
