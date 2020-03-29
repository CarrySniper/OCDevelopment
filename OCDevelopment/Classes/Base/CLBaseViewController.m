//
//  CLBaseViewController.m
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLBaseViewController.h"

@interface CLBaseViewController ()

@end

@implementation CLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	/// 视图背景颜色
	self.view.backgroundColor = COLOR_VIEW;
	/// 隐藏导航栏的返回按钮
	self.navigationItem.hidesBackButton = YES;
	// 导航栏返回按钮设置，自定义返回按钮将失去边沿左滑返回功能
	if (self.navigationController.viewControllers.count == 0) {
		self.navigationItem.leftBarButtonItem = nil;
	}else{
		UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:IMAGE_NAVIGATION_BACK style:UIBarButtonItemStylePlain target:self action:@selector(customBack)];
		self.navigationItem.leftBarButtonItem = leftItem;
	}
}

- (void)dealloc {
//		HIDE_LOADING(self.view)
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationController.navigationBar.hidden = NO;
	[self.navigationController.navigationBar setTranslucent:NO];
	
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//		[self.navigationController.navigationBar setShadowImage:nil];
//		[self.navigationController.navigationBar setBackgroundImage:[UIImage navigationImage] forBarMetrics:UIBarMetricsDefault];
		[self.navigationController.navigationBar setTintColor:COLOR_TITLE];
//		[self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:COLOR_TITLE, NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:21]}];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[self.view endEditing:YES];
}

#pragma mark - 自定义返回方法
- (void)customBack {
	if (self.navigationController && self.navigationController.viewControllers.count > 1) {
		[self.navigationController popViewControllerAnimated:YES];
	}else{
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

#pragma mark - 重写跳转方法
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
	[super presentViewController:viewControllerToPresent animated:flag completion:^{
		if (completion) {
			completion();
		}
	}];
}

#pragma mark - 重写隐藏方法
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
	[super dismissViewControllerAnimated:flag completion:^{
		// self.view = nil,有效销毁present的视图控制器，不然容易内存泄露
		[self.view removeFromSuperview];
		self.view = nil;
		if (completion) {
			completion();
		}
	}];
}

#pragma mark - 监听点击事件，结束所有编辑状态。
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	[self.view endEditing:YES];
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
