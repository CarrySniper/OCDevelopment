//
//  GKPhotoBrowser+CLCategory.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/9/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <GKPhotoBrowser/GKPhotoBrowser.h>

NS_ASSUME_NONNULL_BEGIN
/*
 使用方法：
 
 NSMutableArray *images = [NSMutableArray array];
 [self.viewModel.dataArray enumerateObjectsUsingBlock:^(CLWaterfallModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
     GKPhoto *photo = [GKPhoto new];
     photo.url = [NSURL URLWithString:obj.imageUrl];
     [images addObject:photo];
 }];
 GKPhotoBrowser *browser = [GKPhotoBrowser cl_browserWithPhotos:images currentIndex:indexPath.item];
 [browser cl_show];
 */


@interface GKPhotoBrowser (CLCategory)<GKPhotoBrowserDelegate>

/// 新的实例化方法
/// @param photos 照片数组
/// @param currentIndex 当前索引
+ (instancetype)cl_browserWithPhotos:(NSArray<GKPhoto *> *)photos currentIndex:(NSInteger)currentIndex;

/// 显示，带保存按钮
- (void)cl_show;

@end

NS_ASSUME_NONNULL_END
