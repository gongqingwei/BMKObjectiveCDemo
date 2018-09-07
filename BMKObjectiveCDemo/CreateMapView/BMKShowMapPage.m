//
//  BMKShowMapPage.m
//  IphoneMapSdkDemo
//
//  Created by Baidu RD on 2018/3/5.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKShowMapPage.h"

#define kHeight_SegMentBackgroud  60
#define kHeight_BottomControlView  60

//开发者通过此delegate获取mapView的回调方法
@interface BMKShowMapPage ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) UISegmentedControl *mapSegmentControl;
@property (nonatomic, strong) UIView *bottomControlView;
@property (nonatomic, strong) UISwitch *customizationMapSwitch;
@property (nonatomic, strong) UILabel *customizationMapLabel;
@end

@implementation BMKShowMapPage

#pragma mark - Initialization method
+ (void)initialize {
    //获取个性化地图模板文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"custom_config_清新蓝" ofType:@""];
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
    //当mapView即将被显示的时候调用，恢复之前存储的mapView状态
    [_mapView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    //当mapView即将被隐藏的时候调用，存储当前mapView的状态
    [_mapView viewWillDisappear];
    //关闭个性化地图样式
    [BMKMapView enableCustomMapStyle:NO];
}

#pragma mark - Config UI
- (void)configUI {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"显示地图";
    [self.view addSubview:self.mapSegmentControl];
    [self.view addSubview:self.bottomControlView];
    [self.bottomControlView addSubview:self.customizationMapSwitch];
    [self.bottomControlView addSubview:self.customizationMapLabel];
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

#pragma mark - Responding events
- (void)segmentControlDidChangeValue:(id)sender {
    NSUInteger selectedIndex = [_mapSegmentControl selectedSegmentIndex];
    switch (selectedIndex) {
        case 1:
            //设置当前地图类型为卫星地图
            [_mapView setMapType:BMKMapTypeSatellite];
            break;
        case 2:
            //设置当前地图类型为空白地图
            [_mapView setMapType:BMKMapTypeNone];
            break;
        default:
            //设置当前地图类型为标准地图
            [_mapView setMapType:BMKMapTypeStandard];
            break;
    }
}

- (void)switchDidChangeValue:(UISwitch *)sender {
    if (sender.on == YES) {
        //开启个性化地图样式
        [BMKMapView enableCustomMapStyle:YES];
    } else {
        //关闭个性化地图样式
        [BMKMapView enableCustomMapStyle:NO];
    }
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, kHeight_SegMentBackgroud, KScreenWidth, KScreenHeight-kViewTopHeight - kHeight_SegMentBackgroud - kHeight_BottomControlView - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}

- (UISegmentedControl *)mapSegmentControl {
    if (!_mapSegmentControl) {
        NSArray *array = [[NSArray alloc] initWithObjects:@"标准地图",@"卫星地图",@"空白地图",nil];
        _mapSegmentControl = [[UISegmentedControl alloc] initWithItems:array];
        _mapSegmentControl.frame = CGRectMake(10 * widthScale, 12.5, 355 * widthScale, 35);
        [_mapSegmentControl setTitle:@"标准地图" forSegmentAtIndex:0];
        [_mapSegmentControl setTitle:@"卫星地图" forSegmentAtIndex:1];
        [_mapSegmentControl setTitle:@"空白地图" forSegmentAtIndex:2];
        _mapSegmentControl.selectedSegmentIndex = 0;
        [_mapSegmentControl addTarget:self action:@selector(segmentControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _mapSegmentControl;
}

-(UIView *)bottomControlView{
    if (!_bottomControlView) {
        _bottomControlView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - kViewTopHeight - kHeight_BottomControlView - KiPhoneXSafeAreaDValue, KScreenWidth, kHeight_BottomControlView)];
    }
    return _bottomControlView;
}

- (UISwitch *)customizationMapSwitch {
    if (!_customizationMapSwitch) {
        _customizationMapSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(125 * widthScale, 17, 48 * widthScale, 26)];
        [_customizationMapSwitch addTarget:self action:@selector(switchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _customizationMapSwitch;
}

- (UILabel *)customizationMapLabel {
    if (!_customizationMapLabel) {
        _customizationMapLabel = [[UILabel alloc] initWithFrame:CGRectMake(181 * widthScale, 20, 100 * widthScale, 20)];
        _customizationMapLabel.textColor = COLOR(0x3385FF);
        _customizationMapLabel.font = [UIFont systemFontOfSize:14];
        _customizationMapLabel.text = @"个性化地图";
    }
    return _customizationMapLabel;
}

@end
