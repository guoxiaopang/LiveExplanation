//
//  TableViewController.m
//  GPUImage
//
//  Created by duoyi on 16/10/25.
//  Copyright © 2016年 bt. All rights reserved.
//

#import "TableViewController.h"
#import "PicViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"aa"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aa" forIndexPath:indexPath];
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"GPUImageVideoCamera iOS摄像头实时美颜";
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"GPUImagePicture 静止图像美颜";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1)
    {
        PicViewController *controllrt = [[PicViewController alloc] init];
        [self.navigationController pushViewController:controllrt animated:YES];
    }
}


@end
