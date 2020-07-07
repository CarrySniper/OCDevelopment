//
//  CLTabBarController.m
//  OCDevelopment
//
//  Created by CJQ on 2020/3/29.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLTabBarController.h"
#import "CLNavigationController.h"

#pragma mark - Item
@implementation CLTabBarItem

@end

#pragma mark - Controller
@interface CLTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, assign) NSUInteger flagIndex;

@end

@implementation CLTabBarController

#pragma mark - 自定义init
- (instancetype)init {
	if (self = [super init]) {
		[self setupViewControllersData];
    }
	return self;
}

- (instancetype)initWithTabBarItems:(NSArray<CLTabBarItem *> *)items {
    if (self = [super init]) {
		[items enumerateObjectsUsingBlock:^(CLTabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			UIViewController *vc = [self makeControllerWithClassName:obj.className title:obj.title normalImageName:obj.normalImageName selectedImageName:obj.selectedImageName];
			CLNavigationController *navigationController = [[CLNavigationController alloc]initWithRootViewController:vc];
			navigationController.tabBarItem.tag = idx;
			[self addChildViewController:navigationController];
		}];
    }
    return self;
}

#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.delegate = self;
	
	self.flagIndex = 0;
	
	[self setupAttribute];
}

#pragma mark - 配置
#pragma mark 实例化控制器
- (void)setupViewControllersData {
	NSArray *controllers = @[
							 @[@"首页", @"CLMainHomeViewController"],
							 @[@"我的", @"CLMineHomeViewController"]];
	[controllers enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger idx, BOOL * _Nonnull stop) {
		NSString *normalImageName = [NSString stringWithFormat:@"tabbar_normal%zd", idx];
		NSString *selectedImageName = [NSString stringWithFormat:@"tabbar_selected%zd", idx];
		UIViewController *vc = [self makeControllerWithClassName:array.lastObject title:array.firstObject normalImageName:normalImageName selectedImageName:selectedImageName];
		CLNavigationController *navigationController = [[CLNavigationController alloc]initWithRootViewController:vc];
		navigationController.tabBarItem.tag = idx;
		[self addChildViewController:navigationController];
	}];
}

#pragma mark 配置默认 TabBar
- (void)setupAttribute {
	[[UITabBar appearance] setTranslucent:NO];
	[[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
	[[UITabBarItem appearance] setTitleTextAttributes:@{
														NSFontAttributeName : [UIFont boldSystemFontOfSize:10],
														NSForegroundColorAttributeName : COLOR_NORMAL
														} forState:UIControlStateNormal];
	[[UITabBarItem appearance] setTitleTextAttributes:@{
														NSFontAttributeName : [UIFont boldSystemFontOfSize:10],
														NSForegroundColorAttributeName : COLOR_SELECTED
														} forState:UIControlStateSelected];
}

#pragma mark 生成并统一设置标题、图标
- (UIViewController *)makeControllerWithClassName:(NSString *)className
											title:(NSString *)title
								  normalImageName:(NSString *)normalImageName
								selectedImageName:(NSString *)selectedImageName {
	Class class = NSClassFromString(className);
	if (class == nil) {
		return nil;
	}
	UIViewController *controller = [[class alloc]init];
	if (title) {
		controller.title = title;
	}
	if ([UIImage imageNamed:normalImageName]) {
		controller.tabBarItem.image = [[UIImage imageNamed:normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	}
	if ([UIImage imageNamed:selectedImageName]) {
		controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	}
	return controller;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	NSUInteger shouldSelectIndex = [tabBarController.viewControllers indexOfObject:viewController];
	if (tabBarController.selectedIndex == shouldSelectIndex) {
		return YES;
	}
	CATransition *animation = [CATransition animation];
	animation.duration = 0.5;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	animation.type = kCATransitionPush;
	if (tabBarController.selectedIndex > shouldSelectIndex) {
		animation.subtype = kCATransitionFromLeft;
	} else {
		animation.subtype = kCATransitionFromRight;
	}
	// 与百度上一般文章不一样
	[[[tabBarController valueForKey:@"_viewControllerTransitionView"] layer] addAnimation:animation forKey:@"animation"];
	return YES;
}

#pragma marl - 排序算法 冒泡排序
- (NSMutableArray<UIView *> *)bullArray:(NSMutableArray<UIView *> *)array {
	for (int i = 0; i<array.count; i++) {
		for (int j = 0; j<array.count-1-i; j++) {
			UIView *view1 = array[j];
			UIView *view2 = array[j+1];
			if (view1.frame.origin.x < view2.frame.origin.x) {
				[array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
			}
		}
	}
	return array;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	NSInteger index = [self.tabBar.items indexOfObject:item];
	if (index != self.flagIndex) {
		//执行动画
		NSMutableArray *arry = [NSMutableArray array];
		for (UIView *btn in self.tabBar.subviews) {
			if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
				[arry addObject:btn];
			}
		}
		// 有序的键组 大到小
		NSArray *sortArray = [arry sortedArrayUsingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2) {
			return [@(obj1.frame.origin.x) compare:@(obj2.frame.origin.x)];
		}];
		//放大效果，并回到原位
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
		//速度控制函数，控制动画运行的节奏
		animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		animation.duration = 0.2;       //执行时间
		animation.repeatCount = 1;      //执行次数
		animation.autoreverses = YES;    //完成动画后会回到执行动画之前的状态
		animation.fromValue = [NSNumber numberWithFloat:0.9];   //初始伸缩倍数
		animation.toValue = [NSNumber numberWithFloat:1.0];     //结束伸缩倍数
		[[sortArray[index] layer] addAnimation:animation forKey:nil];

		self.flagIndex = index;
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
