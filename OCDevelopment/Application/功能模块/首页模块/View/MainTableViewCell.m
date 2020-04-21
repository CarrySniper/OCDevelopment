//
//  MainTableViewCell.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/15.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "MainTableViewCell.h"

@implementation MainTableViewCell

- (void)setDataWithModel:(CLBaseModel *)model {
	self.textLabel.text = model.objectId;
	
	
//	self.icon.image = [UIImage imageNamed:@"202004"];
//	[self.icon cl_setImage:[UIImage imageNamed:@"202004"] cornerRadius:20];
//	[self.icon cl_setImageUrlString:@"http://www.17qq.com/img_qqtouxiang/41074669.jpeg" placeholderImage:[UIImage imageNamed:@"202004"] cornerRadius:40];
////
//	[self.btn cl_setBackgroundImageUrlString:@"http://www.17qq.com/img_qqtouxiang/41074669.jpeg" placeholderImage:[UIImage imageNamed:@"202004"] cornerRadius:6 state:UIControlStateNormal];
	
//	[self.icon setImageWithURL:[NSURL URLWithString:@"http://www.17qq.com/img_qqtouxiang/41074669.jpeg"] placeholderImage:[UIImage imageNamed:@"202004"]];

	//	[self.btn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:@"http://www.17qq.com/img_qqtouxiang/41074669.jpeg"] placeholderImage:[UIImage imageNamed:@"202004"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//	self.btn.layer.mask
//	self.btn.layer.cornerRadius = 5.0;
//	self.btn.layer.masksToBounds = YES;
	self.btn.layer.borderWidth = 5.0;
	self.btn.layer.borderColor = UIColor.greenColor.CGColor;
	
//	[self.btn cl_setShadowColor:[UIColor redColor] radius:5.0 shadowOpacity:0.8 shadowOffset:CGSizeMake(0, 0) cornerRadius:6];
//
//	[self.icon cl_setShadowColor:[UIColor redColor] radius:5.0 shadowOpacity:0.8 shadowOffset:CGSizeMake(0, 0) cornerRadius:40];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
