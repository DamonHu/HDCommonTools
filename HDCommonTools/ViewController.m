//
//  ViewController.m
//  HDCommonTools
//
//  Created by Damon on 2018/2/14.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "ViewController.h"
#import "HDCommonHeader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",[[HDCommonTools sharedHDCommonTools] getIOSLanguage]);
    ///注册权限回调通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(permissionNotifacation:) name:HDPermissionStatusDidChangeNotification object:nil];
    ///申请gps权限
    [[HDCommonTools sharedHDCommonTools] getGPSLibraryWithType:kHDGPSPermissionWhenInUse];
}

-(void)permissionNotifacation:(NSNotification*)notification{
    NSDictionary * userInfo = [notification userInfo];
    if ([[userInfo objectForKey:HDPermissionNameItem] integerValue] == kHDPermissionNameGPS) {
        if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDAuthorized) {
            NSLog(@"用户允许访问gps");
        }else if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDAuthorRestricted){
            NSLog(@"用户被限制访问gps");
        }else if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDNotDetermined){
            NSLog(@"用户尚未选择是否允许访问gps");
        }else{
            NSLog(@"用户不允许访问gps");
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
