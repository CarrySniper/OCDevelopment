//
//  CLCollectionView.m
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLCollectionView.h"

@implementation CLCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - 实例化
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
	self = [super initWithFrame:CGRectZero collectionViewLayout:layout];
	if (self) {
		[self base_setup];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self base_setup];
	}
	return self;
}

#pragma mark - 配置，避免子类也有setup方法，造成基类方法不调用
- (void)base_setup {
	/// 空数据源代理
	self.emptyDataSource = self;
	
	/// 代理
	self.delegate = self;
	
	/// 背景颜色
	self.backgroundColor = COLOR_VIEW;
	
	/// iOS11，内边距调整
	if (@available(iOS 11.0, *)) {
		self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	} else {
	}
	
	/// 加载数据
	self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		[self loadData];
	}];
	self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		[self loadMoreData];
	}];
}

#pragma mark - 数据加载
#pragma mark 刷新加载
- (void)loadData {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	[self.mj_header endRefreshing];
}

#pragma mark 加载更多
- (void)loadMoreData {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	[self.mj_footer endRefreshing];
}

#pragma mark - 按需加载，如果目标行与当前行相差超过指定行数，提前加载。
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
	// 有更多数据的时候进行
	if (self.viewModel.haveMore == NO) {
		return;
	}
	
	// 要求是上拉加载的velocity.y >= 0，有时候为0就不区分了
	if (velocity.y >= 0) {
		// 当前一页展示cell个数
		NSUInteger visibleCount = [[self indexPathsForVisibleItems] count];
		// 已加载数据个数
		NSUInteger totalCount = self.viewModel.dataArray.count;
		// 预计滚动停止时第一个cell的indexPath，滚动停止
		NSIndexPath *endIndexPath = [self indexPathForItemAtPoint:CGPointMake(0, targetContentOffset->y)];
		/*
		// 取出当前展示的第一个cell的indexPath，手刚离开，还在惯性滚动中
		NSIndexPath *firstIndexPath = [[self indexPathsForVisibleRows] firstObject];
		// 取出当前展示的最后一个cell的indexPath，手刚离开，还在惯性滚动中
		NSIndexPath *lastIndexPath = [[self indexPathsForVisibleRows] lastObject];
		// 将要展示到第几条数据
		NSUInteger willShowCount = endIndexPath.row + visibleCount;
		 */
		// 剩余多少条数据未展示
		NSUInteger invisibleCount = totalCount - (endIndexPath.row + visibleCount);
		// 设置需要加载数，剩余量少于或等于该值，则需要加载更多数据
		// 看个人体验效果设置，我这里就按一页展示cell个数的1.5倍，并且最小值为6个来提前加载
		NSUInteger needLoadCount = MAX(visibleCount*1.5, 6);
		if (invisibleCount <= needLoadCount) {
			[self loadMoreData];
			NSLog(@"需要加载更多");
		}
	}
}

#pragma mark - CLEmptyDataSource

/// 空数据时UI设置回调
/// @param scrollView 对象
- (UIView *)emptyViewDataSource:(UIScrollView *)scrollView {
	CLTipsView *view = [[CLTipsView alloc]init];
	view.tipsLabel.text = self.emptyText ? self.emptyText : TEXT_NO_DATA;
	view.imageView.image  = self.emptyImage ? self.emptyImage : IMAGE_NO_DATA;
	/// 按钮
	if (self.emptyButtonText || self.emptyButtonBackgroundImage) {
		view.button.hidden = NO;
		view.button.enabled = YES;
		
		[view.button setTitle:self.emptyButtonText ? self.emptyButtonText : @"" forState:UIControlStateNormal];
		[view.button setBackgroundImage:self.emptyButtonBackgroundImage ? self.emptyButtonBackgroundImage : [UIImage new] forState:UIControlStateNormal];
		view.actionHandler = ^() {
			if (self.emptyActionBlock) {
				self.emptyActionBlock();
			}
		};
	}else{
		view.button.hidden = YES;
		view.button.enabled = NO;
	}
	
	return view;
}

/// 空数据UI偏移设置回调
/// @param scrollView 对象
- (CGPoint)emptyViewOffset:(UIScrollView *)scrollView {
	return self.emptyCenterOffset;
}

@end
