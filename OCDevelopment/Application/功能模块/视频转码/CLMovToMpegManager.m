//
//  CLMovToMpegManager.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/10/6.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLMovToMpegManager.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>

@implementation CLMovToMpegManager

#pragma mark 缓存文件夹路径
+ (NSString *)cachesPath {
    /// 在Library/Caches目录下创建一个名为VideoData的文件夹
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"VideoData"];
}

#pragma mark 分辨率清晰度
+ (NSString *const)getAVAssetExportPresetQuality:(CLExportQuality)exportQuality {
    switch (exportQuality) {
        case CLExportLowQuality:
            return AVAssetExportPresetLowQuality;
        case CLExportMediumQuality:
            return AVAssetExportPresetMediumQuality;
        case CLExportHighestQuality:
            return AVAssetExportPresetHighestQuality;
        case CLExportQuality640x480:
            return AVAssetExportPreset640x480;
        case CLExportQuality960x540:
            return AVAssetExportPreset960x540;
        case CLExportQuality1280x720:
            return AVAssetExportPreset1280x720;
        case CLExportQuality1920x1080:
            return AVAssetExportPreset1920x1080;
        case CLExportQuality3840x2160:
            return AVAssetExportPreset3840x2160;
    }
}

#pragma mark 返回文件大小
+ (float)fileSizeWithData:(NSData *)data {
    return [data length]/(1024.0*1024.0);//单位MB，苹果其实不是以1024算，是以1000算的;
}


#pragma mark 获取资源视频信息
+ (void)convertMovToMp4FromPHAsset:(PHAsset *)resourceAsset exportQuality:(CLExportQuality)exportQuality completionHandler:(CLMovToMpegManagerHandler)completionHandler {
    /// 资源数据
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed = true;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    [manager requestAVAssetForVideo:resourceAsset
                            options:options
                      resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        if ([asset isKindOfClass:[AVURLAsset class]]) {
            
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            
            /// 视频后缀MOV、mp4
            NSArray *resources = [PHAssetResource assetResourcesForAsset:resourceAsset];
            NSString *originalFilename = ((PHAssetResource *)resources.firstObject).originalFilename;
            NSString *suffix = [originalFilename pathExtension];
            if ([[suffix lowercaseString] containsString:@"mp4"]) {
                /// 已经是mp4，不用再处理
                NSData *mp4Data = [NSData dataWithContentsOfURL:urlAsset.URL];
                float fileSize = [self fileSizeWithData:mp4Data];
                completionHandler(urlAsset.URL, urlAsset.URL, mp4Data, resourceAsset.duration, fileSize, nil);
                return;
            } else if ([[suffix uppercaseString] containsString:@"MOV"]) {
                /// 开始MOV转码MP4
                [self convertMovToMp4FromAVURLAsset:urlAsset exportQuality:exportQuality completionHandler:completionHandler];
                return;
            }
        }
        NSError *error = [NSError errorWithDomain:@"ConvertMovToMp4ErrorDomain"
                                             code:10008
                                         userInfo:@{NSLocalizedDescriptionKey:@"资源文件格式不符合"}];
        completionHandler(nil, nil, nil, 0.0, 0.0, error);
    }];
}

#pragma mark - 开始MOV转码MP4
+ (void)convertMovToMp4FromAVURLAsset:(AVURLAsset *)urlAsset
                        exportQuality:(CLExportQuality)exportQuality
                    completionHandler:(CLMovToMpegManagerHandler)completionHandler {
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:urlAsset];
    
    /// 查询是否有匹配的预设
    NSString *assetExportPreset = [self getAVAssetExportPresetQuality:exportQuality];
    if ([compatiblePresets containsObject:assetExportPreset]) {
        /// 在Library/Caches目录下创建一个名为VideoData的文件夹
        NSString *path = [self cachesPath];
        /// 文件名
        NSString *fileName = [[[urlAsset.URL absoluteString] lastPathComponent] stringByDeletingPathExtension];
        /// 文件存储路径
        NSString *resultPath = [path stringByAppendingFormat:@"/%@%@.mp4",fileName, [assetExportPreset stringByReplacingOccurrencesOfString:@"AVAssetExportPreset" withString:@"-"]];
        NSLog(@"resultFileName = %@",fileName);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDirectory = YES;
        BOOL isDirectoryExist = [fileManager fileExistsAtPath:path isDirectory:&isDirectory];
        if (isDirectory && isDirectoryExist == NO) {
            /// 是文件夹，又不存在该文件夹，需要创建该路径所有文件夹
            BOOL createResult = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            if(!createResult){
                NSLog(@"创建文件夹失败！%@", path);
            } else {
                NSLog(@"创建文件夹成功！");
            }
        } else {
            /// 已存在文件夹，如果已有同名文件，要先删除
            if ([fileManager fileExistsAtPath:resultPath]) {
                BOOL deleteResult = [fileManager removeItemAtPath:resultPath error:nil];
                if(!deleteResult){
                    NSLog(@"删除文件失败！%@", resultPath);
                } else {
                    NSLog(@"删除文件成功！");
                }
            }
        }
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:urlAsset presetName:assetExportPreset];
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
            NSLog(@"%@", exportSession.error);
            if (exportSession.status == AVAssetExportSessionStatusCompleted && exportSession.error == nil) {
                NSData *mp4Data = [NSData dataWithContentsOfURL:exportSession.outputURL];
                float fileSize = [self fileSizeWithData:mp4Data];
                CMTime time = [urlAsset duration];//roundf
                completionHandler(urlAsset.URL, exportSession.outputURL, mp4Data, roundf(time.value*1.0/time.timescale), fileSize, nil);
            } else {
                completionHandler(nil, nil, nil, 0.0, 0.0, exportSession.error);
            }
        }];
    } else{
        NSError *error = [NSError errorWithDomain:@"ConvertMovToMp4ErrorDomain"
                                             code:10007
                                         userInfo:@{NSLocalizedDescriptionKey:@"没有合适的分辨率进行转换"}];
        completionHandler(nil, nil, nil, 0.0, 0.0, error);
    }
}

@end
