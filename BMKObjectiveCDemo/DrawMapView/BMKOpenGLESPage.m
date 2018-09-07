//
//  BMKOpenGLESPage.m
//  IphoneMapSdkDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKOpenGLESPage.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#define MAX_SIZE 1024

char vssource[] =
"precision mediump float;\n"
"attribute vec4 aPosition;\n"
"void main() {\n"
"    gl_Position = aPosition;\n"
"}\n";

char fssource[] =
"precision mediump float;\n"
"void main() {\n"
"    gl_FragColor = vec4(1.0, 0.0, 0.0, 0.5);\n"
"}\n";

typedef struct {
    GLfloat x;
    GLfloat y;
} GLPoint; 
//开发者通过此delegate获取mapView的回调方法
@interface BMKOpenGLESPage ()<BMKMapViewDelegate>
{
    BMKMapPoint mapPoints[4];
    GLPoint glPoint[4];
}
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, assign) BOOL mapDidFinishLoad; //地图是否加载完成
@property (nonatomic, assign) BOOL glshaderLoaded;
@property (nonatomic, assign) GLint aLocPos;
@property (nonatomic, assign) GLuint program;
@end

@implementation BMKOpenGLESPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
}

- (void)viewWillAppear:(BOOL)animated {
    //当mapView即将被显示的时候调用，恢复之前存储的mapView状态
    [_mapView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    //当mapView即将被隐藏的时候调用，存储当前mapView的状态
    [_mapView viewWillDisappear];
}

#pragma mark - Config UI
- (void)configUI {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"OpenGL ES绘制";
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
}

#pragma mark - OpenGL ES
/**
 绘制方法(子类需要重载来实现)
 */
- (void)glRender:(BMKMapStatus *)status {
    if (_glshaderLoaded == NO) {
        _glshaderLoaded = [self loadShaders:vssource fragsource:fssource program:&_program];
    }
    BMKMapRect mapRect = _mapView.visibleMapRect;
    for (NSUInteger i = 0; i < 4; i ++) {
        CGPoint tempPt = [_mapView glPointForMapPoint:mapPoints[i]];
        glPoint[i].x = tempPt.x * 2 / mapRect.size.width;
        glPoint[i].y = tempPt.y * 2 / mapRect.size.height;
    }
    
    glUseProgram(_program);
    glEnableVertexAttribArray(_aLocPos);
    glVertexAttribPointer(_aLocPos, 2, GL_FLOAT, 0, 0, glPoint);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    glDisableVertexAttribArray(_aLocPos);
}

- (BOOL)loadShaders:(char *)vssource fragsource:(char *)fssource program:(GLuint *)prog {
    GLuint vs = glCreateShader(GL_VERTEX_SHADER);
    GLuint fs = glCreateShader(GL_FRAGMENT_SHADER);
    if (!prog) {
        return NO;
    }
    if (!(vs && fs)) {
        NSLog(@"Create Shader failed");
        return NO;
    }
    if (![self compileShader:vssource shader:vs]) {
        return NO;
    }
    if (![self compileShader:fssource shader:fs]) {
        return NO;
    }
    *prog = glCreateProgram();
    if (!(*prog)) {
        NSLog(@"Create program failed");
        return NO;
    }
    glAttachShader(*prog, vs);
    glAttachShader(*prog, fs);
    glLinkProgram(*prog);
    GLint linked = 0;
    glGetProgramiv(*prog, GL_LINK_STATUS, &linked);
    _aLocPos = glGetAttribLocation(_program, "aPosition");
    if(!linked) {
        NSLog(@"Link program failed");
        return NO;
    }
    return YES;
}

-(BOOL)compileShader:(char *)shadersource shader:(GLuint)shader
{
    glShaderSource(shader, 1, (const char**)&shadersource, NULL);
    glCompileShader(shader);
    GLint compiled = 0;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    if(!compiled) {
        int length = MAX_SIZE;
        char log[MAX_SIZE] = {0};
        glGetShaderInfoLog(shader, length, &length, log);
        NSLog(@"Shader compile failed");
        NSLog(@"log: %@", [NSString stringWithUTF8String:log]);
        return NO;
    }
    return YES;
}

#pragma mark - BMKMapViewDelegate
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    /**
     将经纬度坐标转换为投影后的直角地理坐标
     
     @param coordinate 待转换的经纬度坐标
     @return 转换后的直角地理坐标
     */
    mapPoints[0] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.965, 116.604));
    mapPoints[1] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.865, 116.604));
    mapPoints[2] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.865, 116.704));
    mapPoints[3] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.965, 116.704));
    _mapDidFinishLoad = YES;
    [self glRender:[mapView getMapStatus]];
    /**
     强制刷新mapview
     */
    [mapView mapForceRefresh];
}

/**
 地图渲染每一帧画面过程中，以及每次需要重新绘制地图时(例如添加覆盖物)都会调用此方法
 
 @param mapView 地图View
 @param status 地图的状态
 */
- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status {
    if (_mapDidFinishLoad) {
        [self glRender:status];
    }
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}

@end
