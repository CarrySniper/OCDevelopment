//
//  CLMainTableView.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/18.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLMainTableView.h"
#import "MainTableViewCell.h"

@implementation CLMainTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CLMainViewModel *)viewModel {
	if (!_viewModel) {
		_viewModel = [[CLMainViewModel alloc]init];
	}
	return _viewModel;
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
	
	self.rowHeight = 100;
	
	self.estimatedSectionHeaderHeight = 60;
	self.sectionHeaderHeight = UITableViewAutomaticDimension;
	
	self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	
	[MainTableViewCell registerXibForTableView:self];
	
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//	CLBaseTableViewCell *cell = [CLBaseTableViewCell dequeueReusable:tableView];
//	CLBaseTableViewCell *cell = [CLBaseTableViewCell defualtTableViewCell:tableView];
	MainTableViewCell *cell = [MainTableViewCell dequeueXibReusable:tableView indexPath:indexPath];
//	NSLog(@"cell 地址：%p", &cell);
	return cell;
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	MainTableViewCell *aCell = (MainTableViewCell *)cell;
	CLBaseModel *model = self.viewModel.dataArray[indexPath.row];
	[aCell setDataWithModel:model];
	
}
//按需加载 - 如果目标行与当前行相差超过指定行数，只在目标滚动范围的前后指定3行加载。
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
	NSLog(@"targetContentOffset-Y:%f",targetContentOffset->y);
	//取出滚动停止时展示的第一个cell的indexPath
    NSIndexPath *ip = [self indexPathForRowAtPoint:CGPointMake(0, targetContentOffset->y)];
	//取出当前展示的最后一个cell的indexPath
    NSIndexPath *cip = [[self indexPathsForVisibleRows] lastObject];
    NSInteger skipCount = 5;
	//如果两者之间差距很大则认为滑动速度很快，中间用户都不关心，直接把滚动停止时的展示的cell加入到needLoadArr数组中
    if (labs(cip.row-ip.row) > skipCount) {
		NSLog(@"需要加载更多");
		if (velocity.y<0) {
			
		} else {
			
		}
//        NSArray *temp = [self indexPathsForRowsInRect:CGRectMake(0, targetContentOffset->y, self.width, self.height)];
//        NSMutableArray *arr = [NSMutableArray arrayWithArray:temp];
////根据滚动方向在前或后额外添加三个需要展示的cell，这样看起来好像更加平滑的样子
//        if (velocity.y<0) {
//            NSIndexPath *indexPath = [temp lastObject];
//            if (indexPath.row+3<datas.count) {
//                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]];
//                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+2 inSection:0]];
//                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+3 inSection:0]];
//            }
//        } else {
//            NSIndexPath *indexPath = [temp firstObject];
//            if (indexPath.row>3) {
//                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-3 inSection:0]];
//                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-2 inSection:0]];
//                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:0]];
//            }
//        }
//        [needLoadArr addObjectsFromArray:arr];
    }
}

@end
