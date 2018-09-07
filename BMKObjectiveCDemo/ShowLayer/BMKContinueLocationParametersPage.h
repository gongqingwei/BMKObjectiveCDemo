//
//  BMKContinueLocationParametersPage.h
//  IphoneMapSdkDemo
//
//  Created by Baidu RD on 2018/7/23.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BMKLocationkit/BMKLocationComponent.h>

@interface BMKContinueLocationParametersPage : UIViewController
@property (nonatomic, copy) void (^setupContinueLocationBlock)(BMKLocationManager *locationManager);
@end
