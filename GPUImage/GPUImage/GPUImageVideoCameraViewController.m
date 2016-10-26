//
//  GPUImageVideoCameraViewController.m
//  GPUImage
//
//  Created by duoyi on 16/10/26.
//  Copyright © 2016年 bt. All rights reserved.
//

#import "GPUImageVideoCameraViewController.h"
#import "GPUImage.h"

@interface GPUImageVideoCameraViewController ()

@property (nonatomic, strong) UISwitch *rightSwitch;

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageView *videoPreview;

@end

@implementation GPUImageVideoCameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 创建视频源
    GPUImageVideoCamera *videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    // 创建预览View
    GPUImageView *videoPreview = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:videoPreview atIndex:0];
    
    // 添加预览图层到源
    [videoCamera addTarget:videoPreview];
    // 开始采集视频
    [videoCamera startCameraCapture];
    
    [self.view addSubview:self.rightSwitch];
    self.videoCamera = videoCamera;
    self.videoPreview = videoPreview;
}

- (UISwitch *)rightSwitch
{
    if (!_rightSwitch)
    {
        _rightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 50, 100, 30, 20)];
        [_rightSwitch addTarget:self action:@selector(buttonOn:) forControlEvents:UIControlEventValueChanged];
    }
    return _rightSwitch;
}

- (void)buttonOn:(UISwitch *)rightSwitch
{
    if (rightSwitch.on)
    {

        // 创建滤镜组
        /**
         原理：
         1. filterGroup(addFilter) 滤镜组添加每个滤镜
         2. 按添加顺序（可自行调整）前一个filter(addTarget) 添加后一个filter
         3. filterGroup.initialFilters = @[第一个filter]];
         4. filterGroup.terminalFilter = 最后一个filter;
         
         */
        
        GPUImageFilterGroup *groupFilter = [[GPUImageFilterGroup alloc] init];
        // 磨皮滤镜
        GPUImageBilateralFilter *bilateralFilter = [[GPUImageBilateralFilter alloc] init];
        [groupFilter addFilter:bilateralFilter];
        // 美白滤镜
        GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
        [groupFilter addFilter:brightnessFilter];
        
        [bilateralFilter addTarget:brightnessFilter];
        [groupFilter setInitialFilters:@[bilateralFilter]];
        
//         // 设置GPUImage响应链，从数据源 => 滤镜 => 最终界面效果
//        [_videoCamera addTarget:groupFilter];
//        [groupFilter addTarget:_videoPreview];
//      //  [_videoCamera startCameraCapture];
    }
    else
    {
        [_videoCamera removeAllTargets];
        [_videoCamera addTarget:_videoPreview];
    }
}


@end
