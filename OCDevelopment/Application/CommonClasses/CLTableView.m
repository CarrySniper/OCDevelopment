//
//  CLTableView.m
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLTableView.h"

@implementation CLTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - 实例化
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
	self = [super initWithFrame:frame style:style];
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

/**
 配置，避免子类也有setup方法，造成基类方法不调用
 */
- (void)base_setup {
	self.delegate = self;
	self.emptyDataSource = self;
	self.backgroundColor = COLOR_VIEW;
	
	// 自适应高度
	self.estimatedRowHeight = 80;
	self.rowHeight = UITableViewAutomaticDimension;
	
	// 代码创建才有效果
	self.separatorColor = COLOR_LINE;
	
	// 分割线，单横线
	self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	
	// 分隔边缘
	self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
	
	self.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
	self.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
	
	// iOS11，内边距调整
	if (@available(iOS 11.0, *)) {
		self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	} else {
	}
	
	// 加载数据
	self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		[self loadData];
	}];
	self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		[self loadMoreData];
	}];
}

- (void)loadData {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	[self.mj_header endRefreshing];
}

- (void)loadMoreData {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	[self.mj_footer endRefreshing];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	//	[[LRInputManager manager] cancelInput];
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//	cell.transform = CGAffineTransformMakeScale(0.8, 1);
//	[UIView animateWithDuration:0.5 animations:^{
//		cell.transform = CGAffineTransformIdentity;
//	}];
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
//	view.transform = CGAffineTransformMakeScale(0.8, 1);
//	[UIView animateWithDuration:0.5 animations:^{
//		view.transform = CGAffineTransformIdentity;
//	}];
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
//	view.transform = CGAffineTransformMakeScale(0.8, 1);
//	[UIView animateWithDuration:0.5 animations:^{
//		view.transform = CGAffineTransformIdentity;
//	}];
//}

/**
 空数据时UI设置回调
 
 @param scrollView 对象
 @return 需要展示的UI
 */
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

/**
 空数据UI偏移设置回调
 
 @param scrollView 对象
 @return 偏移量
 */
- (CGPoint)emptyViewOffset:(UIScrollView *)scrollView {
	return self.emptyCenterOffset;
}

@end
