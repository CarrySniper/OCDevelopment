//
//  AFDownloader+DataListener.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/28.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "AFDownloader.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFDownloader (DataListener)

#pragma mark - 数据监听处理
- (void)setSessionManagerListener;

@end

NS_ASSUME_NONNULL_END
