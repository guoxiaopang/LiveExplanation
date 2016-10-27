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
@property (nonatomic, strong) AVAsset *asset;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];

    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.view.layer addSublayer:layer];
    layer.frame = self.view.bounds;
    // 监听播放状态，ReadyToPlay才可以播放
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

- (AVAsset *)asset
{
    if (!_asset)
    {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"mp4"];
        _asset = [AVAsset assetWithURL:url];
    }
    return _asset;
}

- (AVPlayerItem *)item
{
    if (!_item)
    {
        _item = [AVPlayerItem playerItemWithAsset:self.asset];
    }
    return _item;
}

- (AVPlayer *)player
{
    if (!_player)
    {
        _player = [AVPlayer playerWithPlayerItem:self.item];
    }
    return _player;
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
