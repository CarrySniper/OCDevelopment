//
//  CLWaterfallCollectionView.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/27.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLWaterfallCollectionView.h"
#import "CLWaterfallCollectionViewCell.h"

@implementation CLWaterfallCollectionView

@synthesize viewModel = _viewModel;

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (CLWaterfallViewModel *)viewModel {
	if (!_viewModel) {
		_viewModel = [[CLWaterfallViewModel alloc]init];
	}
	return (id)_viewModel;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
	self = [super initWithFrame:frame collectionViewLayout:layout];
	if (self) {
		[self setup];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self setup];
	}
	return self;
}

- (void)setup {
	self.delegate = self;
	self.dataSource = self;
	
	[CLWaterfallCollectionViewCell registerXibForCollectionView:self];
	
	// 数据加载
	self.emptyText = TEXT_LOADING;
	self.emptyDataForSections = YES;
}

- (void)loadData {
	WEAKSELF
	[self.viewModel loadingDataWithCompletionHandler:^{
		weakSelf.emptyText = TEXT_NO_DATA;
		if (weakSelf.viewModel.haveMore == NO) {
			[weakSelf.mj_footer endRefreshingWithNoMoreData];
		}else{
			[weakSelf.mj_footer resetNoMoreData];
		}
		[weakSelf.mj_header endRefreshing];
		[weakSelf reloadData];
	}];
}

- (void)loadMoreData {
	WEAKSELF
	[self.viewModel loadingMoreDataWithCompletionHandler:^{
		if (weakSelf.viewModel.haveMore == NO) {
			[weakSelf.mj_footer endRefreshingWithNoMoreData];
		}else{
			[weakSelf.mj_footer endRefreshing];
		}
		[weakSelf reloadData];
	}];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.viewModel.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	CLWaterfallCollectionViewCell *cell = [CLWaterfallCollectionViewCell dequeueReusable:collectionView indexPath:indexPath];
	CLWaterfallModel *model = self.viewModel.dataArray[indexPath.item];
	cell.titleLabel.text = model.title;
	[cell.cover cl_setImageUrlString:model.imageUrl placeholderImage:[UIImage imageNamed:@"202004"] cornerRadius:0 completionHandler:^(UIImage * _Nonnull image) {
		/// 避免循环调用，加上比较判断.这里有40高的Label
		if (!CGSizeEqualToSize(model.imageSize, CGSizeMake(image.size.width, image.size.height + 40))) {
			//model.imageSize = image.size;//只有图，不需要+40
			model.imageSize = CGSizeMake(image.size.width, image.size.height + 40);
			[collectionView reloadItemsAtIndexPaths:@[indexPath]];
		}
	}];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(CLWaterfallCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CLWaterfallModel *model = self.viewModel.dataArray[indexPath.item];
	if (!CGSizeEqualToSize(model.imageSize, CGSizeZero)) {
		return model.imageSize;
	}
	return CGSizeMake(150, 150);
}

#pragma mark 按需加载 - 如果目标行与当前行相差超过指定行数，提前加载。
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
	[super scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}

@end
