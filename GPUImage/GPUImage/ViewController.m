//
//  ViewController.m
//  GPUImage
//
//  Created by duoyi on 16/10/25.
//  Copyright © 2016年 bt. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *inputImage = [UIImage imageNamed:@"105"];
    
    // 创建过滤器
    GPUImageBrightnessFilter *filter = [[GPUImageBrightnessFilter alloc] init];
    filter.brightness = 0.5;
    [filter forceProcessingAtSize:inputImage.size];
    [filter useNextFrameForImageCapture]; // 告诉系统从后来捕获过滤器
    
    // 处理静止的图像
    GPUImagePicture *stillPic = [[GPUImagePicture alloc] initWithImage:inputImage];
    [stillPic addTarget:filter]; //添加过滤器
    [stillPic processImage]; // 执行渲染
    
    UIImage *newImage = [filter imageFromCurrentFramebuffer];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:newImage];
    [imageView sizeToFit];
    [self.view addSubview:imageView];
    imageView.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2);
    
}





@end
