//
//  ViewController.m
//  捕获音视屏
//
//  Created by duoyi on 16/10/24.
//  Copyright © 2016年 bt. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface ViewController ()<AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

// 捕捉会话
@property (nonatomic, strong) AVCaptureSession *captureSession;
// 获取视频设备
@property (nonatomic, strong) AVCaptureDevice *videoDevice;
// 获取音频设备
@property (nonatomic, strong) AVCaptureDevice *audioDevice;
// 视频输入对象
@property (nonatomic, strong) AVCaptureDeviceInput *videoDeviceInput;
// 音频输入对象
@property (nonatomic, strong) AVCaptureDeviceInput *audioDeviceInput;
// 获取视频输出设备
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
// 获取音频输出设备
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioOutput;
// 预览视图
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, strong) AVCaptureConnection *audioConnection;
@property (nonatomic, strong) AVCaptureConnection *videoConnection;

@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutPut;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self request];
    
    //6. 添加视频，音频到会话，最好判断一下
    if ([self.captureSession canAddInput:self.videoDeviceInput])
    {
        [_captureSession addInput:_videoDeviceInput];
    }
    
    if ([self.captureSession canAddInput:self.audioDeviceInput])
    {
        [_captureSession addInput:_audioDeviceInput];
    }
    
    //9.获取视频输入与输出连接，用于分辨音视频数据
//    self.videoConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
//    self.audioConnection = [self.audioOutput connectionWithMediaType:AVMediaTypeAudio];
    
    //10. 添加视频预览图层、
    [self.view.layer insertSublayer:self.preview atIndex:0];
    //11. 启动会话
    [_captureSession startRunning];
}

#pragma mark - 懒加载
//1. 创建捕捉会话
- (AVCaptureSession *)captureSession
{
    if (!_captureSession)
    {
        _captureSession = [[AVCaptureSession alloc] init];
        [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    }
    return _captureSession;
}

//2. 获取摄像头，默认是后置
- (AVCaptureDevice *)videoDevice
{
    if (!_videoDevice) // 这里可以设置闪光灯 曝光 白平衡等
    {
        _videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _videoDevice;
}

 //3. 获取声音
- (AVCaptureDevice *)audioDevice
{
    if (!_audioDevice)
    {
        _audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    }
    return _audioDevice;
}

- (AVCaptureVideoPreviewLayer *)preview
{
    if (!_preview)
    {
        _preview = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _preview.frame = self.view.layer.bounds;
    }
    return _preview;
}

//4. 根据获取的摄像头,创建对应视频设备输入对象
- (AVCaptureDeviceInput *)videoDeviceInput
{
    if (!_videoDeviceInput)
    {
        _videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:nil];
    }
    return _videoDeviceInput;
}

//5. 根据获取的音频设备，创建对应音频设备输入对象
- (AVCaptureDeviceInput *)audioDeviceInput
{
    if (!_audioDeviceInput)
    {
        _audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.audioDevice error:nil];
    }
    return _audioDeviceInput;
}

//7. 获取视频输出设备
- (AVCaptureAudioDataOutput *)audioOutput
{
    if (!_audioOutput)
    {
        _audioOutput = [[AVCaptureAudioDataOutput alloc] init];
        dispatch_queue_t audioQueue = dispatch_queue_create("audio", DISPATCH_QUEUE_SERIAL);// 必须是串行队列
        [_audioOutput setSampleBufferDelegate:self queue:audioQueue];
        if ([self.captureSession canAddOutput:_audioOutput])
        {
            [_captureSession addOutput:_audioOutput];
        }
    }
    return _audioOutput;
}

//8. 获取音频输出设备
- (AVCaptureVideoDataOutput *)videoOutput
{
    if (!_videoOutput)
    {
        _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        dispatch_queue_t videoQueue = dispatch_queue_create("video", DISPATCH_QUEUE_SERIAL);// 必须是串行队列
        [_videoOutput setSampleBufferDelegate:self queue:videoQueue];
        if ([self.captureSession canAddOutput:_videoOutput])
        {
            [_captureSession addOutput:_videoOutput];
        }
    }
    return _videoOutput;
}

- (AVCaptureStillImageOutput *)imageOutPut
{
    if (!_imageOutPut)
    {
        _imageOutPut = [[AVCaptureStillImageOutput alloc] init];
        if ([self.captureSession canAddOutput:_imageOutPut])
        {
            [_captureSession addOutput:_imageOutPut];
        }
    }
    return _imageOutPut;
}

- (IBAction)test:(id)sender
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

#pragma mark - Void
// 判断权限 请用真机进行测试
- (void)request
{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSLog(@"您的设备没有摄像头或者相关的驱动, 不能进行直播");
    }
    
    // 判断是否有摄像头权限
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied)
    {
        NSLog(@"app需要访问您的摄像头。\\n请启用摄像头-设置/隐私/摄像头");
    }
    
    // 开启麦克风权限
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted)
        {
            if (granted)
            {
                return YES;
            }
            else
            {
               NSLog(@"app需要访问您的麦克风。\\n请启用麦克风-设置/隐私/麦克风");
                return NO;
            }
        }];
    }
    
    // 开启相册访问权限
    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    if (authorStatus == PHAuthorizationStatusAuthorized)
    {

    }else
    {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
        }];
    }



}

#pragma mark - AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureVideoDataOutputSampleBufferDelegate
//- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
//{
//    if (self.videoConnection == connection)
//    {
//        NSLog(@"采集到视频");
//    }
//    else if(self.audioConnection == connection)
//    {
//        NSLog(@"采集到音频");
//    }
//}
//
//// 丢失帧会调用这里
//- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection NS_AVAILABLE(10_7, 6_0)
//{
//    NSLog(@"丢失帧");
//}

@end
