//
//  CLMKMapAddressView.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/9/25.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLMKMapAddressView.h"
#import "CLBaseTableViewCell.h"
#import <MapKit/MapKit.h>

@interface CLMKMapAddressView ()<MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource>

/// 地图
@property (nonatomic, strong) MKMapView *mapView;

/// 地址列表
@property (nonatomic, strong) UITableView *tableView;

/// 地址数组
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CLMKMapAddressView

- (MKMapView *)mapView {
	if (!_mapView) {
		_mapView = [[MKMapView alloc] init];
		//设置地图的显示风格
		_mapView.mapType = MKMapTypeStandard;
		//设置地图可缩放
		_mapView.zoomEnabled = NO;
		//设置地图可滚动
		_mapView.scrollEnabled = YES;
		//设置地图可旋转
		_mapView.rotateEnabled = NO;
		//设置显示用户显示位置
		_mapView.showsUserLocation = YES;
		//为MKMapView设置delegate
		_mapView.delegate = self;
	}
	return _mapView;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
		
	}
	return _tableView;
}

- (NSMutableArray *)dataArray {
	if (!_dataArray) {
		_dataArray = [NSMutableArray array];
	}
	return _dataArray;
}

+ (void)showView {
	CLMKMapAddressView *view = [[CLMKMapAddressView alloc]init];
	view.type = CLPopupViewTypeSheet;
	[view show];
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		[self addSubview:self.mapView];
		[self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.right.top.equalTo(self);
			make.height.mas_equalTo(SCREEN_WIDTH *9/16);
		}];
		
		[self addSubview:self.tableView];
		[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.right.bottom.equalTo(self);
			make.top.equalTo(self.mapView.mas_bottom);
		}];
	}
	return self;
}

- (void)show {
	[super show];
	
	[self mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(SCREEN_WIDTH);
		make.height.mas_equalTo(SCREEN_HEIGHT *3/5);
	}];
}

#pragma mark - UITableView 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"CLMKMapAddressViewCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:cellIdentifier];
	}
	CLPlacemark *placemark = self.dataArray[indexPath.row];
	cell.textLabel.text = placemark.locality;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", placemark.subLocality, placemark.name];
	return cell;
}

#pragma mark - mapView代理方法

#pragma mark 显示标注视图
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
	static NSString *annotationID = @"annotation";
	MKPinAnnotationView *view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationID];
	if (!view) {
		view = [[MKPinAnnotationView alloc]init];
	}
	view.annotation = annotation;
	view.pinTintColor = UIColor.redColor;
	view.canShowCallout = YES;
	return view;
}

#pragma mark - 代理方法
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
	CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
	MKCoordinateSpan span = {0.01, 0.01};
	MKCoordinateRegion region = {coordinate, span};
	//设置显示区域
	[self.mapView setRegion:region animated:YES];
}

//当MKMapView显示区域将要发生改变时激发该方法
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
	NSLog(@"地图控件的显示区域要发生改变");
}

//当MKMapView显示区域改变完成时激发该方法
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animatedb{
	NSLog(@"地图控件完成了改变");
	
	CLLocation *location = [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
	/// 创建Geocoder对象
	CLGeocoder *geocoder = [CLGeocoder new];
	/// 调用反地理编码方法 -->头文件第一个方法
	[geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError * _Nullable error) {
		/// 解析数据
		if (placemarks.count ==0 || error) {
			return;
		}
		self.dataArray = placemarks.mutableCopy;
		[self.tableView reloadData];
	}];
}

//当地图控件MKMapView开始加载数据时激发该方法
-(void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
	NSLog(@"地图控件开始加载地图数据");
	//创建MKCoordinateRegion对象，该对象代表地图的显示中心和显示范围
	MKCoordinateRegion region = mapView.region;
	//	self.latitude.text = [NSString stringWithFormat:@"%f",region.center.latitude];
	//	self.longitude.text = [NSString stringWithFormat:@"%f",region.center.longitude];
}
//当MKMapView加载数据完成时激发该方法
-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
	NSLog(@"地图控件加载地图数据完成");
	NSLog(@"%@",mapView);
}
//当MKMapView加载数据失败时激发该方法
-(void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
	NSLog(@"地图控件加载地图数据发生错误：错误信息：%@",error);
}
//当MKMapView开始渲染地图时激发该方法
-(void)mapViewWillStartRenderingMap:(MKMapView *)mapView
{
	NSLog(@"地图控件开始渲染地图");
}
//当MKMapView渲染地图完成时激发该方法
-(void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
	NSLog(@"地图控件渲染完成");
}


@end
