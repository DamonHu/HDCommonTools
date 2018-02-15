//
//  HDCommonTools+Permission.h
//  HDCommonTools
//
//  Created by Damon on 2018/2/15.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "HDCommonTools.h"
#import "HDCommonToolsConfig.h"
#import <CoreLocation/CoreLocation.h>

///系统权限授权变化通知
FOUNDATION_EXPORT NSString * const HDPermissionStatusDidChangeNotification;
///系统变化通知中的userinfo的key，标记名字
FOUNDATION_EXPORT NSString * const HDPermissionNameItem;
///系统变化通知中的userinfo的key，标记状态
FOUNDATION_EXPORT NSString * const HDPermissionStatusItem;

@interface HDCommonTools (Permission)<CLLocationManagerDelegate>

#pragma mark -
#pragma mark - 权限类
///是否有麦克风权限
- (HDPrivatePermissionStatus)hasAVMediaTypeAudio;

///是否有拍照权限
- (HDPrivatePermissionStatus)hasAVMediaTypeVideo;

///是否有相册权限
- (HDPrivatePermissionStatus)hasPhotoLibrary;

///是否有定位权限
- (HDPrivatePermissionStatus)hasGPSLibrary;

///申请定位权限
-(void)getGPSLibraryWithType:(HDGPSPermissionType)GPSPermissionType;

///申请麦克风权限
- (void)getAVMediaTypeAudio;

///申请拍照权限
-(void)getAVMediaTypeVideo;

///申请相册权限
- (void)getPhotoLibrary;

///打开系统设置
- (void)openSetting;
@end
