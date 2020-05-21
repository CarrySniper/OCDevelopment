//
//  MainPopupView.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/5/21.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "MainPopupView.h"

@implementation MainPopupView

+ (instancetype)showViewWithCompletionHandler:(void(^)(void))completionHandler {
	MainPopupView *view = [MainPopupView viewFromXib];
	view.type = CLPopupViewTypeAlert;
	
	view.completionHandler = completionHandler;
	
	[view show];
	return view;
}


- (void)show {
	[super show];
	
	[self mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(300);
		make.height.mas_equalTo(200);
	}];
}

- (void)hide {
	[super hide];
}

@end
