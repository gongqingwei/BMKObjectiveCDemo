//
//  ZLAdvertView.h
//  BMKObjectiveCDemo
//
//  Created by iphone on 2018/9/7.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kscreenWidth [UIScreen mainScreen].bounds.size.width
#define kscreenHeight [UIScreen mainScreen].bounds.size.height
#define kUserDefaults [NSUserDefaults standardUserDefaults]
static NSString *const adImageName = @"adImageName";
static NSString *const adUrl = @"adUrl";

@interface ZLAdvertView : UIView

/**
 *  显示广告页面方法
 */
- (void)show;

/**
 *  图片路径
 */
@property (nonatomic, copy) NSString *filePath;

@end
