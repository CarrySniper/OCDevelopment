//
//  CLMKMapAddressView.m
//  OCDevelopment
//
//  Created by CarrySniper on 2020/9/25.
//  Copyright © 2020 CarrySniper. All rights reserved.
//

#import "CLMKMapAddressView.h"
#import "CLBaseTableViewCell.h"

@interface CLMKMapAddressView ()<MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>

/// 地图屏幕中心位置图标
@property (nonatomic, strong) UIImageView *centerAnnotation;

/// 地图
@property (nonatomic, strong) MKMapView *mapView;

/// 地址列表
@property (nonatomic, strong) UITableView *tableView;

/// 关闭按钮
@property (nonatomic, strong) UIButton *closeButton;

/// 地址数组
@property (nonatomic, strong) NSMutableArray *dataArray;

/// 地理编码器
@property (nonatomic, strong) CLGeocoder *geocoder;

/// 定位管理
@property (nonatomic, strong) CLLocationManager *locationManager;

/// 回调
@property (nonatomic, copy) void(^completionHandler)(NSString *address);

@end

@implementation CLMKMapAddressView

#pragma mark - lazy
#pragma mark 地理编码类
- (CLGeocoder *)geocoder {
	if (!_geocoder) {
		_geocoder = [[CLGeocoder alloc]init];
	}
	return _geocoder;
}

#pragma mark 定位管理
- (CLLocationManager *)locationManager {
	if (!_locationManager) {
		_locationManager = [[CLLocationManager alloc]init];
		_locationManager.delegate = self;
		_locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;/// 定位精度要求（百米）
		_locationManager.distanceFilter = 100;/// 距离筛选器（100）米更新
	}
	return _locationManager;
}

#pragma mark 地图
- (MKMapView *)mapView {
	if (!_mapView) {
		_mapView = [[MKMapView alloc] init];
		//设置地图的显示风格(普通)
		_mapView.mapType = MKMapTypeStandard;
		//设置地图可缩放
		_mapView.zoomEnabled = YES;
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

#pragma mark 地址列表
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
		
	}
	return _tableView;
}

#pragma mark 关闭按钮
- (UIButton *)closeButton {
	if (!_closeButton) {
		_closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_closeButton setImage:[UIImage imageNamed:@"navigation_cancel"] forState:(UIControlStateNormal)];
		[_closeButton addTarget:self action:@selector(hide) forControlEvents:(UIControlEventTouchUpInside)];
	}
	return _closeButton;
}

#pragma mark 屏幕中心位置图标
- (UIImageView *)centerAnnotation {
	if (!_centerAnnotation) {
		_centerAnnotation = [[UIImageView alloc]init];
		_centerAnnotation.image = [UIImage imageNamed:@"icon_map_location"];
	}
	return _centerAnnotation;
}

#pragma mark 地址数据
- (NSMutableArray *)dataArray {
	if (!_dataArray) {
		_dataArray = [NSMutableArray array];
	}
	return _dataArray;
}

+ (void)showViewWithCompletionHandler:(void(^)(NSString *address))completionHandler {
	CLMKMapAddressView *view = [[CLMKMapAddressView alloc]init];
	view.type = CLPopupViewTypeSheet;
	view.completionHandler = completionHandler;
	[view show];
}

#pragma mark - 开始 停止
- (void)startLocation {
	[self.locationManager requestWhenInUseAuthorization];
	[self.locationManager startUpdatingLocation];
}

- (void)stopLocation {
	[self.locationManager stopUpdatingLocation];
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
		
		[self addSubview:self.centerAnnotation];
		[self.centerAnnotation mas_makeConstraints:^(MASConstraintMaker *make) {
			make.center.equalTo(self.mapView);
			make.width.height.mas_offset(14);
		}];
		
		[self addSubview:self.closeButton];
		[self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.top.equalTo(self.mapView);
			make.width.height.mas_offset(44);
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
	
	[self startLocation];
}

- (void)hide {
	[self stopLocation];
	[super hide];
}

#pragma mark - UITableView 代理方法
#pragma mark 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	self.completionHandler ? self.completionHandler(cell.detailTextLabel.text) : nil;
	[self hide];
}

#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataArray.count;
}

#pragma mark cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"CLMKMapAddressViewCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:cellIdentifier];
	}
	CLPlacemark *placemark = self.dataArray[indexPath.row];
	if (placemark.subLocality) {
		cell.textLabel.text = placemark.locality;
	} else {
		cell.textLabel.text = placemark.country;
	}
	
	if (placemark.subLocality) {
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", placemark.subLocality, placemark.name];
	} else {
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", placemark.name];
	}
	return cell;
}

#pragma mark 分组头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headerView = [[UIView alloc] init];
	headerView.backgroundColor = UIColor.whiteColor;
	UILabel *label = ({
		UILabel *label = [[UILabel alloc] init];
		label.text = @"附近地址";
		label.textColor = UIColor.lightGrayColor;
		label.font = [UIFont systemFontOfSize:13 weight:(UIFontWeightRegular)];
		label;
	});
	[headerView addSubview:label];
	[label mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(headerView).insets(UIEdgeInsetsMake(0, 16, 0, 26));
	}];
	return headerView;
}

#pragma mark 分组头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
	if (locations && locations.count > 0) {
//		CLLocation *location = [locations lastObject];
//
//		CLLocationCoordinate2D coordinate = location.coordinate;
//		MKCoordinateSpan span = {0.01, 0.01};
//		MKCoordinateRegion region = {coordinate, span};
//		/// 设置显示区域
//		[self.mapView setRegion:region animated:YES];
//
//		/// 添加大头针
//		if (!self.annotation) {
//			self.annotation = [[CLAnnotation alloc] init];
//			self.annotation.coordinate = location.coordinate;
//			self.annotation.title = @"我的位置";
//			[self.mapView addAnnotation:self.annotation];
//		}
	}
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

#pragma mark 代理方法
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
	NSLog(@"地图位置更新");
	
	CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
	MKCoordinateSpan span = {0.01, 0.01};
	MKCoordinateRegion region = {coordinate, span};
	
	/// 设置显示区域
	[self.mapView setRegion:region animated:YES];
}

#pragma mark 当MKMapView显示区域将要发生改变时激发该方法
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
	NSLog(@"地图控件的显示区域要发生改变");
	
	[UIView animateWithDuration:0.3 animations:^{
		self.centerAnnotation.transform = CGAffineTransformTranslate(self.centerAnnotation.transform, 0, -5);
		self.centerAnnotation.transform = CGAffineTransformScale(self.centerAnnotation.transform, 1.2, 1.2);
	}];
}

#pragma mark 当MKMapView显示区域改变完成时激发该方法
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
	NSLog(@"地图控件完成了改变");
	[self stopLocation];
	
	[UIView animateWithDuration:0.3 animations:^{
		self.centerAnnotation.transform = CGAffineTransformIdentity;
		self.centerAnnotation.transform = CGAffineTransformIdentity;
	}];
	
	CLLocation *location = [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
	/// 调用反地理编码方法 -->头文件第一个方法
	[self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError * _Nullable error) {
		/// 解析数据
		if (error) {
			return;
		}
		self.dataArray = placemarks.mutableCopy;
		[self.tableView reloadData];
	}];
}

@end

@implementation CLAnnotation

@end
