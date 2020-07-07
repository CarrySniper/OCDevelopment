//
//  CLPickerTableView.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/6/15.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLPickerTableView.h"

static NSString * const kCellIdentifier = @"CLPickerTableViewCell";

@interface CLPickerTableView ()

/// 数据
@property (nonatomic, strong) NSArray *dataArray;

/// 选中数据 默认-1不选中
@property (nonatomic, assign) NSInteger currentIndex;

/// 预防多点
@property (nonatomic, assign) BOOL selected;

@end

@implementation CLPickerTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
	self = [super initWithFrame:frame style:style];
	if (self) {
		self.currentIndex = -1;
		
		self.delegate = self;
		self.dataSource = self;
		
		self.rowHeight = 44;
		
		self.separatorColor = [UIColor groupTableViewBackgroundColor];
		self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
		
		[self registerClass:[CLPickerTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
		
		self.tableHeaderView = [[CLPickerSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
		self.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.001)];
		/// iOS11，内边距调整，恢复Automatic
		if (@available(iOS 11.0, *)) {
			self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
		} else {
		}
	}
	return self;
}

- (void)setCurrentModel:(CLPickerModel * _Nullable)currentModel dataSource:(NSArray<CLPickerModel *> *)dataSource {
	_dataArray = dataSource;
	self.currentIndex = -1;
	
	[self reloadData];
	
	if (currentModel) {
		self.currentIndex = 0;
		for (CLPickerModel *model in dataSource) {
			if ([model.key isEqualToString:currentModel.key]) {
				break;
			}
			self.currentIndex ++;
		}
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			if (self.visibleCells.count > 0 && dataSource.count > self.currentIndex) {
				[self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
			}
		});
	}
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	CLPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	cell.textColor = self.textColor;
	cell.textSelectColor = self.textSelectColor;
	
	CLPickerModel *model = self.dataArray[indexPath.row];
	cell.textLabel.text = model.value;
	
	if (indexPath.row == self.currentIndex) {
		// 自动选中某行，调用[cell setSelected:]
		[tableView selectRowAtIndexPath:indexPath animated:false scrollPosition:UITableViewScrollPositionNone];
	}
	return cell;
}

// 选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	[cell setSelected:true];
	if (self.selected == NO) {
		self.selected = YES;
		id rowData = self.dataArray[indexPath.row];
		if (self.pickerProtocol && [self.pickerProtocol respondsToSelector:@selector(pickerTableView:didSelectModel:)]) {
			[self.pickerProtocol pickerTableView:self didSelectModel:rowData];
		}
		[self performSelector:@selector(didSelectRowEnd) withObject:nil afterDelay:0.5];
	} else {
		return;
	}
}

// 取消选中
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	[cell setSelected:false];
}

- (void)didSelectRowEnd {
	self.selected = NO;
}

@end

@implementation CLPickerSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.label = [[UILabel alloc] init];
		self.label.text = @"选择列表";
		self.label.textColor = [UIColor lightGrayColor];
		self.label.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
		[self addSubview:self.label];
		[self.label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(16);
			make.centerY.equalTo(self);
		}];
	}
	return self;
}

@end

@implementation CLPickerTableViewCell

- (void)setTextColor:(UIColor *)textColor {
	if (textColor) {
		_textColor = textColor;
	}
}

- (void)setTextSelectColor:(UIColor *)textSelectColor {
	if (textSelectColor) {
		_textSelectColor = textSelectColor;
	}
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.textColor = [UIColor lightGrayColor];
		self.textSelectColor = [UIColor colorWithWhite:1 alpha:0.8];
		self.textLabel.textColor = self.textColor;
		self.textLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightRegular)];
		[self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.contentView).offset(16);
			make.centerY.equalTo(self.contentView);
		}];
		
		// 设置选中背景
		UIView *view = [UIView new];
		view.backgroundColor = [UIColor groupTableViewBackgroundColor];
		self.selectedBackgroundView = view;
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
	if (selected) {
		self.textLabel.textColor = self.textSelectColor;
	} else {
		self.textLabel.textColor = self.textColor;
	}
}

@end
