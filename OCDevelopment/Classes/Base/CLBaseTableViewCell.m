//
//  CLBaseTableViewCell.m
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLBaseTableViewCell.h"

@implementation CLBaseTableViewCell

- (void)setDataWithModel:(CLBaseModel *)model {
}

// MARK: - 纯代码 注册 获取
+ (void)registerForTableView:(UITableView *)tableView
{
	NSString *name = NSStringFromClass(self.class);
	[tableView registerClass:self.class forCellReuseIdentifier:name];
}

// 纯代码自定义获取Cell方法
+ (instancetype)dequeueReusable:(UITableView *)tableView
{
	NSString *name = NSStringFromClass(self.class);
	return [self dequeueReusable:tableView identifier:name];
}

// 纯代码自定义获取Cell方法，指定identifier，不复用
+ (instancetype)dequeueReusable:(UITableView *)tableView identifier:(NSString *)identifier
{
	CLBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}
	return cell;
}

// MARK: - Xib 注册
+ (void)registerXibForTableView:(UITableView *)tableView
{
	NSString *name = NSStringFromClass(self.class);
	[tableView registerNib:[UINib nibWithNibName:name bundle:nil] forCellReuseIdentifier:name];
}

// Xib获取Cell方法
+ (instancetype)dequeueXibReusable:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
	NSString *name = NSStringFromClass(self.class);
	return [tableView dequeueReusableCellWithIdentifier:name forIndexPath:indexPath];
}

// MARK: - 系统默认Cell
+ (instancetype)defualtTableViewCell:(UITableView *)tableView
{
	static NSString *identifier = @"CLBaseTableViewCell";
	CLBaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[CLBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}
	return cell;
}

// MARK: - 配置
- (void)base_setup {
	self.backgroundColor = COLOR_CELL;
	self.contentView.backgroundColor = COLOR_CELL;
	// 设置选中背景
	UIView *view = [UIView new];
	view.backgroundColor = COLOR_LINE;
	self.selectedBackgroundView = view;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		[self base_setup];
	}
	return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	[self base_setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
