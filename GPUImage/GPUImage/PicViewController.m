//
//  PicViewController.m
//  GPUImage
//
//  Created by duoyi on 16/10/26.
//  Copyright © 2016年 bt. All rights reserved.
//

#import "PicViewController.h"
#import "GPUImage.h"

@interface PicViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UISlider *slider;

@end

@implementation PicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.slider];
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 50)];
        _imageView.image = [UIImage imageNamed:@"105"];
    }
    return _imageView;
}

- (UISlider *)slider
{
    if (!_slider)
    {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(self.view.frame) - 25, CGRectGetWidth(self.view.frame) - 20, 10)];
        _slider.maximumValue = 1.0;
        _slider.minimumValue = -1.0;
       
        [_slider addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (void)change:(UISlider *)slider
{
    NSLog(@"%lf", slider.value);
    UIImage *image = [UIImage imageNamed:@"105"];
    // 创建过滤器
    GPUImageBrightnessFilter *filter = [[GPUImageBrightnessFilter alloc] init];
    filter.brightness = slider.value;
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture]; // 告诉系统从后来捕获过滤器
    
    // 处理静止的图像
    GPUImagePicture *stillPic = [[GPUImagePicture alloc] initWithImage:image];
    [stillPic removeAllTargets];
    [stillPic addTarget:filter]; //添加过滤器
    [stillPic processImage]; // 执行渲染
    
    UIImage *newImage = [filter imageFromCurrentFramebuffer];
    self.imageView.image = newImage;
}

@end
