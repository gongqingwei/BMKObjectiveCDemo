//
//  BMKCustomPatternLocationViewPage.m
//  IphoneMapSdkDemo
//
//  Created by Baidu RD on 2018/3/6.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKCustomPatternLocationViewPage.h"
#import <BMKLocationkit/BMKLocationComponent.h>

/**
 开发者可通过BMKMapViewDelegate获取mapView的回调方法,BMKLocationManagerDelegate
 获取locationManager的回调方法
 */
@interface BMKCustomPatternLocationViewPage ()<BMKMapViewDelegate, BMKLocationManagerDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) BMKLocationManager *locationManager; //定位对象
@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象
@end

@implementation BMKCustomPatternLocationViewPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
    [self setupLocationManager];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    //当mapView即将被显示的时候调用，恢复之前存储的mapView状态
    [_mapView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    //当mapView即将被隐藏的时候调用，存储当前mapView的状态
    [_mapView viewWillDisappear];
}

#pragma mark - Config UI
- (void)configUI {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"定位展示（自定义样式）";
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

- (void)setupLocationManager {
    
    //开启定位服务
    [self.locationManager startUpdatingLocation];
    //设置显示定位图层
    _mapView.showsUserLocation = YES;
    //配置定位图层个性化样式，初始化BMKLocationViewDisplayParam的实例
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
    //设置定位图标(屏幕坐标)X轴偏移量为0
    param.locationViewOffsetX = 0;
    //设置定位图标(屏幕坐标)Y轴偏移量为0
    param.locationViewOffsetY = 0;
    //设置定位图层locationView在最上层(也可设置为在下层)
    param.locationViewHierarchy = LOCATION_VIEW_HIERARCHY_TOP;
    //设置定位图标，需要将该图片放到mapapi.bundle/images目录下
    param.locationViewImgName = @"xiaoduBear";
    //设置显示精度圈
    param.isAccuracyCircleShow = YES;
    //更新定位图层个性化样式
    [_mapView updateLocationViewWithParam:param];
}

#pragma mark - BMKLocationManagerDelegate
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error {
    if (error) {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    }
    if (!location) {
        return;
    }
    
    self.userLocation.location = location.location;
    
    //实现该方法，否则定位图标不出现
    [_mapView updateLocationData:self.userLocation];
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}

- (BMKLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[BMKLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        _locationManager.allowsBackgroundLocationUpdates = NO;
        _locationManager.locationTimeout = 10;
    }
    return _locationManager;
}

- (BMKUserLocation *)userLocation {
    if (!_userLocation) {
        _userLocation = [[BMKUserLocation alloc] init];
    }
    return _userLocation;
}
@end
