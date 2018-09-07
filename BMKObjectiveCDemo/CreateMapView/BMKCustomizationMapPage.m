//
//  BMKCustomizationMapPage.m
//  IphoneMapSdkDemo
//
//  Created by Baidu RD on 2018/3/5.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKCustomizationMapPage.h"

//开发者通过此delegate获取mapView的回调方法
@interface BMKCustomizationMapPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *midnightMapView; //午夜蓝个性化地图
@end

@implementation BMKCustomizationMapPage

#pragma mark - Initialization method
+ (void)initialize {
    //获取个性化地图模板文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"custom_config_午夜蓝" ofType:@""];
    //设置个性化地图样式
    [BMKMapView customMapStyle:path];
}

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    //设置midnightMapView的代理
    _midnightMapView.delegate = self;
    //当midnightMapView即将被显示的时候调用，恢复之前存储的midnightMapView状态
    [_midnightMapView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    //当midnightMapView即将被隐藏的时候调用，存储当前midnightMapView的状态
    [_midnightMapView viewWillDisappear];
    //关闭个性化地图
    [BMKMapView enableCustomMapStyle:NO];
}

#pragma mark - Config UI
- (void)configUI {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"个性化地图";
}

- (void)createMapView {
    //将midnightMapView添加到当前视图中
    [self.view addSubview:self.midnightMapView];
    //开启个性化地图
    [BMKMapView enableCustomMapStyle:YES];
}

#pragma mark - Lazy loading
- (BMKMapView *)midnightMapView {
    if (!_midnightMapView) {
        _midnightMapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight)];
    }
    return _midnightMapView;
}

@end
