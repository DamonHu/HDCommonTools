//
//  HDCommonTools+Permission.m
//  HDCommonTools
//
//  Created by Damon on 2018/2/15.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "HDCommonTools+Permission.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

NSString * const HDPermissionStatusDidChangeNotification = @"HDPermissionStatusDidChangeNotification";
NSString * const HDPermissionNameItem = @"HDPermissionNameItem";
NSString * const HDPermissionStatusItem = @"HDPermissionStatusItem";

CLLocationManager *locationManager;
@implementation HDCommonTools (Permission)

#pragma mark -
#pragma mark - 权限类
///是否有麦克风权限
- (HDPrivatePermissionStatus)hasAVMediaTypeAudio{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusAuthorized) {
        return kHDAuthorized;
    }else if (status == AVAuthorizationStatusNotDetermined) {
        return kHDNotDetermined;
    }else if (status == AVAuthorizationStatusRestricted){
        return kHDAuthorRestricted;
    }else {
        return kHDDenied;
    }
}

///是否有拍照权限
- (HDPrivatePermissionStatus)hasAVMediaTypeVideo{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusAuthorized) {
        return kHDAuthorized;
    }else if (status == AVAuthorizationStatusNotDetermined) {
        return kHDNotDetermined;
    }else if (status == AVAuthorizationStatusRestricted){
        return kHDAuthorRestricted;
    }else {
        return kHDDenied;
    }
}

///是否有相册权限
- (HDPrivatePermissionStatus)hasPhotoLibrary{
    PHAuthorizationStatus status=[PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        return kHDAuthorized;
    }else if (status == PHAuthorizationStatusNotDetermined) {
        return kHDNotDetermined;
    }else if (status == PHAuthorizationStatusRestricted){
        return kHDAuthorRestricted;
    }else {
        return kHDDenied;
    }
}

///是否有定位权限
- (HDPrivatePermissionStatus)hasGPSLibrary{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus]  == kCLAuthorizationStatusAuthorizedAlways)) {
        //定位功能可用
        return kHDAuthorized;
    }else if ( [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        return kHDNotDetermined;
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusRestricted){
        return kHDAuthorRestricted;
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        //定位不能用
        return kHDDenied;
    }
    return kHDDenied;
}

///申请定位权限
-(void)getGPSLibraryWithType:(HDGPSPermissionType)GPSPermissionType{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    if (GPSPermissionType == kHDGPSPermissionWhenInUse) {
        [locationManager requestWhenInUseAuthorization];
    }else if (GPSPermissionType == kHDGPSPermissionAlways){
        [locationManager requestAlwaysAuthorization];
    }else if (GPSPermissionType == kHDGPSPermissionBoth){
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
}

///申请麦克风权限
- (void)getAVMediaTypeAudio{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        HDPrivatePermissionStatus permissionStatus;
        if (granted) {
            permissionStatus = kHDAuthorized;
        }else{
            permissionStatus = kHDDenied;
        }
        NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@(kHDPermissionNameAudio),HDPermissionNameItem,@(permissionStatus),HDPermissionStatusItem, nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:HDPermissionStatusDidChangeNotification object:nil userInfo:userInfo];
    }];
}

///申请拍照权限
-(void)getAVMediaTypeVideo{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        HDPrivatePermissionStatus permissionStatus;
        if (granted) {
            permissionStatus = kHDAuthorized;
        }else{
            permissionStatus = kHDDenied;
        }
        NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@(kHDPermissionNameVideo),HDPermissionNameItem,@(permissionStatus),HDPermissionStatusItem, nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:HDPermissionStatusDidChangeNotification object:nil userInfo:userInfo];
    }];
}

///申请相册权限
- (void)getPhotoLibrary{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        HDPrivatePermissionStatus permissionStatus;
        if (status == PHAuthorizationStatusAuthorized) {
            permissionStatus = kHDAuthorized;
        }else if (status == PHAuthorizationStatusNotDetermined) {
            permissionStatus = kHDNotDetermined;
        }else if (status == PHAuthorizationStatusRestricted){
            permissionStatus = kHDAuthorRestricted;
        }else {
            permissionStatus = kHDDenied;
        }
        NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@(kHDPermissionNamePhotoLib),HDPermissionNameItem,@(permissionStatus),HDPermissionStatusItem, nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:HDPermissionStatusDidChangeNotification object:nil userInfo:userInfo];
    }];
}

///打开系统设置
- (void)openSetting{
    NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
        [[UIApplication sharedApplication] openURL:settingUrl];
    }
}

#pragma mark -
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    HDPrivatePermissionStatus permissionStatus;
    if (status == kCLAuthorizationStatusNotDetermined) {
        permissionStatus = kHDNotDetermined;
    }else if (status == kCLAuthorizationStatusRestricted){
        permissionStatus = kHDAuthorRestricted;
    }else if (status == kCLAuthorizationStatusDenied){
        permissionStatus = kHDDenied;
    }else {
        permissionStatus = kHDAuthorized;
    }
    NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@(kHDPermissionNameGPS),HDPermissionNameItem,@(permissionStatus),HDPermissionStatusItem, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:HDPermissionStatusDidChangeNotification object:nil userInfo:userInfo];
}
@end
