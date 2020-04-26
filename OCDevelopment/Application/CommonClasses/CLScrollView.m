//
//  CLScrollView.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/22.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLScrollView.h"

@implementation CLScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/// 重写方法：解决UITableViewCell左滑删除等手势与UIScrollView滚动冲突
/// @param gestureRecognizer 识别某个手势
/// @param otherGestureRecognizer 另一个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	if (gestureRecognizer.state != 0) {
		return YES;
	} else {
		return NO;
	}
}

@end
