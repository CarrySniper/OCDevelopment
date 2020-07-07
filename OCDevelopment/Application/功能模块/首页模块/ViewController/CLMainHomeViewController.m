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
#import "CLPickerView.h"
#import "CLThemeManager.h"

typedef enum : NSUInteger {
	CLFunctionType_Waterfall,
	CLFunctionType_FMDB,
	CLFunctionType_Download,
	CLFunctionType_Share,
	CLFunctionType_File,
	CLFunctionType_FileRead,
	
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

/// 城市数据
@property (nonatomic, strong) NSArray<CLPickerModel *> *cityArray;

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
	[[CLThemeManager sharedInstance] setTheme];
	[[CLThemeManager sharedInstance] parseDataWithFileName:@"resource"];
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
		case CLFunctionType_File: {
			NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:50];
			for(int i = 0; i < 50; i++){
				NSDictionary *dict = @{
					@"i": @(i),
					@"ii": @(i+1000),
					@"iii": @(i+2000),
					@"avr": @(i+3000),
					@"avl": @(i+4000),
					@"avf": @(i+5000),
				};
				[dataArray addObject:dict];
			}
//			for k in 0...49 {
//				ecg_data.i = i[k]
//				ecg_data.ii = ii[k]
//				ecg_data.iii = iii[k]
//				ecg_data.avr = avr[k]
//				ecg_data.avl = avl[k]
//				ecg_data.avf = avf[k]
//				queue.enqueue(element: ecg_data)
//			}
			
			NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataArray options:NSJSONWritingPrettyPrinted error:nil];
			NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
			[[AFNetworkHandle sharedInstance] requestMethod:AF_POST urlString:@"http://yuegou.seejoys.com/api/test/index" headers:nil parameters:@{@"ecg_data":dataArray} isJsonBody:YES neesJsonResponse:NO success:^(id  _Nullable responseObject) {
				NSLog(@"error %@", responseObject);
			} failure:^(NSError * _Nullable error) {
				NSLog(@"error %@", error);
			}];
			
//			[AFNetworkHandle requestMethod:AF_POST urlString:@"http://yuegou.seejoys.com/api/test/index" parameters:@{@"ecg_data":jsonString} completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
//				if (error) {
//
//				}
//			}];
			return;
		}
			break;
		case CLFunctionType_FileRead: {
			[[AFNetworkHandle sharedInstance] requestMethod:AF_GET urlString:@"http://yuegou.seejoys.com/api/test/show" headers:nil parameters:nil isJsonBody:NO neesJsonResponse:NO success:^(id  _Nullable responseObject) {
				NSLog(@"error %@", responseObject);
			} failure:^(NSError * _Nullable error) {
				NSLog(@"error %@", error);
			}];
			return;
		}
			break;
		case CLFunctionType_Address: {
			CLPickerView *addressView = [[CLPickerView alloc] init];
			addressView.title = @"城市选择";
			addressView.backImage = [UIImage imageNamed:@"navigation_more"];
			addressView.titleColor = [UIColor blueColor];
			addressView.textColor = [UIColor blueColor];
			addressView.textSelectColor = [UIColor redColor];
			addressView.confirmTextColor = [UIColor redColor];
			[addressView setCurrentModels:self.cityArray dataSource:nil];
			[addressView showViewWithCompletionHandler:^(NSArray<CLPickerModel *> * _Nullable selectArray) {
				self.cityArray = selectArray;
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
					   withRouterUrlPath:nil],
		
		[[CLMainModel alloc]initWithType:CLFunctionType_File
								withName:@"文件上传"
					   withRouterUrlPath:nil],
		
		[[CLMainModel alloc]initWithType:CLFunctionType_FileRead
								withName:@"文件返回"
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
