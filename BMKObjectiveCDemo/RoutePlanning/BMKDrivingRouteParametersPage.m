//
//  BMKDrivingRouteParametersPage.m
//  IphoneMapSdkDemo
//
//  Created by Baidu RD on 2018/7/9.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKDrivingRouteParametersPage.h"
#import "BMKDrivingPolicyParametersPage.h"

@interface BMKDrivingRouteParametersPage ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *fromCityNameLabel;
@property (nonatomic, strong) UILabel *fromCityIDLabel;
@property (nonatomic, strong) UILabel *fromLatitudeLabel;
@property (nonatomic, strong) UILabel *fromLongitudeLabel;
@property (nonatomic, strong) UILabel *fromNameLabel;
@property (nonatomic, strong) UILabel *toCityNameLabel;
@property (nonatomic, strong) UILabel *toCityIDLabel;
@property (nonatomic, strong) UILabel *toLatitudeLabel;
@property (nonatomic, strong) UILabel *toLongitudeLabel;
@property (nonatomic, strong) UILabel *toNameLabel;
@property (nonatomic, strong) UITextField *fromCityNameTextField;
@property (nonatomic, strong) UITextField *fromCityIDTextField;
@property (nonatomic, strong) UITextField *fromLatitudeTextField;
@property (nonatomic, strong) UITextField *fromLongitudeTextField;
@property (nonatomic, strong) UITextField *fromNameTextField;
@property (nonatomic, strong) UITextField *toCityNameTextField;
@property (nonatomic, strong) UITextField *toCityIDTextField;
@property (nonatomic, strong) UITextField *toLatitudeTextField;
@property (nonatomic, strong) UITextField *toLongitudeTextField;
@property (nonatomic, strong) UITextField *toNameTextField;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *drivingPolicyButton;
@property (nonatomic, strong) BMKDrivingRoutePlanOption *drivingRoutePlanOption;
@end

@implementation BMKDrivingRouteParametersPage

#pragma mark - Initialization method
- (instancetype)init {
    self = [super init];
    if (self) {
        _drivingRoutePlanOption = [[BMKDrivingRoutePlanOption alloc] init];
    }
    return self;
}

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self setupTextFieldDelegate];
}

#pragma mark - Config UI
- (void)configUI {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView addSubview:self.fromCityIDLabel];
    [self.backgroundScrollView addSubview:self.fromCityNameLabel];
    [self.backgroundScrollView addSubview:self.fromLatitudeLabel];
    [self.backgroundScrollView addSubview:self.fromLongitudeLabel];
    [self.backgroundScrollView addSubview:self.toCityIDLabel];
    [self.backgroundScrollView addSubview:self.toCityNameLabel];
    [self.backgroundScrollView addSubview:self.toLatitudeLabel];
    [self.backgroundScrollView addSubview:self.toLongitudeLabel];
    [self.backgroundScrollView addSubview:self.fromLatitudeTextField];
    [self.backgroundScrollView addSubview:self.fromLongitudeTextField];
    [self.backgroundScrollView addSubview:self.fromCityIDTextField];
    [self.backgroundScrollView addSubview:self.fromCityNameTextField];
    [self.backgroundScrollView addSubview:self.toCityIDTextField];
    [self.backgroundScrollView addSubview:self.toCityNameTextField];
    [self.backgroundScrollView addSubview:self.toLatitudeTextField];
    [self.backgroundScrollView addSubview:self.toLongitudeTextField];
    [self.backgroundScrollView addSubview:self.fromNameLabel];
    [self.backgroundScrollView addSubview:self.fromNameTextField];
    [self.backgroundScrollView addSubview:self.toNameLabel];
    [self.backgroundScrollView addSubview:self.toNameTextField];
    [self.backgroundScrollView addSubview:self.searchButton];
    [self.backgroundScrollView addSubview:self.drivingPolicyButton];
}

#pragma mark - UITextFieldDelegate
- (void)setupTextFieldDelegate {
    _fromCityIDTextField.delegate = self;
    _fromCityNameTextField.delegate = self;
    _fromLatitudeTextField.delegate = self;
    _fromLongitudeTextField.delegate = self;
    _toCityIDTextField.delegate = self;
    _toCityNameTextField.delegate = self;
    _toLatitudeTextField.delegate = self;
    _toLongitudeTextField.delegate = self;
    _fromNameTextField.delegate = self;
    _toNameTextField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_toLatitudeTextField] || [textField isEqual:_toLongitudeTextField] || [textField isEqual:_toCityIDTextField]) {
        [UIView animateWithDuration:0.5 animations:^{
            _backgroundScrollView.contentOffset = CGPointMake(0, 630);
        }];
    }
    return YES;
}

#pragma mark - Responding events
- (void)clickSearchButton {
    [self.navigationController popViewControllerAnimated:YES];
    [self setupDrivingRoutePlanOption];
    if (self.searchDataBlock) {
        self.searchDataBlock(_drivingRoutePlanOption);
    }
}

- (void)clickDrivingPolicyButton {
    BMKDrivingPolicyParametersPage *page = [[BMKDrivingPolicyParametersPage alloc]  init];
    page.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    page.policyDataBlock = ^(BMKDrivingRoutePlanOption *option) {
        _drivingRoutePlanOption.drivingPolicy = option.drivingPolicy;
        _drivingRoutePlanOption.drivingRequestTrafficType = option.drivingRequestTrafficType;
    };
    [self.navigationController pushViewController:page animated:YES];
}

- (void)setupDrivingRoutePlanOption {
    BMKPlanNode *fromNode = [[BMKPlanNode alloc] init];
    fromNode.cityID = [_fromCityIDTextField.text integerValue];
    fromNode.cityName = _fromCityNameTextField.text;
    fromNode.name = _fromNameTextField.text;
    fromNode.pt = CLLocationCoordinate2DMake([_fromLatitudeTextField.text floatValue], [_fromLongitudeTextField.text floatValue]);
    
    BMKPlanNode *toNode = [[BMKPlanNode alloc] init];
    toNode.cityID = [_toCityIDTextField.text integerValue];
    toNode.cityName = _toCityNameTextField.text;
    toNode.pt = CLLocationCoordinate2DMake([_toLatitudeTextField.text floatValue], [_toLongitudeTextField.text floatValue]);
    toNode.name =  _toNameTextField.text;
    
    _drivingRoutePlanOption.from = fromNode;
    _drivingRoutePlanOption.to = toNode;
    //fix-me waypointarray
}

#pragma mark - Lazy loading
- (UIScrollView *)backgroundScrollView {
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
        _backgroundScrollView.contentSize = CGSizeMake(KScreenWidth, 900 + 100);
    }
    return _backgroundScrollView;
}

- (UILabel *)fromNameLabel {
    if (!_fromNameLabel) {
        _fromNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, KScreenWidth - 20, 30)];
        _fromNameLabel.font = [UIFont systemFontOfSize:17];
        _fromNameLabel.text = @"起点关键字（必选，关键字和坐标二选一）";
    }
    return _fromNameLabel;
}

- (UILabel *)fromCityNameLabel {
    if (!_fromCityNameLabel) {
        _fromCityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, KScreenWidth - 20, 30)];
        _fromCityNameLabel.font = [UIFont systemFontOfSize:17];
        _fromCityNameLabel.text = @"起点城市（必选，城市和城市ID二选一）";
    }
    return _fromCityNameLabel;
}

- (UILabel *)fromLatitudeLabel {
    if (!_fromLatitudeLabel) {
        _fromLatitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, KScreenWidth - 20, 30)];
        _fromLatitudeLabel.font = [UIFont systemFontOfSize:17];
        _fromLatitudeLabel.text = @"起点纬度";
    }
    return _fromLatitudeLabel;
}

- (UILabel *)fromLongitudeLabel {
    if (!_fromLongitudeLabel) {
        _fromLongitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 290, KScreenWidth - 20, 30)];
        _fromLongitudeLabel.font = [UIFont systemFontOfSize:17];
        _fromLongitudeLabel.text = @"起点经度";
    }
    return _fromLongitudeLabel;
}

- (UILabel *)fromCityIDLabel {
    if (!_fromCityIDLabel) {
        _fromCityIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 380, KScreenWidth - 20, 30)];
        _fromCityIDLabel.font = [UIFont systemFontOfSize:17];
        _fromCityIDLabel.text = @"起点城市ID";
    }
    return _fromCityIDLabel;
}

- (UILabel *)toNameLabel {
    if (!_toNameLabel) {
        _toNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 470, KScreenWidth - 20, 30)];
        _toNameLabel.font = [UIFont systemFontOfSize:17];
        _toNameLabel.text = @"终点关键字（必选，关键字和坐标二选一）";
    }
    return _toNameLabel;
}

- (UILabel *)toCityNameLabel {
    if (!_toCityNameLabel) {
        _toCityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 560, KScreenWidth - 20, 30)];
        _toCityNameLabel.text = @"终点城市（必选，城市和城市ID二选一）";
        _toCityNameLabel.font = [UIFont systemFontOfSize:17];
    }
    return _toCityNameLabel;
}

- (UILabel *)toLatitudeLabel {
    if (!_toLatitudeLabel) {
        _toLatitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 650, KScreenWidth - 20, 30)];
        _toLatitudeLabel.font = [UIFont systemFontOfSize:17];
        _toLatitudeLabel.text = @"终点纬度";
    }
    return _toLatitudeLabel;
}

- (UILabel *)toLongitudeLabel {
    if (!_toLongitudeLabel) {
        _toLongitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 740, KScreenWidth - 20, 30)];
        _toLongitudeLabel.font = [UIFont systemFontOfSize:17];
        _toLongitudeLabel.text = @"终点经度";
    }
    return _toLongitudeLabel;
}

- (UILabel *)toCityIDLabel {
    if (!_toCityIDLabel) {
        _toCityIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 830, KScreenWidth - 20, 30)];
        _toCityIDLabel.text = @"终点城市ID";
        _toCityIDLabel.font = [UIFont systemFontOfSize:17];
    }
    return _toCityIDLabel;
}

- (UITextField *)fromNameTextField {
    if (!_fromNameTextField) {
        _fromNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 55, KScreenWidth - 40, 35)];
        _fromNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _fromNameTextField;
}

- (UITextField *)fromCityNameTextField {
    if (!_fromCityNameTextField) {
        _fromCityNameTextField  = [[UITextField alloc] initWithFrame:CGRectMake(20, 145, KScreenWidth - 40, 35)];
        _fromCityNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _fromCityNameTextField;
}

- (UITextField *)fromLatitudeTextField {
    if (!_fromLatitudeTextField) {
        _fromLatitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 235, KScreenWidth - 40, 35)];
        _fromLatitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _fromLatitudeTextField;
}

- (UITextField *)fromLongitudeTextField {
    if (!_fromLongitudeTextField) {
        _fromLongitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 325, KScreenWidth - 40, 35)];
        _fromLongitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _fromLongitudeTextField;
}

- (UITextField *)fromCityIDTextField {
    if (!_fromCityIDTextField) {
        _fromCityIDTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 415, KScreenWidth - 40, 35)];
        _fromCityIDTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _fromCityIDTextField;
}

- (UITextField *)toNameTextField {
    if (!_toNameTextField) {
        _toNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 505, KScreenWidth - 40, 35)];
        _toNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _toNameTextField;
}

- (UITextField *)toCityNameTextField {
    if (!_toCityNameTextField) {
        _toCityNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 595, KScreenWidth - 40, 35)];
        _toCityNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _toCityNameTextField;
}

- (UITextField *)toLatitudeTextField {
    if (!_toLatitudeTextField) {
        _toLatitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 685, KScreenWidth - 40, 35)];
        _toLatitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _toLatitudeTextField;
}

- (UITextField *)toLongitudeTextField {
    if (!_toLongitudeTextField) {
        _toLongitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 775, KScreenWidth - 40, 35)];
        _toLongitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _toLongitudeTextField;
}

- (UITextField *)toCityIDTextField {
    if (!_toCityIDTextField) {
        _toCityIDTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 865, KScreenWidth - 40, 35)];
        _toCityIDTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _toCityIDTextField;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(197 * widthScale, 930, 159 * widthScale, 35)];
        [_searchButton addTarget:self action:@selector(clickSearchButton) forControlEvents:UIControlEventTouchUpInside];
        _searchButton.clipsToBounds = YES;
        _searchButton.layer.cornerRadius = 16;
        [_searchButton setTitle:@"检索数据" forState:UIControlStateNormal];
        _searchButton.titleLabel.textColor = [UIColor whiteColor];
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _searchButton.backgroundColor = COLOR(0x3385FF);
    }
    return _searchButton;
}

- (UIButton *)drivingPolicyButton {
    if (!_drivingPolicyButton) {
        _drivingPolicyButton = [[UIButton alloc] initWithFrame:CGRectMake(19 * widthScale, 930, 159 * widthScale, 35)];
        [_drivingPolicyButton addTarget:self action:@selector(clickDrivingPolicyButton) forControlEvents:UIControlEventTouchUpInside];
        _drivingPolicyButton.clipsToBounds = YES;
        _drivingPolicyButton.layer.cornerRadius = 16;
        [_drivingPolicyButton setTitle:@"设置驾车策略参数" forState:UIControlStateNormal];
        _drivingPolicyButton.titleLabel.textColor = [UIColor whiteColor];
        _drivingPolicyButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _drivingPolicyButton.backgroundColor = COLOR(0x3385FF);
    }
    return _drivingPolicyButton;
}

@end
