//
//  ZLAdvertViewController.m
//  BMKObjectiveCDemo
//
//  Created by iphone on 2018/9/7.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "ZLAdvertViewController.h"

@interface ZLAdvertViewController ()
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation ZLAdvertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"点击进入广告链接";
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.backgroundColor = [UIColor whiteColor];
    
    if (!self.adUrl) {
        self.adUrl = @"https://www.baidu.com";
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.adUrl]];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
}
- (void)setAdUrl:(NSString *)adUrl {
    _adUrl = adUrl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
