//
//  CLVideoTranscodeViewController.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/10/6.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLVideoTranscodeViewController.h"
#import <AVKit/AVKit.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import "CLMovToMpegManager.h"

@interface CLVideoTranscodeViewController ()

/// 原始视频
@property (nonatomic, strong) NSURL *originalURL;

/// 转码后的mp4视频
@property (nonatomic, strong) NSURL *mp4URL;

/// <#Description#>
@property (nonatomic, strong) UIButton *originalButton;

/// Description
@property (nonatomic, strong) UIButton *mp4Button;


@end

@implementation CLVideoTranscodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"视频转码";
    
    UIButton *selectButton = ({
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTitle:@"选择本地视频" forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(selectVideoAction) forControlEvents:(UIControlEventTouchUpInside)];
        button;
    });
    [self.view addSubview:selectButton];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(32);
        make.right.equalTo(self.view).offset(-32);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(100);
    }];
    
    self.originalButton = ({
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        button.enabled = NO;
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTitle:@"播放原始视频" forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(playOriginalVideo) forControlEvents:(UIControlEventTouchUpInside)];
        button;
    });
    [self.view addSubview:self.originalButton];
    [self.originalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(32);
        make.right.equalTo(self.view).offset(-32);
        make.height.mas_equalTo(44);
        make.top.equalTo(selectButton.mas_bottom).offset(20);
    }];
    
    self.mp4Button = ({
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        button.enabled = NO;
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTitle:@"播放转码后的mp4视频" forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(playMpegVideo) forControlEvents:(UIControlEventTouchUpInside)];
        button;
    });
    [self.view addSubview:self.mp4Button];
    [self.mp4Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(32);
        make.right.equalTo(self.view).offset(-32);
        make.height.mas_equalTo(44);
        make.top.equalTo(self.originalButton.mas_bottom).offset(20);
    }];
}

- (void)playOriginalVideo {
    if (!self.originalURL) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        AVPlayerViewController *vc = [[AVPlayerViewController alloc] init];
        vc.player = [AVPlayer playerWithURL:self.originalURL];
        [CurrentViewController() presentViewController:vc animated:YES completion:nil];
    });
}

- (void)playMpegVideo {
    if (!self.mp4URL) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        AVPlayerViewController *vc = [[AVPlayerViewController alloc] init];
        vc.player = [AVPlayer playerWithURL:self.mp4URL];
        [CurrentViewController() presentViewController:vc animated:YES completion:nil];
    });
}

- (void)selectVideoAction {
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:nil];
    imagePicker.allowPickingVideo = YES;
    imagePicker.allowPickingImage = NO;
    // 设置 模态弹出模式。 iOS 13默认非全屏
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    /// 选择视频完成回调
    imagePicker.didFinishPickingVideoHandle = ^(UIImage *coverImage, PHAsset *asset) {
        [CLMovToMpegManager convertMovToMp4FromPHAsset:asset
                         exportQuality:CLExportQuality1280x720
                                      completionHandler:^(NSURL * _Nullable originalURL, NSURL * _Nullable mp4URL, NSData * _Nullable mp4Data, NSTimeInterval duration, float fileSize, NSError * _Nullable error) {
            
            NSLog(@"size is %f", fileSize); //size is 43.703005
            if (error) {
                [CLToastHUD showTipWithError:error];
            } else {
                self.originalURL = originalURL;
                self.mp4URL = mp4URL;
                [self playMpegVideo];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.originalButton.enabled = YES;
                    self.mp4Button.enabled = YES;
                });
            }
        }];
    };
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
