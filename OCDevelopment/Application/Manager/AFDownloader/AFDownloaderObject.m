//
//  AFDownloaderObject.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/28.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "AFDownloaderObject.h"
#import "AFDownloader.h"

@implementation AFDownloaderObject

- (instancetype)initWithUrlString:(NSString *)urlString beginLocation:(NSUInteger)beginLocation directoryPath:(NSString *)directoryPath {
    self = [super init];
    if (self) {
        if (!urlString) {
            return self;
        }
        self.urlString = urlString;
        self.speed = @"0bytes";
        self.directoryPath = directoryPath;
        
        // Range
        // bytes=x-y ==  x byte ~ y byte
        // bytes=x-  ==  x byte ~ end
        // bytes=-y  ==  head ~ y byte
		NSString *filePath = [[AFDownloader sharedInstance] fileAbsolutePath:urlString];
		if (directoryPath && directoryPath.length > 0) {// 替换存放地址
			BOOL isDirectory = NO;
			BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDirectory];
			if (!isExists || !isDirectory) {
				NSLog(@"director路径不存在，不加入下载队列。请检测!");
				return nil;
			}else{
				filePath = [directoryPath stringByAppendingPathComponent:[filePath lastPathComponent]];
			}
		}
        self.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:YES];
		
		NSURL *URL = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [request setValue:[NSString stringWithFormat:@"bytes=%ld-", (long)beginLocation] forHTTPHeaderField:@"Range"];
        // 下载任务，不在此回调，交给AFDownloader sessionManager处理
        self.dataTask = [[AFDownloader sharedInstance].sessionManager dataTaskWithRequest:request
                                                                    uploadProgress:nil
                                                                  downloadProgress:nil
                                                                 completionHandler:nil];
    }
    return self;
}

#pragma mark - 保存文件
- (void)openOutputStream {
    
    if (!_outputStream) {
        return;
    }
    [_outputStream open];
}

- (void)closeOutputStream {
    
    if (!_outputStream) {
        return;
    }
    if (_outputStream.streamStatus > NSStreamStatusNotOpen &&
        _outputStream.streamStatus < NSStreamStatusClosed) {
        [_outputStream close];
    }
    _outputStream = nil;
}

@end
