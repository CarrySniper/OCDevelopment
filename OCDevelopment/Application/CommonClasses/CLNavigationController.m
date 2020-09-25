//
//  CLNavigationController.m
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLNavigationController.h"
#import "CLThemeManager.h"

@interface CLNavigationController ()<UINavigationControllerDelegate>

/// 是否正在push
@property (nonatomic, getter=isPushing) BOOL pushing;

/// 持有交互代理
@property (nonatomic, weak) id interactivePopDelegate;


@end

@implementation CLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.delegate = self;
	self.navigationBar.translucent = YES;
    self.interactivePopDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
	
	/// 通知
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChangeWithNotification:) name:kNotification_CLThemeDidChange object:nil];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kNotification_CLThemeDidChange object:nil];
}

#pragma mark - 主题切换
- (void)themeDidChangeWithNotification:(NSNotification *)notification {
	CLThemeModel *model = notification.object;
	if ([model isKindOfClass:[CLThemeModel class]]) {
		[self.navigationBar setTintColor:model.navigationTintColor];
		[self.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:model.navigationTintColor}];
		[self.navigationBar setBackgroundImage:model.navigationImage forBarMetrics:UIBarMetricsDefault];
	}
}

#pragma mark - 重写方法
#pragma mark 入栈动画方法
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

#pragma mark 完成展示视图方法
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	/// 解决多次跳转问题
	self.pushing = NO;
	
	/// 解决返回手势失效的问题
    self.interactivePopGestureRecognizer.delegate = viewController == self.viewControllers[0]? self.interactivePopDelegate : nil;
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
