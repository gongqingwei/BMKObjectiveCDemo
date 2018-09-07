//
//  BMKBaiduMapTransitRoutePage.m
//  IphoneMapSdkDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKBaiduMapTransitRoutePage.h"

//开发者通过此delegate获取mapView的回调方法
@interface BMKBaiduMapTransitRoutePage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@end

@implementation BMKBaiduMapTransitRoutePage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
    [self openBaiduMapTransitRoute];
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
    self.title = @"百度地图-公交路线规划";
}

#pragma mark - BaiduMapRoute
- (void)openBaiduMapTransitRoute {
    //初始化调起百度地图公交路线时传入的参数
    BMKOpenTransitRouteOption *option = [[BMKOpenTransitRouteOption alloc] init];
    //公交策略，默认：BMK_OPEN_TRANSIT_RECOMMAND(异常值，强制使用BMK_OPEN_TRANSIT_RECOMMAND)
    option.openTransitPolicy = BMK_OPEN_TRANSIT_RECOMMAND;
    //指定返回自定义scheme
    option.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    //调起百度地图客户端失败后，是否支持调起web地图，默认：YES
    option.isSupportWeb = YES;
    //实例化线路检索节点信息类对象
    BMKPlanNode *start = [[BMKPlanNode alloc]init];
    //指定起点名称
    start.name = @"西直门";
    //指定起点经纬度
    start.pt = CLLocationCoordinate2DMake(39.90868, 116.204);
    //指定起点
    option.startPoint = start;
    //实例化线路检索节点信息类对象
    BMKPlanNode *end = [[BMKPlanNode alloc]init];
    //指定终点名称
    end.pt = CLLocationCoordinate2DMake(39.90868, 116.3956);
    //终点名称
    end.name = @"天安门";
    //终点节点
    option.endPoint = end;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"打开百度地图客户端" message:@"百度地图-公交路径规划" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        /**
         调起百度地图客户端公交路线界面
         
         @param para 调起公交路线时传入的参数
         @return 结果状态码
         */
        [BMKOpenRoute openBaiduMapTransitRoute:option];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:openAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}

@end
