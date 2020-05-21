//
//  MainPopupView1.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/5/21.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "MainPopupView1.h"

@implementation MainPopupView1

+ (instancetype)showViewWithCompletionHandler:(void(^)(void))completionHandler {
	MainPopupView1 *view = [MainPopupView1 viewFromXib];
	view.type = CLPopupViewTypeAlert;
	view.backgroundColor = [UIColor redColor];
	view.completionHandler = completionHandler;
	
	[view show];
	return view;
}

- (void)show {
	[super show];
	
	[self mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(200);
		make.height.mas_equalTo(300);
	}];
}

- (void)hide {
	[super hide];
}
@end
