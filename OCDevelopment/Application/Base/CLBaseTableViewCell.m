//
//  CLBaseTableViewCell.m
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLBaseTableViewCell.h"

@implementation CLBaseTableViewCell

#pragma mark - 设置数据
#pragma mark 设置模型数据对象
- (void)setDataWithModel:(CLBaseModel *)model {
	// test
	//self.textLabel.text = model.objectId;
}


#pragma mark - 纯代码
#pragma mark 注册Cell
+ (void)registerForTableView:(UITableView *)tableView
{
	NSString *name = NSStringFromClass(self.class);
	[tableView registerClass:self.class forCellReuseIdentifier:name];
}

#pragma mark 纯代码获取Cell方法
+ (instancetype)dequeueReusable:(UITableView *)tableView
{
	@autoreleasepool {
		NSString *name = NSStringFromClass(self.class);
		return [self dequeueReusable:tableView identifier:name];
	}
}

#pragma mark 纯代码获取Cell方法，指定identifier，可不复用
+ (instancetype)dequeueReusable:(UITableView *)tableView identifier:(NSString *)identifier
{
	CLBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}
	return cell;
}

#pragma mark - Xib
#pragma mark 注册Cell
+ (void)registerXibForTableView:(UITableView *)tableView
{
	NSString *name = NSStringFromClass(self.class);
	[tableView registerNib:[UINib nibWithNibName:name bundle:nil] forCellReuseIdentifier:name];
}


#pragma mark Xib获取Cell方法
+ (instancetype)dequeueXibReusable:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
	@autoreleasepool {
		NSString *name = NSStringFromClass(self.class);
		return [tableView dequeueReusableCellWithIdentifier:name forIndexPath:indexPath];
	}
}

#pragma mark - 系统默认Cell
+ (instancetype)defualtTableViewCell:(UITableView *)tableView
{
	static NSString *identifier = @"CLBaseTableViewCell";
	CLBaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[CLBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}
	return cell;
}

#pragma mark - 配置
- (void)base_setup {
	self.backgroundColor = COLOR_CELL;
	// 设置选中背景
	UIView *view = [UIView new];
	view.backgroundColor = COLOR_LINE;
	self.selectedBackgroundView = view;
}

#pragma mark - Init
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
