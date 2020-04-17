//
//  CLMainHomeViewController.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/4/15.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLMainHomeViewController.h"
#import "CLTableView.h"
#import "MainTableViewCell.h"
@interface CLMainHomeViewController ()<UITableViewDelegate, UITableViewDataSource>

/// <#Description#>
@property (strong, nonatomic) CLTableView *tableView;

@end

@implementation CLMainHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.view.backgroundColor = UIColor.redColor;
	[self.view addSubview:self.tableView];
	[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//	CLBaseTableViewCell *cell = [CLBaseTableViewCell dequeueReusable:tableView];
//CLBaseTableViewCell *cell = [CLBaseTableViewCell defualtTableViewCell:tableView];
	MainTableViewCell *cell = [MainTableViewCell dequeueXibReusable:tableView indexPath:indexPath];
//	NSLog(@"cell 地址：%p", &cell);
	return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	MainTableViewCell *aCell = (MainTableViewCell *)cell;
	NSString *text = [NSString stringWithFormat:@"aa = %ld", indexPath.row];
	CLBaseModel *model = [CLBaseModel new];
	model.objectId = text;
	[aCell setDataWithModel:model];
	
}
/*
- (void)drawCell:(VVeboTableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *data = [datas objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //清除cell内容，解决复用问题
    [cell clear];
    cell.data = data;
  //判断如果needLoadArr中含有需要加载的indexPath而当前indexPath又不在其中的时候，则不绘制cell直接返回
    if (needLoadArr.count>0&&[needLoadArr indexOfObject:indexPath]==NSNotFound) {
        [cell clear];
        return;
    }
  //判断如果scrollToToping为真的时候（及点击状态栏快速回到TableView顶部的时候）不绘制cell
    if (scrollToToping) {
        return;
    }
    //上面都没问题的话，绘制cell
    [cell draw];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VVeboTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[VVeboTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:@"cell"];
    }
    [self drawCell:cell withIndexPath:indexPath];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [needLoadArr removeAllObjects];
}
*/

/*
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    scrollToToping = YES;
    return YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    scrollToToping = NO;
    [self loadContent];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    scrollToToping = NO;
    [self loadContent];
}

//用户触摸时第一时间加载内容
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (!scrollToToping) {
        [needLoadArr removeAllObjects];
        [self loadContent];
    }
    return [super hitTest:point withEvent:event];
}

- (void)loadContent{
    if (scrollToToping) {
        return;
    }
    if (self.indexPathsForVisibleRows.count<=0) {
        return;
    }
    if (self.visibleCells&&self.visibleCells.count>0) {
        for (id temp in [self.visibleCells copy]) {
            VVeboTableViewCell *cell = (VVeboTableViewCell *)temp;
            [cell draw];
        }
    }
}
*/
#pragma mark - Lazy
- (CLTableView *)tableView {
	if (!_tableView) {
		_tableView = [[CLTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.rowHeight = 100;
		[MainTableViewCell registerXibForTableView:_tableView];
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
