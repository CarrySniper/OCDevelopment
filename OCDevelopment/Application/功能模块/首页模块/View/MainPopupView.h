//
//  MainPopupView.h
//  OCDevelopment
//
//  Created by CarrySniper on 2020/5/21.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLPopupView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainPopupView : CLPopupView

/// <#Description#>
@property (nonatomic, copy) void(^completionHandler)(void);

+ (instancetype)showViewWithCompletionHandler:(void(^)(void))completionHandler;

@end

NS_ASSUME_NONNULL_END
