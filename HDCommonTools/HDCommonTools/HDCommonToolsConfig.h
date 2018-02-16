//
//  HDCommonToolsConfig.h
//  HDCommonTools
//
//  Created by Damon on 2018/2/15.
//  Copyright © 2018年 damon. All rights reserved.
//

#ifndef HDCommonToolsConfig_h
#define HDCommonToolsConfig_h

///申请的权限
typedef NS_ENUM(NSUInteger, HDPrivatePermissionName) {
    kHDPermissionNameAudio,     //麦克风权限
    kHDPermissionNameVideo,     //摄像头权限
    kHDPermissionNamePhotoLib,  //相册权限
    kHDPermissionNameGPS,       //GPS权限
};

///申请权限状态
typedef NS_ENUM(NSUInteger, HDPrivatePermissionStatus) {
    kHDAuthorized = 1,  //用户允许
    kHDAuthorRestricted,//被限制修改不了状态,比如家长控制选项等
    kHDDenied,          //用户拒绝
    kHDNotDetermined    //用户尚未选择
};

///申请定位权限的类型
typedef NS_ENUM(NSUInteger, HDGPSPermissionType) {
    kHDGPSPermissionWhenInUse,      //申请使用期间访问位置
    kHDGPSPermissionAlways,         //申请一直访问位置
    kHDGPSPermissionBoth            //两者都申请
};

///常用的系统语言
typedef NS_ENUM(NSUInteger, HDSystemLanguage) {
    kHDLanguageEn = 1,  //英文
    kHDLanguageTC,      //繁体中文
    kHDLanguageCN,       //简体
    kHDLanguageOther     //其他语言
};

///时间戳快速转换为时间字符串
typedef NS_ENUM(NSUInteger, HDQuickFormatType) {
    kHDQuickFormateTypeNone = 0,    //自己定义转换
    kHDQuickFormateTypeYMD,         //年月日   2010-09-02
    kHDQuickFormateTypeMD,          //月日     09-02
    kHDQuickFormateTypeYMDTime,     //年月日时间 2010-09-02 05:23:17
    kHDQuickFormateTypeTime,        //时间    05:23:17
    kHDQuickFormateTypeMDTime       //月日时间 09-02 05:23
};

///评分样式类型
typedef NS_ENUM(NSUInteger, HDScoreType) {
    kHDScoreTypeInAppStore,  //强制跳转到appsStore中评分
    kHDScoreTypeInApp,      //强制在app中弹出评分弹窗，ios10.3版本以下无反应
    kHDScoreTypeAuto         //10.3版本以下去appStore评分，10.3版本以上在app中弹出评分弹窗
};

///打开指定软件的appstore样式类型
typedef NS_ENUM(NSUInteger, HDJumpStoreType) {
    kHDJumpStoreTypeInAppStore,  //强制跳转到appsStore
    kHDJumpStoreTypeInApp,      //强制在app中弹出appStore，ios10.3版本以下无反应
    kHDJumpStoreTypeAuto         //10.3版本以下跳转appStore，10.3版本以上在app中弹出Appstore
};
#endif /* HDCommonToolsConfig_h */
