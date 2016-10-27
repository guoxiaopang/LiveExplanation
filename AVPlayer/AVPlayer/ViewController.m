//
//  ViewController.m
//  AVPlayer
//
//  Created by duoyi on 16/10/27.
//  Copyright © 2016年 bt. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *item;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
//  1. 创建视频资源地址URL，可以是网络URL
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1.mp4" ofType:nil];
    NSURL *urlStr = [NSURL URLWithString:path];
//  2. 通过URL创建视频内容对象`AVPlayerItem`,一个视频对应一个`AVPlayerItem`
    self.item = [AVPlayerItem playerItemWithURL:urlStr];
//  3. 创建`AVPlayer`视频播放对象，需要一个`AVPlayerItem`进行初始化
    self.player = [AVPlayer playerWithPlayerItem:self.item];
    //self.player = [AVPlayer playerWithURL:urlStr];
//  4. 创建`AVPlayerLayer`播放图层对象，添加到现实视图上去
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    layer.frame = CGRectMake(0, 0, 200, 300);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:layer];
    
    // 监听播放状态，ReadyToPlay才可以播放
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{

    if ([keyPath isEqualToString:@"status"])
    {
        AVPlayerItemStatus status = [change[@"new"]integerValue];
        switch (status)
        {
            case AVPlayerItemStatusUnknown:
                NSLog(@"AVPlayerItemStatusUnknown");
                break;
                
            case AVPlayerItemStatusReadyToPlay:
                [self.player play];
                NSLog(@"AVPlayerItemStatusReadyToPlay");
                break;
                
            case AVPlayerItemStatusFailed:
                NSLog(@"AVPlayerItemStatusFailed");
                break;
                
            default:
                break;
        }
    }
}



@end
