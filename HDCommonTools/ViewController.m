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
    [[HDCommonTools sharedHDCommonTools] getGPSLibraryWithType:kHDGPSPermissionWhenInUse];
//    [[HDCommonTools sharedHDCommonTools] getAVMediaTypeVideo];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
