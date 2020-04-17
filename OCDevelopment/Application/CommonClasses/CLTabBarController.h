//
//  CLTabBarController.h
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CLTabBarItem;

@interface CLTabBarController : UITabBarController

/// 自定义init
/// @param items 选项对象CLTabBarItem
- (instancetype)initWithTabBarItems:(NSArray<CLTabBarItem *> *)items;

/// 配置选项数据，如果不用initWithTabBarItems，可以修改里面的数据实现
- (void)setupViewControllersData;

@end

#pragma mark - Item
@interface CLTabBarItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *normalImageName;
@property (nonatomic, copy) NSString *selectedImageName;

@end

/// 内联函数
/// @param title 标题
/// @param className 控制器类名
/// @param normalImageName 正常状态图片名
/// @param selectedImageName 选中q状态图片名
NS_INLINE CLTabBarItem *CLTabBarItemMaker(NSString *title, NSString *className, NSString *normalImageName, NSString *selectedImageName) {
    CLTabBarItem *item = [CLTabBarItem new];
    item.title = title;
    item.className = className;
    item.normalImageName = normalImageName;
    item.selectedImageName = selectedImageName;
    return item;
}

NS_ASSUME_NONNULL_END
