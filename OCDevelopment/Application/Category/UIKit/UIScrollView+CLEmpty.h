//
//  UIScrollView+CLEmpty.h
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CLEmptyDataSource;


@interface UIScrollView (CLEmpty)

@property (nonatomic, assign) id<CLEmptyDataSource> _Nullable emptyDataSource;
@property (nonatomic, assign) BOOL emptyDataForSections;

@end

#pragma mark - EmptyDataSource
@protocol  CLEmptyDataSource<NSObject>
@optional

/**
 空数据时UI设置回调
 
 @param scrollView 对象
 @return 需要展示的UI
 */
- (UIView *)emptyViewDataSource:(UIScrollView *)scrollView;

/**
 空数据UI偏移设置回调
 
 @param scrollView 对象
 @return 偏移量
 */
- (CGPoint)emptyViewOffset:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
