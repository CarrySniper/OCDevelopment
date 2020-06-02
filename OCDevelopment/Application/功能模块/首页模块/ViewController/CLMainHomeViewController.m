//
//  CLMainHomeViewController.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/15.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLMainHomeViewController.h"
#import "CLTableView.h"
#import "MainPopupView.h"
#import "CLAddressView.h"

typedef enum : NSUInteger {
	CLFunctionType_Waterfall,
	CLFunctionType_FMDB,
	CLFunctionType_Download,
	CLFunctionType_Share,
	
	CLFunctionType_PopupView,
	CLFunctionType_Address,
} CLFunctionType;

@interface CLMainModel : CLBaseModel
/// 类型
@property (nonatomic, assign) CLFunctionType type;
/// 名称
@property (nonatomic, copy) NSString *name;
/// 路由地址
@property (nonatomic, copy) NSString *routerUrlPath;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithType:(CLFunctionType)type withName:(NSString *)name withRouterUrlPath:(NSString *)routerUrlPath NS_DESIGNATED_INITIALIZER;

@end

@implementation CLMainModel
- (instancetype)initWithType:(CLFunctionType)type withName:(NSString *)name withRouterUrlPath:(NSString *)routerUrlPath
{
	self = [super init];
	if (self) {
		self.type = type;
		self.name = name;
		self.routerUrlPath = routerUrlPath;
	}
	return self;
}
@end

@interface CLMainHomeViewController ()<UITableViewDelegate, UITableViewDataSource>

/// tableView
@property (nonatomic, strong) CLTableView *tableView;

/// 数据（二维数组）
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CLMainHomeViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	//	self.navigationItem.leftBarButtonItem = nil;
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(barButtonItemAction:)];
	self.navigationItem.rightBarButtonItem = rightItem;
	
	[self initData];
	
	[self.view addSubview:self.tableView];
	[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
}

#pragma mark - Action
- (void)barButtonItemAction:(UIBarButtonItem *)sender {
	
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray *sectionArray = self.dataArray[section];
	return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	CLBaseTableViewCell *cell = [CLBaseTableViewCell defualtTableViewCell:tableView];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	NSArray *sectionArray = self.dataArray[indexPath.section];
	CLMainModel *model = sectionArray[indexPath.row];
	cell.textLabel.text = model.name;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSArray *sectionArray = self.dataArray[indexPath.section];
	CLMainModel *model = sectionArray[indexPath.row];
	switch (model.type) {
		case CLFunctionType_PopupView: {
			[MainPopupView showViewWithCompletionHandler:^{
				
			}];
			return;
		}
			break;
		case CLFunctionType_Address: {
			[CLAddressView showViewWithCurrentModel:@"" completionHandler:^(NSString * _Nonnull currentModel) {
				
			}];
			return;
		}
			break;
		default:
			break;
	}
	/// 路由跳转
	[MGJRouter openURL:model.routerUrlPath withUserInfo:@{@"title":model.name} completion:^(id result) {
		NSLog(@"成功跳转到%@-%@", model.routerUrlPath, model.routerUrlPath);
	}];
}


#pragma mark - Lazy
- (CLTableView *)tableView {
	if (!_tableView) {
		_tableView = [[CLTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.rowHeight = 60;
	}
	return _tableView;
}

#pragma mark - 初始化数据
- (void)initData {
	
	NSArray *oneArray = @[
		[[CLMainModel alloc]initWithType:CLFunctionType_Waterfall
								withName:@"瀑布流(网络图片)"
					   withRouterUrlPath:kMGJWaterfall],
		
		[[CLMainModel alloc]initWithType:CLFunctionType_Share
								withName:@"系统自带分享功能"
					   withRouterUrlPath:kMGJShare]
	];
	
	NSArray *twoArray = @[
		[[CLMainModel alloc]initWithType:CLFunctionType_PopupView
								withName:@"弹窗"
					   withRouterUrlPath:nil],
		
		[[CLMainModel alloc]initWithType:CLFunctionType_Address
								withName:@"地址选择"
					   withRouterUrlPath:nil]
	];
	
	self.dataArray = [NSMutableArray array];
	[self.dataArray addObject:oneArray];
	[self.dataArray addObject:twoArray];
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
