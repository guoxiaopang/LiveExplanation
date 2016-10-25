//
//  TableViewController.m
//  捕获音视屏
//
//  Created by duoyi on 16/10/25.
//  Copyright © 2016年 bt. All rights reserved.
//

#import "TableViewController.h"
#import "ImageViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "ViewController.h"

@interface TableViewController ()

@end

static NSString *ident = @"ident";
@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"视频采集";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ident];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self request];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"捕获音频视频(真机测试)";
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"捕捉静态图片(真机测试)";
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"捕捉视频(真机测试)";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1)
    {
        ImageViewController *controller = [[ImageViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.row == 0)
    {
        ViewController *controller = [[ViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }

}

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


@end
