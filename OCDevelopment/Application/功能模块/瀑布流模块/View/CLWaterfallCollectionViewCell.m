//
//  CLWaterfallCollectionViewCell.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/27.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLWaterfallCollectionViewCell.h"

@implementation CLWaterfallCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	
	/// 不会离屏渲染
	self.cover.layer.cornerRadius = 10;
	self.cover.layer.masksToBounds = YES;
}

@end
