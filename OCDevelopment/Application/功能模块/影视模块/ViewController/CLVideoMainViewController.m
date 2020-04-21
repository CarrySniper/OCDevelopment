//
//  CLVideoMainViewController.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/21.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLVideoMainViewController.h"
#import "CLVideoTableView.h"

@interface CLVideoMainViewController ()

/// Description
@property (strong, nonatomic) CLVideoTableView *tableView;

@end

@implementation CLVideoMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	[self.view addSubview:self.tableView];
	[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
	
	// 第一次加载数据
	[self.tableView.mj_header beginRefreshing];
}

- (CLVideoTableView *)tableView {
	if (!_tableView) {
		_tableView = [[CLVideoTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
	}
	return _tableView;
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
