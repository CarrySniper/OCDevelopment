//
//  CLNavigationController.m
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLNavigationController.h"

@interface CLNavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, getter=isPushing) BOOL pushing;
@property (nonatomic, weak) id interactiveDelegate;

@end

@implementation CLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.delegate = self;
	self.navigationBar.translucent = YES;
    self.interactiveDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
	/// 解决多次跳转问题
	if (self.pushing == YES) {
		NSLog(@"被拦截 %@", NSStringFromClass([viewController class]));
		return;
	} else {
		if (self.viewControllers.count > 0) {
			self.pushing = YES;
		}
	}
	if (self.viewControllers.count > 0) {
		viewController.hidesBottomBarWhenPushed = YES;
	}
	[super pushViewController:viewController animated:animated];
}

#pragma mark - UINavigationControllerDelega
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	/// 解决多次跳转问题
	self.pushing = NO;
	
	/// 解决返回手势失效的问题
	if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = self.interactiveDelegate;
    }else{
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end