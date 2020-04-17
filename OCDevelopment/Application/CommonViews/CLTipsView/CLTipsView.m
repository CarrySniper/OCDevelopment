//
//  CLTipsView.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/17.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLTipsView.h"

@implementation CLTipsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)init
{
	NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
	// 得到第n个UIView作为底部容器
	self = (CLTipsView *)[nibViews objectAtIndex:0];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		
//		self.tipsLabel.text = kEmptyText;
		
		self.button.layer.cornerRadius = 20.0;
		self.button.layer.masksToBounds = YES;
		self.button.layer.borderWidth = 0.5;
		self.button.layer.borderColor = COLOR_THEME.CGColor;
		[self.button setTitleColor:COLOR_THEME forState:UIControlStateNormal];
	}
	return self;
}

- (IBAction)clickAction:(id)sender {
	if (self.actionHandler) {
		self.actionHandler();
	}
}

@end
