//
//  GPUImageVideoCameraViewController.m
//  GPUImage
//
//  Created by duoyi on 16/10/26.
//  Copyright © 2016年 bt. All rights reserved.
//

#import "GPUImageVideoCameraViewController.h"
#import "GPUImage.h"
#import "GPUImageBeautifyFilter.h"

@interface GPUImageVideoCameraViewController ()

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageView *videoPreview;

@property (nonatomic, strong) UISwitch *beautiful;

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
    
    
    
    self.videoCamera = videoCamera;
    self.videoPreview = videoPreview;
    [self.view addSubview:self.beautiful];
    
    //GPUImageMovieWriter *write = [GPUImageMovieWriter alloc] initWithMovieURL:<#(NSURL *)#> size:<#(CGSize)#>
}

- (UISwitch *)beautiful
{
    if (!_beautiful)
    {
        _beautiful = [[UISwitch alloc] init];
        [_beautiful sizeToFit];
        _beautiful.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2);
        [_beautiful addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    }
    return _beautiful;
}

- (void)change:(UISwitch *)sw
{
    if(sw.on)
    {
        [_videoCamera removeAllTargets];
        GPUImageBeautifyFilter *fiter = [[GPUImageBeautifyFilter alloc] init];
        [_videoCamera addTarget:fiter];
        [fiter addTarget:self.videoPreview];
    }
    else
    {
        [_videoCamera removeAllTargets];
        [_videoCamera addTarget:self.videoPreview];
    }
}


@end
