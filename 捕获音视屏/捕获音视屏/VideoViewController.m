//
//  VideoViewController.m
//  捕获音视屏
//
//  Created by duoyi on 16/10/25.
//  Copyright © 2016年 bt. All rights reserved.
//

#import "VideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "NSObject+HUD.h"

@interface VideoViewController ()<AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) AVCaptureDevice *videoDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) AVCaptureMovieFileOutput *videoOutput;

@end

@implementation VideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.button];
    
    
    if ([self.captureSession canAddInput:self.videoDeviceInput])
    {
        [self.captureSession addInput:self.videoDeviceInput];
    }
    if ([self.captureSession canAddOutput:self.videoOutput])
    {
        [self.captureSession addOutput:self.videoOutput];
    }
    
    [self.view.layer insertSublayer:self.preview atIndex:0];
    [self.captureSession startRunning];
}

#pragma mark - 懒加载
// 1. 创建device
- (AVCaptureDevice *)videoDevice
{
    if (!_videoDevice) // 这里可以设置闪光灯 曝光 白平衡等
    {
        _videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _videoDevice;
}

// 2. 根据device创建deviceInput
- (AVCaptureDeviceInput *)videoDeviceInput
{
    if (!_videoDeviceInput)
    {
        _videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:nil];
    }
    return _videoDeviceInput;
}

- (AVCaptureSession *)captureSession
{
    if (!_captureSession)
    {
        _captureSession = [[AVCaptureSession alloc] init];
        [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    }
    return _captureSession;
}

- (AVCaptureVideoPreviewLayer *)preview
{
    if (!_preview)
    {
        _preview = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
        _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _preview.frame = self.view.layer.bounds;
    }
    return _preview;
}

- (UIButton *)button
{
    if (!_button)
    {
        _button = [[UIButton alloc] init];
        [_button setTitle:@"开始录制" forState:UIControlStateNormal];
        [_button sizeToFit];
        _button.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2);
        [_button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
- (AVCaptureMovieFileOutput *)videoOutput
{
    if (!_videoOutput)
    {
        _videoOutput = [[AVCaptureMovieFileOutput alloc] init];
    }
    return _videoOutput;
}

- (void)click
{
    if ([self.button.titleLabel.text isEqualToString:@"开始录制"])
    {
        [self.button setTitle:@"停止录制" forState:UIControlStateNormal];
        AVCaptureConnection *videoConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([videoConnection isVideoStabilizationSupported])
        {
            // 提升视频稳定性
            videoConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeStandard;
        }
        // 平滑对焦没设置 方向没设置
        // 配置写到指定文件
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSURL *url = [NSURL fileURLWithPath:[path stringByAppendingPathComponent:@"a.mp4"]];
        
        [self.videoOutput startRecordingToOutputFileURL:url recordingDelegate:self];
    }
    else
    {
        [self.videoOutput stopRecording];
        [self.button setTitle:@"开始录制" forState:UIControlStateNormal];
    }
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    //写入捕捉到的视频
    if (error)
    {
        [self showInfo:@"视频录制出错"];
    }
    else
    {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{

            [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:outputFileURL];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
            [self showInfo:@"保存成功"];
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSFileManager *manager = [NSFileManager defaultManager];
            if (![manager fileExistsAtPath:[path stringByAppendingPathComponent:@"a.mp4"]])
            {
                NSLog(@"文件不存在");
            }
            else
            {
                NSLog(@"文件存在");
            }
        }];
    }
}


@end
