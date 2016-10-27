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
   // NSURL *urlStr = [NSURL fileURLWithPath:path];
    //NSURL *urlStr = [NSURL URLWithString:path];
    NSURL *urlStr = [NSURL URLWithString:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"];
    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
    controller.view.frame = self.view.frame;
    controller.player = [AVPlayer playerWithURL:urlStr];
    [controller.player play];
    [self.view addSubview:controller.view];
//    [self presentViewController:controller animated:YES completion:^{
//         [controller.player play];
//    }];
   
}




@end
