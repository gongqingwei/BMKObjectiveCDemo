//
//  BMKPositioningModePage.m
//  IphoneMapSdkDemo
//
//  Created by Baidu RD on 2018/3/6.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKLocationModePage.h"
#import <BMKLocationkit/BMKLocationComponent.h>

#define kHeight_SegMentBackgroud  60
#define kHeight_BottomControlView  60

/**
 开发者可通过BMKMapViewDelegate获取mapView的回调方法,BMKLocationManagerDelegate
 获取locationManager的回调方法
 */
@interface BMKLocationModePage ()<BMKMapViewDelegate, BMKLocationManagerDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIView *bottomControlView;
@property (nonatomic, strong) UISegmentedControl *locationSegmentControl;
@property (nonatomic, strong) UISwitch *locationSwitch;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) BMKLocationManager *locationManager; //定位对象
@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象
@end

@implementation BMKLocationModePage

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
    self.title = @"定位展示（定位模式切换）";
    [self.view addSubview:self.bottomControlView];
    [self.bottomControlView addSubview:self.locationSwitch];
    [self.view addSubview:self.locationSegmentControl];
    [self.bottomControlView addSubview:self.locationLabel];
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

#pragma mark - Responding events
- (void)switchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        //开启定位服务
        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];
        //显示定位图层
        _mapView.showsUserLocation = YES;
    } else {
        //关闭定位服务
        [self.locationManager stopUpdatingLocation];
        [self.locationManager stopUpdatingHeading];
        //不显示定位图层
        _mapView.showsUserLocation = NO;
    }
}

- (void)segmentControlDidChangeValue:(UISegmentedControl *)sender {
    self.mapView.showsUserLocation = NO;
    NSUInteger selectedIndex = [_locationSegmentControl selectedSegmentIndex];
    switch (selectedIndex) {
        case 0:
            //设置定位模式为普通模式
            _mapView.userTrackingMode = BMKUserTrackingModeNone;
            break;
        case 1:
            //设置定位模式为定位跟随模式
            _mapView.userTrackingMode = BMKUserTrackingModeFollow;
            break;
        default:
            //设置定位模式为罗盘模式
            _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
            break;
    }
    
    self.mapView.showsUserLocation = YES;
}

#pragma mark - BMKLocationManagerDelegate
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error {
    NSLog(@"定位失败");
}
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateHeading:(CLHeading *)heading {
    if (!heading) {
        return;
    }
    NSLog(@"用户方向更新");
    
    self.userLocation.heading = heading;
    [_mapView updateLocationData:self.userLocation];
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
#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, kHeight_SegMentBackgroud, KScreenWidth, KScreenHeight - kViewTopHeight - kHeight_SegMentBackgroud - kHeight_BottomControlView - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}

-(UIView *)bottomControlView {
    if (!_bottomControlView) {
        _bottomControlView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - kViewTopHeight - kHeight_BottomControlView - KiPhoneXSafeAreaDValue, KScreenWidth, kHeight_BottomControlView)];
    }
    return _bottomControlView;
}

- (UISegmentedControl *)locationSegmentControl {
    if (!_locationSegmentControl) {
        NSArray *array = [[NSArray alloc] initWithObjects:@"普通模式",@"跟随模式",@"罗盘模式",nil];
        _locationSegmentControl = [[UISegmentedControl alloc] initWithItems:array];
        _locationSegmentControl.frame = CGRectMake(10 * widthScale, 12.5, 355 * widthScale, 35);
        [_locationSegmentControl setTitle:@"普通模式" forSegmentAtIndex:0];
        [_locationSegmentControl setTitle:@"跟随模式" forSegmentAtIndex:1];
        [_locationSegmentControl setTitle:@"罗盘模式" forSegmentAtIndex:2];
        _locationSegmentControl.selectedSegmentIndex = 0;
        [_locationSegmentControl addTarget:self action:@selector(segmentControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _locationSegmentControl;
}

- (UISwitch *)locationSwitch {
    if (!_locationSwitch) {
        _locationSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(125 * widthScale, 17, 48 * widthScale, 26)];
        [_locationSwitch addTarget:self action:@selector(switchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _locationSwitch;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(181 * widthScale, 20, 100 * widthScale, 20)];
        _locationLabel.textColor = COLOR(0x3385FF);
        _locationLabel.font = [UIFont systemFontOfSize:14];
        _locationLabel.text = @"定位";
    }
    return _locationLabel;
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
