//
//  CLTableView.h
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLTipsView.h"
#import "CLBaseTableViewCell.h"
#import "UIScrollView+CLEmpty.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^ViewVoidHandler)(void);

@interface CLTableView : UITableView<CLEmptyDataSource, UITableViewDelegate>

/** 占位数据的遮挡层 */
@property (nonatomic, assign) CGPoint emptyCenterOffset;
@property (nonatomic, strong) NSString *emptyText;
@property (nonatomic, strong) UIImage *emptyImage;
@property (nonatomic, strong) NSString *emptyButtonText;
@property (nonatomic, strong) UIImage *emptyButtonBackgroundImage;
@property (nonatomic, copy) ViewVoidHandler emptyActionBlock;

/// 数据加载
- (void)loadData;
- (void)loadMoreData;

@end

NS_ASSUME_NONNULL_END
