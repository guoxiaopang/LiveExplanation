//
//  NSObject+HUD.m
//  捕获音视屏
//
//  Created by duoyi on 16/10/25.
//  Copyright © 2016年 bt. All rights reserved.
//

#import "NSObject+HUD.h"
#import <UIKit/UIKit.h>

@implementation NSObject (HUD)

- (void)showInfo:(NSString *)info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self isKindOfClass:[UIViewController class]] || [self isKindOfClass:[UIView class]]) {
            [[[UIAlertView alloc] initWithTitle:@"提醒" message:info delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
        }
    });
    

}

@end
