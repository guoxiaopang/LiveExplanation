//
//  ViewController.m
//  AVKit
//
//  Created by duoyi on 16/10/26.
//  Copyright © 2016年 bt. All rights reserved.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1.mp4" ofType:nil];
  //  NSURL *urlStr = [NSURL URLWithString:@"rtmp://localhost:1935/rtmplive/room"];
    NSURL *urlStr = [NSURL fileURLWithPath:path];
    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
    controller.view.frame = self.view.frame;
    controller.player = [AVPlayer playerWithURL:urlStr];
    [self.view addSubview:controller.view];
    [controller.player play];
}




@end
