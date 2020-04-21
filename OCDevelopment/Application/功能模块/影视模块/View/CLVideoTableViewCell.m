//
//  CLVideoTableViewCell.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/21.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLVideoTableViewCell.h"
#import "CLVideoViewModel.h"

@implementation CLVideoTableViewCell

- (void)setDataWithModel:(CLVideoModel *)model {
	//self.textLabel.text = model.objectId;
	self.title.text = model.title;
	[self.cover setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"202004"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
