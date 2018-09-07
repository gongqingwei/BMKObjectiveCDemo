//
//  BMKShowLimitMapRegionPage.m
//  IphoneMapSdkDemo
//
//  Created by Baidu RD on 2018/3/5.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKShowLimitMapRegionPage.h"

//开发者通过此delegate获取mapView的回调方法
@interface BMKShowLimitMapRegionPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@end

@implementation BMKShowLimitMapRegionPage

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
    self.title = @"限制地图显示范围";
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
    //设置中心点经纬度坐标
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(39.923018, 116.404440);
    //设置经纬度范围
    BMKCoordinateSpan span = BMKCoordinateSpanMake(0.013142, 0.011678);
    //限制地图的显示范围（地图状态改变时，该范围不会在地图显示范围外,设置成功后，会调整地图显示该范围)
    _mapView.limitMapRegion = BMKCoordinateRegionMake(center, span);
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}

@end
