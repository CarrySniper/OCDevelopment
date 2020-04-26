//
//  CLVideoTableView.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/21.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLVideoTableView.h"
#import "CLVideoTableViewCell.h"

@implementation CLVideoTableView

@synthesize viewModel = _viewModel;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CLVideoViewModel *)viewModel {
	if (!_viewModel) {
		_viewModel = [[CLVideoViewModel alloc]init];
		_viewModel.interfaceView = self;
	}
	return (id)_viewModel;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self setup];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
	self = [super initWithFrame:frame style:style];
	if (self) {
		[self setup];
	}
	return self;
}

- (void)setup {
	self.delegate = self;
	self.dataSource = self;
	
	self.rowHeight = SCREEN_WIDTH*0.56;
	
	self.estimatedSectionHeaderHeight = 60;
	self.sectionHeaderHeight = UITableViewAutomaticDimension;
	
	self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	
	[CLVideoTableViewCell registerXibForTableView:self];
	
	// 数据加载
	self.emptyText = TEXT_LOADING;
	self.emptyDataForSections = YES;
}

- (void)loadData {
	WEAKSELF
	[self.viewModel loadingDataWithCompletionHandler:^{
		//		if (self.viewModel.userId) {
		//			self.emptyText = @"还没有发布过内容哦～";
		//		} else {
		//			self.emptyText = TEXT_NO_DATA;
		//		}
		
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	CLVideoTableViewCell *cell = [CLVideoTableViewCell dequeueXibReusable:tableView indexPath:indexPath];
//	NSLog(@"cell 地址：%p", &cell);
	return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(CLVideoTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	CLBaseModel *model = self.viewModel.dataArray[indexPath.row];
	[cell setDataWithModel:model];
}

#pragma mark 按需加载 - 如果目标行与当前行相差超过指定行数，提前加载。
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
	[super scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}

@end
