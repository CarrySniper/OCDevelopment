//
//  UIScrollView+CLEmpty.m
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "UIScrollView+CLEmpty.h"

#import <objc/runtime.h>
#import <Aspects/Aspects.h>

static char emptyDataSourceKey;
static char emptyViewKey;
static char emptyDataForSectionsKey;

@interface UIScrollView ()
@property (nonatomic, readonly) UIView *emptyView;
@end

@implementation UIScrollView (CLEmpty)

#pragma mark - Setting && Getting
- (void)setEmptyDataSource:(id<CLEmptyDataSource>)emptyDataSource {
	if (emptyDataSource) {
		objc_setAssociatedObject(self, &emptyDataSourceKey, emptyDataSource, OBJC_ASSOCIATION_ASSIGN);
		//黑科技 面向切面编程 AOP
		[self aspect_hookSelector:@selector(reloadData)
					  withOptions:AspectPositionAfter
					   usingBlock:^(id<AspectInfo> aspectInfo) {
						   [self makeEmptyView];
					   } error:NULL];
	} else {
		objc_setAssociatedObject(self, &emptyDataSourceKey, nil, OBJC_ASSOCIATION_ASSIGN);
	}
}

- (id<CLEmptyDataSource>)emptyDataSource {
	return objc_getAssociatedObject(self, &emptyDataSourceKey);
}

- (void)setEmptyDataForSections:(BOOL)emptyDataForSections {
	objc_setAssociatedObject(self, &emptyDataForSectionsKey, @(emptyDataForSections), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)emptyDataForSections {
	return [objc_getAssociatedObject(self, &emptyDataForSectionsKey) boolValue];
}

- (void)setEmptyView:(UIView *)emptyView {
	// runtime
	objc_setAssociatedObject(self, &emptyViewKey, emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)emptyView {
	return objc_getAssociatedObject(self, &emptyViewKey);
}

#pragma mark - 显示管理
- (void)makeEmptyView {
	self.emptyView.hidden = YES;
	for (UIView *view in [self.emptyView subviews]) {
		[view removeFromSuperview];
	}
	if ([self dataAvailable] == NO &&
		self.emptyDataSource &&
		[self.emptyDataSource respondsToSelector:@selector(emptyViewDataSource:)]
		) {
		UIView *view = [self.emptyDataSource emptyViewDataSource:self];
		if (view) NSAssert([view isKindOfClass:[UIView class]], @"You must return a valid UIView object for -emptyViewDataSource:");
		
		self.emptyView = view;
		[self addSubview:view];//memory error
		
		// 设置位置偏移
		CGPoint offset = [self emptyViewOffset];
		CGRect frame = view.frame;
		
		// 禁止将 AutoresizingMask 转换为 Constraints
		view.translatesAutoresizingMaskIntoConstraints = NO;
		
		// 添加 centerX 约束
		NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:offset.x];
		
		// 添加 centerY 约束
		NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:offset.y];
		
		// 添加 width 约束
		NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:frame.size.width];
		
		// 添加 height 约束
		NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:frame.size.height];
		
		//把约束添加到父视图上
		NSArray *array = @[widthConstraint, heightConstraint, centerXConstraint, centerYConstraint];
		[self addConstraints:array];
		
		NSLog(@"没有数据，显示空数据UI");
	}else{
	}
}

#pragma mark 空数据UI偏移设置回调
- (CGPoint)emptyViewOffset {
	CGPoint offset = CGPointMake(0, 0);
	if (self.emptyDataSource && [self.emptyDataSource respondsToSelector:@selector(emptyViewOffset:)]) {
		offset = [self.emptyDataSource emptyViewOffset:self];
	}
	return offset;
}

- (BOOL)dataAvailable {
	// UIScollView doesn't respond to 'dataSource' so let's exit
	if (![self respondsToSelector:@selector(dataSource)]) {
		return NO;
	}
	// UITableView support
	if ([self isKindOfClass:[UITableView class]]) {
		UITableView *tableView = (UITableView *)self;
		id <UITableViewDataSource> dataSource = tableView.dataSource;
		NSInteger sections = tableView.numberOfSections;
		if (self.emptyDataForSections == YES) {
			return sections > 0 ? YES : NO;
		} else {
			if (dataSource && [dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
				NSInteger rows = 0;
				for (NSInteger section = 0; section < sections; section++) {
					rows += [dataSource tableView:tableView numberOfRowsInSection:section];
				}
				return rows > 0 ? YES : NO;
			}
		}
		
	}
	// UICollectionView support
	else if ([self isKindOfClass:[UICollectionView class]]) {
		UICollectionView *collectionView = (UICollectionView *)self;
		id <UICollectionViewDataSource> dataSource = collectionView.dataSource;
		NSInteger sections = collectionView.numberOfSections;
		if (self.emptyDataForSections == YES) {
			return sections > 0 ? YES : NO;
		} else {
			if (dataSource && [dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
				NSInteger items = 0;
				for (NSInteger section = 0; section < sections; section++) {
					items += [dataSource collectionView:collectionView numberOfItemsInSection:section];
				}
				return items > 0 ? YES : NO;
			}
		}
	}
	return YES;
}

@end
