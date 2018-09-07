//
//  BMKAccuracyCirclePage.m
//  IphoneMapSdkDemo
//
//  Created by Baidu RD on 2018/3/6.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKAccuracyCirclePage.h"
#import <BMKLocationkit/BMKLocationComponent.h>

#define kHeight_BottomControlView 120
static NSUInteger enumValue = 0;

/**
 开发者可通过BMKMapViewDelegate获取mapView的回调方法,BMKLocationManagerDelegate
 获取locationManager的回调方法
 */
@interface BMKAccuracyCirclePage ()<BMKMapViewDelegate,BMKLocationManagerDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UIView *bottomControlView;
@property (nonatomic, strong) UISwitch *accruacySwitch;
@property (nonatomic, strong) UILabel *accruacyLabel;
@property (nonatomic, strong) UIButton *fillColorButton;
@property (nonatomic, strong) UIButton *strokeColorButton;
@property (nonatomic, strong) BMKLocationViewDisplayParam *param; //定位图层自定义样式参数
@property (nonatomic, strong) BMKLocationManager *locationManager; //定位对象
@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象
@end

@implementation BMKAccuracyCirclePage

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
    self.title = @"定位展示（自定义精度圈）";
    [self.view addSubview:self.bottomControlView];
    [self.bottomControlView addSubview:self.accruacySwitch];
    [self.bottomControlView addSubview:self.accruacyLabel];
    [self.bottomControlView addSubview:self.fillColorButton];
    [self.bottomControlView addSubview:self.strokeColorButton];
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
    //设置地图比例尺级别
    _mapView.zoomLevel = 21;
    //配置定位图层个性化样式，初始化BMKLocationViewDisplayParam的实例
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
    self.param = param;
}

#pragma mark - Responding events
- (void)switchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        //开启定位服务
        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];
        
        //设置显示定位图层
        _mapView.showsUserLocation = YES;
        //设置定位模式为普通模式
        _mapView.userTrackingMode = BMKUserTrackingModeNone;
        //设置定位图标(屏幕坐标)X轴偏移量为0
        _param.locationViewOffsetX = 0;
        //设置定位图标(屏幕坐标)Y轴偏移量为0
        _param.locationViewOffsetY = 0;
        //设置定位图层locationView在最上层(也可设置为在下层)
        _param.locationViewHierarchy = LOCATION_VIEW_HIERARCHY_TOP;
        //设置显示精度圈
        _param.isAccuracyCircleShow = YES;
        //更新定位图层个性化样式
        [_mapView updateLocationViewWithParam:_param];
    } else {
        //设置不显示精度圈
        _param.isAccuracyCircleShow = NO;
        //更新定位图层个性化样式
        [_mapView updateLocationViewWithParam:_param];
        //关闭定位服务
        [self.locationManager stopUpdatingLocation];
        [self.locationManager stopUpdatingHeading];
        //设置不显示定位图层
        _mapView.showsUserLocation = NO;
    }
}

- (void)clicKFillColorButton {
    NSArray *colors = @[COLOR(0xFFDAB9), COLOR(0xC1FFC1),COLOR(0xBFEFFF)];
    enumValue > 2 ? enumValue = 0 : enumValue;
    //设置精度圈填充颜色
    _param.accuracyCircleFillColor = colors[enumValue];
    //更新定位图层个性化样式
    [_mapView updateLocationViewWithParam:_param];
    enumValue ++;
}

- (void)clickStrokeColorButton {
    NSArray *colors = @[COLOR(0x663300), COLOR(0x336699), COLOR(0xEE2C2C)];
    enumValue > 2 ? enumValue = 0 : enumValue;
    //设置精度圈边框颜色
    _param.accuracyCircleStrokeColor = colors[enumValue];
    //更新定位图层个性化样式
    [_mapView updateLocationViewWithParam:_param];
    enumValue ++;
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
    //设置当前地图的中心点，改变该值时，地图的比例尺级别不会发生变化
    _mapView.centerCoordinate = self.userLocation.location.coordinate;
}
#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - kHeight_BottomControlView - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}

-(UIView *)bottomControlView{
    if (!_bottomControlView) {
        _bottomControlView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - kViewTopHeight - kHeight_BottomControlView - KiPhoneXSafeAreaDValue, KScreenWidth, kHeight_BottomControlView)];
    }
    return _bottomControlView;
}

- (UISwitch *)accruacySwitch {
    if (!_accruacySwitch) {
        _accruacySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(125 * widthScale, 17, 48 * widthScale, 26)];
        [_accruacySwitch addTarget:self action:@selector(switchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _accruacySwitch;
}

- (UILabel *)accruacyLabel {
    if (!_accruacyLabel) {
        _accruacyLabel = [[UILabel alloc] initWithFrame:CGRectMake(181 * widthScale, 20, 100 * widthScale, 20)];
        _accruacyLabel.textColor = COLOR(0x3385FF);
        _accruacyLabel.font = [UIFont systemFontOfSize:14];
        _accruacyLabel.text = @"精度圈";
    }
    return _accruacyLabel;
}

- (UIButton *)fillColorButton {
    if (!_fillColorButton) {
        _fillColorButton = [[UIButton alloc] initWithFrame:CGRectMake(19 * widthScale, 72.5, 159 * widthScale, 35)];
        [_fillColorButton addTarget:self action:@selector(clicKFillColorButton) forControlEvents:UIControlEventTouchUpInside];
        _fillColorButton.clipsToBounds = YES;
        _fillColorButton.layer.cornerRadius = 16;
        [_fillColorButton setTitle:@"切换填充颜色" forState:UIControlStateNormal];
        _fillColorButton.titleLabel.textColor = [UIColor whiteColor];
        _fillColorButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _fillColorButton.backgroundColor = COLOR(0x3385FF);
    }
    return _fillColorButton;
}

- (UIButton *)strokeColorButton {
    if (!_strokeColorButton) {
        _strokeColorButton = [[UIButton alloc] initWithFrame:CGRectMake(197 * widthScale, 72.5, 159 * widthScale, 35)];
        _strokeColorButton.clipsToBounds = YES;
        _strokeColorButton.layer.cornerRadius = 16;
        [_strokeColorButton addTarget:self action:@selector(clickStrokeColorButton) forControlEvents:UIControlEventTouchUpInside];
        [_strokeColorButton setTitle:@"切换边框颜色" forState:UIControlStateNormal];
        _strokeColorButton.titleLabel.textColor = [UIColor whiteColor];
        _strokeColorButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _strokeColorButton.backgroundColor = COLOR(0x3385FF);
    }
    return _strokeColorButton;
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
