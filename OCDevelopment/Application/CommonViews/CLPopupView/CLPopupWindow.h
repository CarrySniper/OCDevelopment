//
//  CLPopupWindow.h
//  OCDevelopment
//
//  Created by CarrySniper on 2019/4/18.
//  Copyright © 2019 CarrySniper. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLPopupWindow : UIWindow

/// 透明遮挡层
@property (nonatomic, strong) UIView *attachedView;

/// 单例实例化
+ (instancetype)sharedInstance;

/// 更新视图，返回是否隐藏状态改变
- (void)updateTheViewHidden;

///获取弹出视图个数
- (NSUInteger)getPopupViewCount;

@end

NS_ASSUME_NONNULL_END
