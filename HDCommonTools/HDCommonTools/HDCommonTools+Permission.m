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
#import <UserNotifications/UserNotifications.h>

NSString * const HDPermissionStatusDidChangeNotification = @"HDPermissionStatusDidChangeNotification";
NSString * const HDPermissionNameItem = @"HDPermissionNameItem";
NSString * const HDPermissionStatusItem = @"HDPermissionStatusItem";

CLLocationManager *locationManager;

@implementation HDCommonTools (Permission)

#pragma mark -
#pragma mark - 权限类

///是否有麦克风权限
//Whether have the microphone permissions
- (HDPrivatePermissionStatus)getAVMediaTypeAudioPermissionStatus {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusAuthorized) {
        return kHDAuthorized;
    } else if (status == AVAuthorizationStatusNotDetermined) {
        return kHDNotDetermined;
    } else if (status == AVAuthorizationStatusRestricted) {
        return kHDAuthorRestricted;
    } else {
        return kHDDenied;
    }
}

///是否有拍照权限
//Whether have the Camera permissions
- (HDPrivatePermissionStatus)getAVMediaTypeVideoPermissionStatus {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusAuthorized) {
        return kHDAuthorized;
    } else if (status == AVAuthorizationStatusNotDetermined) {
        return kHDNotDetermined;
    } else if (status == AVAuthorizationStatusRestricted) {
        return kHDAuthorRestricted;
    } else {
        return kHDDenied;
    }
}

///是否有相册权限
////Whether have the Photo album permissions
- (HDPrivatePermissionStatus)getPhotoLibraryPermissionStatus {
    PHAuthorizationStatus status=[PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        return kHDAuthorized;
    } else if (status == PHAuthorizationStatusNotDetermined) {
        return kHDNotDetermined;
    } else if (status == PHAuthorizationStatusRestricted) {
        return kHDAuthorRestricted;
    } else {
        return kHDDenied;
    }
}

///是否有定位权限
//Whether have the GPS permissions
- (HDPrivatePermissionStatus)getGPSLibraryPermissionStatus {
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus]  == kCLAuthorizationStatusAuthorizedAlways)) {
        //定位功能可用
        return kHDAuthorized;
    } else if ( [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        return kHDNotDetermined;
    } else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusRestricted) {
        return kHDAuthorRestricted;
    } else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        //定位不能用
        return kHDDenied;
    }
    return kHDDenied;
}

///是否有通知权限
///Whether there is notification authority
- (HDPrivatePermissionStatus)getNotificationPermissionStatus {
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIUserNotificationTypeNone) {
        return kHDDenied;
    } else {
        return kHDAuthorized;
    }
}

///申请定位权限
//Apply the GPS permissions
- (void)requestGPSLibraryPermissionWithType:(HDGPSPermissionType)GPSPermissionType {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    if (GPSPermissionType == kHDGPSPermissionWhenInUse) {
        [locationManager requestWhenInUseAuthorization];
    } else if (GPSPermissionType == kHDGPSPermissionAlways) {
        [locationManager requestAlwaysAuthorization];
    } else if (GPSPermissionType == kHDGPSPermissionBoth) {
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
}

///申请麦克风权限
//Apply the Microphone permissions
- (void)requestAVMediaTypeAudioPermission {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        HDPrivatePermissionStatus permissionStatus;
        if (granted) {
            permissionStatus = kHDAuthorized;
        } else{
            permissionStatus = kHDDenied;
        }
        NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@(kHDPermissionNameAudio),HDPermissionNameItem,@(permissionStatus),HDPermissionStatusItem, nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:HDPermissionStatusDidChangeNotification object:nil userInfo:userInfo];
    }];
}

///申请拍照权限
//Apply the Camera permissions
- (void)requestAVMediaTypeVideoPermission {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        HDPrivatePermissionStatus permissionStatus;
        if (granted) {
            permissionStatus = kHDAuthorized;
        } else {
            permissionStatus = kHDDenied;
        }
        NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@(kHDPermissionNameVideo),HDPermissionNameItem,@(permissionStatus),HDPermissionStatusItem, nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:HDPermissionStatusDidChangeNotification object:nil userInfo:userInfo];
    }];
}

///申请相册权限
//Apply the Photo album permissions
- (void)requestPhotoLibraryPermission {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        HDPrivatePermissionStatus permissionStatus;
        if (status == PHAuthorizationStatusAuthorized) {
            permissionStatus = kHDAuthorized;
        } else if (status == PHAuthorizationStatusNotDetermined) {
            permissionStatus = kHDNotDetermined;
        } else if (status == PHAuthorizationStatusRestricted) {
            permissionStatus = kHDAuthorRestricted;
        } else {
            permissionStatus = kHDDenied;
        }
        NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@(kHDPermissionNamePhotoLib),HDPermissionNameItem,@(permissionStatus),HDPermissionStatusItem, nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:HDPermissionStatusDidChangeNotification object:nil userInfo:userInfo];
    }];
}

///申请通知权限
///Application of notification authority
-(void)requestNotificationPermission {
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge completionHandler:^(BOOL granted, NSError * _Nullable error) {
            HDPrivatePermissionStatus permissionStatus;
            if (granted) {
                permissionStatus = kHDAuthorized;
            } else {
                permissionStatus = kHDDenied;
            }
            NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@(kHDPermissionNameNotification),HDPermissionNameItem,@(permissionStatus),HDPermissionStatusItem, nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:HDPermissionStatusDidChangeNotification object:nil userInfo:userInfo];
        }];
    } else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge categories:nil]];  //注册通知
    }
}

///打开系统设置
//Open the system settings
- (void)openSystemSetting {
    NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:settingUrl options:[NSDictionary dictionary] completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:settingUrl];
        }
    }
}

#pragma mark -
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    HDPrivatePermissionStatus permissionStatus;
    if (status == kCLAuthorizationStatusNotDetermined) {
        permissionStatus = kHDNotDetermined;
    } else if (status == kCLAuthorizationStatusRestricted) {
        permissionStatus = kHDAuthorRestricted;
    } else if (status == kCLAuthorizationStatusDenied) {
        permissionStatus = kHDDenied;
    } else {
        permissionStatus = kHDAuthorized;
    }
    NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@(kHDPermissionNameGPS),HDPermissionNameItem,@(permissionStatus),HDPermissionStatusItem, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:HDPermissionStatusDidChangeNotification object:nil userInfo:userInfo];
}
@end
