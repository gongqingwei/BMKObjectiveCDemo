//
//  BMKContinueLocationPage.m
//  IphoneMapSdkDemo
//
//  Created by Baidu RD on 2018/3/6.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKContinueLocationPage.h"
#import "BMKContinueLocationParametersPage.h"
#import <BMKLocationkit/BMKLocationComponent.h>

//开发者通过此delegate获取mapView的回调方法
@interface BMKContinueLocationPage ()<BMKMapViewDelegate, BMKLocationManagerDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) BMKLocationManager *locationManager; //定位对象
@property (nonatomic, strong) UIButton *customButton;
@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象
@end

@implementation BMKContinueLocationPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
    
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
    self.title = @"连续定位";
    UIBarButtonItem *customButton = [[UIBarButtonItem alloc]initWithCustomView:self.customButton];
    self.navigationItem.rightBarButtonItem = customButton;
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
    //实例化BMKLocationManager定位信息类对象
    //开启定位服务
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
    //显示定位图层
    _mapView.showsUserLocation = YES;
}

#pragma mark - Responding events
- (void)clickCustomButton {
    BMKContinueLocationParametersPage *page = [[BMKContinueLocationParametersPage alloc] init];
    page.setupContinueLocationBlock = ^(BMKLocationManager *locationManager) {
        //设置定位精度。默认为kCLLocationAccuracyBest
        self.locationManager.desiredAccuracy = locationManager.desiredAccuracy;
        //设置定位的最小更新距离。默认为kCLDistanceFilterNone
        self.locationManager.distanceFilter = locationManager.distanceFilter;
        //指定定位是否会被系统自动暂停，默认为YES，只在iOS 6.0之后起作用
        self.locationManager.pausesLocationUpdatesAutomatically = locationManager.pausesLocationUpdatesAutomatically;
        /**
         指定定位：是否允许后台定位更新，默认为NO，只在iOS 9.0之后起作用。
         设为YES时，Info.plist中 UIBackgroundModes 必须包含 "location"
         */
        self.locationManager.allowsBackgroundLocationUpdates = locationManager.allowsBackgroundLocationUpdates;
    };
    [self.navigationController pushViewController:page animated:YES];
}

#pragma mark - BMKLocationManagerDelegate

- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateHeading:(CLHeading *)heading {
    if (!heading) {
        return;
    }
    NSLog(@"用户方向更新");
}

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
/**
 *  @brief 当定位发生错误时，会调用代理的此方法。
 *  @param manager 定位 BMKLocationManager 类。
 *  @param error 返回的错误，参考 CLError 。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error {
    NSLog(@"定位失败");
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}

- (UIButton *)customButton {
    if (!_customButton) {
        _customButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_customButton setTitle:@"参数" forState:UIControlStateNormal];
        [_customButton setTitle:@"参数" forState:UIControlStateHighlighted];
        [_customButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_customButton setFrame:CGRectMake(0, 3, 69, 20)];
        [_customButton addTarget:self action:@selector(clickCustomButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customButton;
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
