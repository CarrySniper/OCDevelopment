//
//  CLWaterfallViewController.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/27.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLWaterfallViewController.h"
#import "CLWaterfallCollectionView.h"
#import <CHTCollectionViewWaterfallLayout.h>

@interface CLWaterfallViewController ()

/// collectionView
@property (nonatomic, strong) CLWaterfallCollectionView *collectionView;

@end

@implementation CLWaterfallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	NSDictionary *data = self.routerParameters[MGJRouterParameterUserInfo];
	self.title = data[@"title"];
	
	/// 添加视图
	[self.view addSubview:self.collectionView];
	[self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
	
	[self.collectionView.mj_header beginRefreshing];
}

#pragma mark - Lazy
- (CLWaterfallCollectionView *)collectionView {
	if (!_collectionView) {
		CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc]init];
		layout.columnCount = 3;
		layout.minimumColumnSpacing = 10;
		layout.minimumInteritemSpacing = 10;
		layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
		_collectionView = [[CLWaterfallCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
	}
	return _collectionView;
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
