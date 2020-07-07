//
//  CLPickerScrollView.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/6/15.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLPickerScrollView.h"
#import "CLPickerTableView.h"

#define kBaseTag  		100
#define kBaseWidth  	[UIScreen mainScreen].bounds.size.width

@interface CLPickerScrollView ()<UIScrollViewDelegate, CLPickerTableViewProtocol>

/// 第一级列表
@property (nonatomic, strong) CLPickerTableView *tableView;

/// 当前页（数据使用）
@property (nonatomic, assign) NSUInteger currentIndex;

/// 当前页（滚动使用）
@property (nonatomic, assign) NSUInteger currentPage;

/// 总数据
@property (nonatomic, strong) NSArray *dataArray;

/// 选中数据
@property (nonatomic, strong) NSMutableArray *selectArray;

@end

@implementation CLPickerScrollView

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.delegate = self;
		self.pagingEnabled = YES;
		self.scrollEnabled = NO;
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
		self.currentIndex = 0;
		
		UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
		/// 轻扫方向:左往右
		swipe.direction = UISwipeGestureRecognizerDirectionRight;
		[self addGestureRecognizer:swipe];
	}
	return self;
}

#pragma mark - 设置数据
- (void)setCurrentModels:(NSArray<CLPickerModel *> * _Nullable)currentModels dataSource:(NSArray<CLPickerModel *> *)dataSource {
	_selectArray = currentModels.mutableCopy;
	_dataArray = dataSource;
	self.currentIndex = 0;
	[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	/// 当前没有默认数据
	if (_dataArray.count && currentModels.count == 0) {
		CLPickerTableView *tableView = [self createTableView];
		[tableView setCurrentModel:nil dataSource:_dataArray];
	} else {
		CLPickerModel *tempModel;
		for (CLPickerModel *model in currentModels) {
			CLPickerTableView *tableView = [self createTableView];
			if (self.currentIndex == 0) {
				[tableView setCurrentModel:model dataSource:_dataArray];
			} else {
				[tableView setCurrentModel:model dataSource:tempModel.nextData];
			}
			if (model.nextData > 0) {
				tempModel = model;// 等下次取值
				self.currentIndex ++;
			}
		}
		[self setContentOffset:CGPointMake(self.currentIndex * kBaseWidth, 0) animated:NO];
		/// 代理回调选中数据
		if (self.pickerProtocol && [self.pickerProtocol respondsToSelector:@selector(pickerScrollView:updateSelectArray:)]) {
			[self.pickerProtocol pickerScrollView:self updateSelectArray:self.selectArray];
		}
	}
	[self scrollViewDidScroll:self];
}

#pragma mark - 返回上一级列表
- (BOOL)scrollLastPage {
	
	/// 删除选中列表最后一项（先删数据再--）
	[self.selectArray removeLastObject];
	
	/// 代理回调选中数据
	if (self.pickerProtocol && [self.pickerProtocol respondsToSelector:@selector(pickerScrollView:updateSelectArray:)]) {
		[self.pickerProtocol pickerScrollView:self updateSelectArray:self.selectArray];
	}
	
	if (self.currentIndex == 0) {
		return NO;
	}
	
	/// 移除视图
	CLPickerTableView *tableView = [self viewWithTag:kBaseTag + self.currentIndex];
	self.currentIndex --;
	[self setContentOffset:CGPointMake(self.currentIndex * kBaseWidth, 0) animated:YES];
	[tableView removeFromSuperview];
	
	return YES;
}

#pragma mark - 滚动到下一级列表
- (void)scrollNextPage:(NSArray *)nextData {
	self.currentIndex ++;
	CLPickerTableView *tableView = [self createTableView];
	[tableView setCurrentModel:nil dataSource:nextData];
	[self setContentOffset:CGPointMake(self.currentIndex * kBaseWidth, 0) animated:YES];
}

#pragma mark -
/// 地址选中
/// @param tableView 列表
/// @param selectModel 选中对象
- (void)pickerTableView:(CLPickerTableView *)tableView didSelectModel:(CLPickerModel *)selectModel {
	if (!selectModel) {
		return;
	}
	
	/// 添加到选中列表（先++再加数据）
	if (self.selectArray.count == self.currentIndex + 1) {
		[self.selectArray replaceObjectAtIndex:self.currentIndex withObject:selectModel];
	} else {
		[self.selectArray addObject:selectModel];
	}
	/// 代理回调选中数据
	if (self.pickerProtocol && [self.pickerProtocol respondsToSelector:@selector(pickerScrollView:updateSelectArray:)]) {
		[self.pickerProtocol pickerScrollView:self updateSelectArray:self.selectArray];
	}
	
	/// nextData 下一级数据，有则要显示下一级
	if (selectModel.nextData.count > 0) {
		[self scrollNextPage:selectModel.nextData];
	}
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if ([scrollView isEqual:self]) {
		self.currentPage = fabs(scrollView.contentOffset.x + kBaseWidth / 2) / kBaseWidth;
		/// 代理回调
		if (self.pickerProtocol && [self.pickerProtocol respondsToSelector:@selector(pickerScrollView:currentPage:)]) {
			[self.pickerProtocol pickerScrollView:self currentPage:self.currentPage];
		}
	}
}

#pragma mark - UISwipeGestureRecognizer
- (void)swipe:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
		if (self.currentPage > 0) {
			/// 返回上一层
			[self scrollLastPage];
		}
    }
}

#pragma mark - 选中项
- (NSMutableArray *)selectArray {
	if (!_selectArray) {
		_selectArray = [NSMutableArray array];
	}
	return _selectArray;
}

#pragma mark - 生成列表
- (CLPickerTableView *)createTableView {
	CLPickerTableView *tableView = [[CLPickerTableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
	tableView.tag = self.currentIndex + kBaseTag;
	tableView.textColor = self.textColor;
	tableView.textSelectColor = self.textSelectColor;
	tableView.pickerProtocol = self;
	[self addSubview:tableView];
	[tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_offset(self.currentIndex * kBaseWidth);
		make.top.equalTo(self);
		make.height.mas_equalTo(36*10);
		make.width.mas_equalTo(kBaseWidth);
	}];

	self.contentSize = CGSizeMake((self.currentIndex+1) * kBaseWidth, 0);
	return tableView;
}

@end
