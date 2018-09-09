//
//  HDCommonTools+Permission.h
//  HDCommonTools
//
//  Created by Damon on 2018/2/15.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "HDBaseCommonTools.h"
#import <CoreLocation/CoreLocation.h>

///系统权限授权变化通知
//System authority authorization change notification
FOUNDATION_EXPORT NSString * const HDPermissionStatusDidChangeNotification;

///系统变化通知中的userinfo的key，标记名字
//The key of the userinfo in the system change notification, marked name
FOUNDATION_EXPORT NSString * const HDPermissionNameItem;

///系统变化通知中的userinfo的key，标记状态
//The key of userinfo in the system change notification, marked state
FOUNDATION_EXPORT NSString * const HDPermissionStatusItem;

@interface HDCommonTools (Permission) <CLLocationManagerDelegate>

#pragma mark -
#pragma mark - 权限类
///是否有麦克风权限
//Whether have the microphone permissions
- (HDPrivatePermissionStatus)getAVMediaTypeAudioPermissionStatus;

///是否有拍照权限
//Whether have the Camera permissions
- (HDPrivatePermissionStatus)getAVMediaTypeVideoPermissionStatus;

///是否有相册权限
////Whether have the Photo album permissions
- (HDPrivatePermissionStatus)getPhotoLibraryPermissionStatus;

///是否有定位权限
//Whether have the GPS permissions
- (HDPrivatePermissionStatus)getGPSLibraryPermissionStatus;

///是否有通知权限
///Whether there is notification authority
- (HDPrivatePermissionStatus)getNotificationPermissionStatus;

///申请定位权限
//Apply the GPS permissions
- (void)requestGPSLibraryPermissionWithType:(HDGPSPermissionType)GPSPermissionType;

///申请麦克风权限
//Apply the Microphone permissions
- (void)requestAVMediaTypeAudioPermission;

///申请拍照权限
//Apply the Camera permissions
- (void)requestAVMediaTypeVideoPermission;

///申请相册权限
//Apply the Photo album permissions
- (void)requestPhotoLibraryPermission;

///申请通知权限,iOS10.0以上才可以动态通知获取到的权限
///Application of notification authority,More than iOS10.0 can dynamically notify the acquired permissions
- (void)requestNotificationPermission;

///打开系统设置
//Open the system settings
- (void)openSystemSetting;
@end
