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

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];//即使没有显示在window上，也不会自动的将self.view释放。
	// Dispose of any resources that can be recreated.
	// 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidUnLoad
	if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
		//需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载 ，在WWDC视频也忽视这一点。
		if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
		{
			//code
			self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
		}
	}
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
