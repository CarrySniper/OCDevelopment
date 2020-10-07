//
//  CLMovToMpegManager.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/10/6.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class PHAsset;

typedef NS_ENUM(NSInteger, CLExportQuality) {
    CLExportLowQuality,         //低质量 可以通过移动网络分享
    CLExportMediumQuality,      //中等质量 可以通过WIFI网络分享
    CLExportHighestQuality,     //高等质量
    CLExportQuality640x480,
    CLExportQuality960x540,
    CLExportQuality1280x720,    //720p
    CLExportQuality1920x1080,   //1080p
    CLExportQuality3840x2160,
};

/// @param originalURL 源文件URL
/// @param mp4URL mp4的URL
/// @param mp4Data mp4视频流
/// @param duration 视频时长（秒）
/// @param fileSize 视频大小（MB）
/// @param error 转换错误
typedef void(^CLMovToMpegManagerHandler)(NSURL *_Nullable originalURL, NSURL *_Nullable mp4URL, NSData *_Nullable mp4Data, NSTimeInterval duration, float fileSize, NSError *_Nullable error);

@interface CLMovToMpegManager : NSObject

/// 缓存文件夹路径
+ (NSString *)cachesPath;

/// 转码 MOV--MP4
/// @param resourceAsset MOV资源
/// @param exportQuality 预设
/// @param completionHandler 回调
+ (void)convertMovToMp4FromPHAsset:(PHAsset *)resourceAsset
exportQuality:(CLExportQuality)exportQuality
completionHandler:(CLMovToMpegManagerHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
