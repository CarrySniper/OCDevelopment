//
//  CLFileManager.h
//  MVVMdemo
//
//  Created by CL on 2018/11/19.
//  Copyright © 2018 CL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLFileManager : NSObject

@property (nonatomic, strong) NSFileManager *fileManager;

+ (instancetype)sharedInstance;

#pragma mark - 获取本地文件内容
+ (NSString *)readLocalFileWithName:(NSString *)name ofType:(NSString *)type;

#pragma mark - 获取缓存文件的大小Byte
- (long long)readCacheSize;

#pragma mark - 计算单个文件的大小Byte
- (long long)fileSizeAtPath:(NSString *)filePath;

#pragma mark - 遍历文件夹获得文件夹大小Byte
- (long long)folderSizeAtPath:(NSString *)folderPath;

#pragma mark - 清除缓存
- (void)clearCache;

#pragma mark - 格式化内存大小 MB、GB
- (NSString *)formatterWithFileSize:(long long)byteCount;

@end

NS_ASSUME_NONNULL_END
