//
//  CLBaseCollectionViewCell.m
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLBaseCollectionViewCell.h"

@implementation CLBaseCollectionViewCell

#pragma mark - 设置数据
#pragma mark 设置模型数据对象
- (void)setDataWithModel:(CLBaseModel *)model {
	// test
	//self.textLabel.text = model.objectId;
}

#pragma mark - 纯代码
#pragma mark 注册Cell
+ (void)registerForCollectionView:(UICollectionView *)collectionView
{
	NSString *name = NSStringFromClass(self.class);
	[collectionView registerClass:self.class forCellWithReuseIdentifier:name];
}

#pragma mark - Xib
#pragma mark 注册Cell
+ (void)registerXibForCollectionView:(UICollectionView *)collectionView
{
	NSString *name = NSStringFromClass(self.class);
	[collectionView registerNib:[UINib nibWithNibName:name bundle:nil] forCellWithReuseIdentifier:name];
}

#pragma mark -
#pragma mark 纯代码获取Cell方法纯代码／Xib 获取cell
+ (instancetype)dequeueReusable:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
	@autoreleasepool {
		NSString *name = NSStringFromClass(self.class);
		return [collectionView dequeueReusableCellWithReuseIdentifier:name forIndexPath:indexPath];
	}
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	
	self.backgroundColor = COLOR_CELL;
	self.contentView.backgroundColor = COLOR_CELL;
	// 设置选中背景
	UIView *view = [UIView new];
	view.backgroundColor = COLOR_LINE;
	self.selectedBackgroundView = view;
}

@end
