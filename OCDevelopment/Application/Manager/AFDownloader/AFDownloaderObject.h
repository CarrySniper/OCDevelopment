//
//  AFDownloaderObject.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/28.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 枚举 下载状态
typedef NS_ENUM(NSInteger, CLDownloadState) {
	CLDownloadStateWaiting,     // 等待下载
	CLDownloadStateRunning,     // 下载中
	CLDownloadStateSuspended,   // 挂起，暂停下载
	CLDownloadStateCanceling,   // 取消，不再下载
	CLDownloadStateCompleted    // 下载完成（成功／失败）
};

#pragma mark - 模版别名

/// 下载状态回调
/// @param state 下载状态
typedef void (^CLDownloadStateHandler)(CLDownloadState state);

/// 下载进度Handler
/// @param receivedSize 已接收数据大小（已下载 1KB/1MB）
/// @param expectedSize 预计下载数据大小（总大小 1KB/1MB）
/// @param speed 速度（每秒下载大小 1KB/1MB。不带“/秒”单位，自己拼上去1MB/s 1MB/S）
/// @param progress 下载进度
typedef void (^CLDownloadProgressHandler)(NSString *receivedSize, NSString *expectedSize, NSString *speed, CGFloat progress);

/// 下载完成回调（成功／失败）
/// @param successful 是否下载成功
/// @param filePath 成功文件路径
/// @param error 失败原因
typedef void (^CLDownloadCompletionHandler)(BOOL successful, NSString * _Nullable filePath, NSError * _Nullable error);

#pragma mark - Class
@interface AFDownloaderObject : NSObject

/// 下载完成后保存的目录
@property (nonatomic, copy) NSString *directoryPath;

/// 下载链接
@property (nonatomic, copy) NSString *urlString;

/// 输出流
@property (nonatomic, strong) NSOutputStream *outputStream;

/// 会话数据任务
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

/// 下载速度（每秒下载大小 1KB/1MB。不带“/秒”单位，自己拼上去1MB/s 1MB/S）
@property (nonatomic, copy) NSString *speed;

/// 时间-辅助计算下载速度
@property (nonatomic, copy) NSDate *date;

/// 长度-辅助计算下载速度
@property (nonatomic, assign) NSInteger readLength;

/// 文件总长度
@property (nonatomic, assign) NSInteger totalLength;

/// 下载状态回调
@property (nonatomic, copy) CLDownloadStateHandler stateHandler;

/// 下载进度回调
@property (nonatomic, copy) CLDownloadProgressHandler progressHandler;

/// 下载完成回调
@property (nonatomic, copy) CLDownloadCompletionHandler completionHandler;


#pragma mark - 方法

/// 不允许使用
- (instancetype)init NS_UNAVAILABLE;

/// 实例化方法
/// @param urlString 下载链接
/// @param beginLocation 断点续传下载起始位置
/// @param directoryPath 下载文件目录位置
- (instancetype)initWithUrlString:(NSString *)urlString
					beginLocation:(NSUInteger)beginLocation
					directoryPath:(NSString *)directoryPath NS_DESIGNATED_INITIALIZER;

#pragma mark - 保存文件

/// 打开输出流
- (void)openOutputStream;

/// 关闭输出流
- (void)closeOutputStream;

@end

NS_ASSUME_NONNULL_END
