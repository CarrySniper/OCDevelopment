//
//  GKPhotoBrowser+CLCategory.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/9/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "GKPhotoBrowser+CLCategory.h"

@implementation GKPhotoBrowser (CLCategory)

#pragma mark - 新的实例化方法
+ (instancetype)cl_browserWithPhotos:(NSArray<GKPhoto *> *)photos currentIndex:(NSInteger)currentIndex {
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:currentIndex];
    browser.showStyle = GKPhotoBrowserShowStyleNone;
    browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
    return browser;
}

#pragma mark -
- (void)cl_show {
    [self showFromVC:CurrentViewController()];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"保存" forState:(UIControlStateNormal)];
    button.layer.cornerRadius = 6;
    button.layer.masksToBounds = YES;
    button.backgroundColor = UIColor.redColor;
    [button addTarget:self action:@selector(saveAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.top.equalTo(self.contentView).offset(STATUS_HEIGHT);
            make.right.equalTo(self.contentView.mas_safeAreaLayoutGuideRight).offset(-16);
        } else {
            make.top.equalTo(self.contentView).offset(STATUS_HEIGHT);
            make.right.equalTo(self.contentView).offset(-16);
        }
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(32);
    }];
}

#pragma mark -
- (void)saveAction:(UIButton *)sender {
    UIImage *saveImage = self.curPhotoView.imageView.image;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        ///写入图片到相册PHAssetChangeRequest *req =
        [PHAssetChangeRequest creationRequestForAssetFromImage:saveImage];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            CLToastShow(@"保存成功");
        }
        NSLog(@"success = %d, error = %@", success, error);
    }];
}

@end
