//
//  CLPickerView.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/6/1.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLPickerView.h"
#import "CLPickerToolView.h"
#import "CLPickerScrollView.h"

@interface CLPickerView ()<CLPickerToolViewProtocol, CLPickerScrollViewProtocol>

/// 顶部工具栏
@property (nonatomic, strong) CLPickerToolView *toolView;

/// 列表
@property (nonatomic, strong) CLPickerScrollView *scrollView;

/// 选中数据
@property (nonatomic, strong) NSArray<CLPickerModel *> * _Nullable currentModels;

/// 完成回调
@property (nonatomic, copy) void(^completionHandler)(NSArray<CLPickerModel *> * _Nullable selectArray);

@end

@implementation CLPickerView

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.type = CLPopupViewTypeSheet;
		self.hideWhenTouchOutside = YES;
	}
	return self;
}

#pragma mark - 设置数据
- (void)setCurrentModels:(NSArray<CLPickerModel *> * _Nullable)currentModels
			  dataSource:(NSArray<CLPickerModel *> * _Nullable)dataSource {
	
	/// 数据导入
	self.currentModels = currentModels;
	[self.scrollView setCurrentModels:currentModels dataSource:(dataSource.count > 0 ? dataSource : [CLPickerView defaultData])];
}

#pragma mark - 显示视图
- (void)showViewWithCompletionHandler:(void(^)(NSArray<CLPickerModel *> * _Nullable selectArray))completionHandler {
	self.completionHandler = completionHandler;
	[self cl_setup];
	[self show];
}

#pragma mark - 默认本地文件数据
+ (NSArray *)defaultData {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"area.json" ofType:nil];
	NSDictionary *datas = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers error:nil];
	NSArray *array = datas[@"provinces"];
	NSMutableArray *models = [NSMutableArray array];
	for (NSDictionary *dict in array) {
		CLPickerModel *model = [CLPickerModel new];
		model.key = [NSString stringWithFormat:@"%@", dict[@"pid"]];
		model.value = dict[@"provinceName"];
		
		/// ------- 下一级 城市
		NSArray *citys = dict[@"citys"];
		NSMutableArray *cityArray = [NSMutableArray array];
		for (NSDictionary *city in citys) {
			CLPickerModel *cityModel = [CLPickerModel new];
			cityModel.key = [NSString stringWithFormat:@"%@", city[@"cid"]];
			cityModel.value = city[@"citysName"];
			cityModel.nextData = nil;
			[cityArray addObject:cityModel];
		}
		/// ------- 下一级 城市
		model.nextData = cityArray;
		[models addObject:model];
	}
	return models;
}

- (void)cl_setup {
	// 背景色
	self.backgroundColor = UIColor.whiteColor;

	// 顶部
	[self addSubview:self.toolView];
	[self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.equalTo(self);
		make.height.mas_equalTo(80);
	}];

	// 内容
	[self addSubview:self.scrollView];
	[self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self);
		make.top.equalTo(self.toolView.mas_bottom);
		make.bottom.equalTo(self);
	}];
}

#pragma mark - 显示并设置，调用父类的show，子类继承的话要用mas_updateConstraints更新约束
- (void)show {
	[super show];
	
	[self mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(SCREEN_WIDTH);
		make.height.mas_equalTo(80+360);//tableView的高设置360，包括安全区域
	}];
	
	[self makeCorner];
}

#pragma mark - 隐藏
- (void)hide {
	[super hide];
}

#pragma mark 完成事件

/// 确认事件
/// @param toolView 列表
- (void)pickerToolViewWithConfirmAction:(CLPickerToolView *)toolView {
	if (self.completionHandler) {
		self.completionHandler(self.currentModels);
	}
	[self hide];
}

/// 返回事件
/// @param toolView 列表
- (void)pickerToolViewWithBackAction:(CLPickerToolView *)toolView {
	BOOL hide = [self.scrollView scrollLastPage] == NO;
	if (hide) {
		[self hide];
	}
}

/// 更新选中地址
/// @param scrollView 列表
/// @param selectArray 选中对象
- (void)pickerScrollView:(CLPickerScrollView *)scrollView updateSelectArray:(NSArray *)selectArray {
	_currentModels = selectArray;
	if (selectArray.count) {
		NSString *address = @"";
		for (id item in selectArray) {
			if ([item isKindOfClass:[CLPickerModel class]]) {
				CLPickerModel *model = (CLPickerModel *)item;
				address = [address stringByAppendingFormat:@"   %@", model.value];
			}
		}
		self.toolView.address = address;
	} else {
		self.toolView.address = @"无";
	}
}

/// 当前第几页代理
/// @param scrollView 列表
/// @param currentPage 当前第几页
- (void)pickerScrollView:(CLPickerScrollView *)scrollView currentPage:(NSUInteger)currentPage {
	if (currentPage == 0) {
		self.toolView.backText = @"取消";
	} else {
		self.toolView.backImage = [UIImage imageNamed:@"icon_cl_item_back"];
	}
}

#pragma mark - 添加圆角
- (void)makeCorner {
	[self layoutIfNeeded];
	// 圆角大小
	CGFloat radius = 10.0;
	// 圆角位置
	UIRectCorner corner = UIRectCornerTopLeft | UIRectCornerTopRight;
	// 贝塞尔曲线
	UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
													 byRoundingCorners:corner
														   cornerRadii:CGSizeMake(radius, radius)];
	CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
	maskLayer.frame = self.bounds;
	maskLayer.path = bezierPath.CGPath;
	self.layer.mask = maskLayer;
}

#pragma mark -
- (CLPickerToolView *)toolView {
	if (!_toolView) {
		_toolView = [[CLPickerToolView alloc] init];
		_toolView.pickerProtocol = self;
		_toolView.title = self.title;
		_toolView.typeName = self.typeName;
		_toolView.backImage = self.backImage;
		_toolView.textColor = self.textColor;
		_toolView.titleColor = self.titleColor;
		_toolView.confirmTextColor = self.confirmTextColor;
	}
	return _toolView;
}

- (CLPickerScrollView *)scrollView {
	if (!_scrollView) {
		_scrollView = [[CLPickerScrollView alloc] init];
		_scrollView.pickerProtocol = self;
		_scrollView.textColor = self.textColor;
		_scrollView.textSelectColor = self.textSelectColor;
	}
	return _scrollView;
}

@end
