//
//  ImageViewController.m
//  捕获音视屏
//
//  Created by duoyi on 16/10/25.
//  Copyright © 2016年 bt. All rights reserved.
//

#import "ImageViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface ImageViewController ()

@property (nonatomic, strong) AVCaptureDevice *videoDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutPut;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, strong) UIButton *button;

@end

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.button];
    
    // 3. 添加device到session
    if ([self.captureSession canAddInput:self.videoDeviceInput])
    {
        [self.captureSession addInput:self.videoDeviceInput];
    }
    
    //4. 添加预览层
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    //5. 启动会话
    [self.captureSession startRunning];

}
#pragma mark - Void
- (void)click
{
    AVCaptureConnection *stillImageConnection = [self.imageOutPut connectionWithMediaType:AVMediaTypeVideo];
    
    [self.imageOutPut captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (!imageDataSampleBuffer)
        {
            return ;
        }
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
        // 请求访问相册
        PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
        if (authorStatus == PHAuthorizationStatusAuthorized)
        {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success)
                {
                    NSLog(@"保存完成");
                }
                
            }];
        }else
        {
            // 没有访问相册权限
            NSLog(@"没有相册访问权限");
        }
    }];
    
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

- (AVCaptureStillImageOutput *)imageOutPut
{
    if (!_imageOutPut)
    {
        _imageOutPut = [[AVCaptureStillImageOutput alloc] init];
        _imageOutPut.outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
        if ([self.captureSession canAddOutput:_imageOutPut])
        {
            [_captureSession addOutput:_imageOutPut];
        }
    }
    return _imageOutPut;
}

- (UIButton *)button
{
    if (!_button)
    {
        _button = [[UIButton alloc] init];
        [_button setTitle:@"拍摄" forState:UIControlStateNormal];
        [_button sizeToFit];
        _button.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2);
        [_button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end
