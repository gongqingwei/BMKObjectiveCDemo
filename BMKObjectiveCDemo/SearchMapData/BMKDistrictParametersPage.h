//
//  BMKDistrictParametersPage.h
//  IphoneMapSdkDemo
//
//  Created by Baidu RD on 2018/7/4.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMKDistrictParametersPage : UIViewController
@property (nonatomic, copy) void (^searchDataBlock)(BMKDistrictSearchOption *option);
@end
