//
//  HDCommonToolsConfig.h
//  HDCommonTools
//
//  Created by Damon on 2018/2/15.
//  Copyright © 2018年 damon. All rights reserved.
//

#ifndef HDCommonToolsConfig_h
#define HDCommonToolsConfig_h

///申请的权限 Application authority
typedef NS_ENUM(NSUInteger, HDPrivatePermissionName) {
    kHDPermissionNameAudio,     //麦克风权限 Microphone permissions
    kHDPermissionNameVideo,     //摄像头权限 Camera permissions
    kHDPermissionNamePhotoLib,  //相册权限 Photo album permissions
    kHDPermissionNameGPS,       //GPS权限 GPS permissions
    kHDPermissionNameNotification, //通知权限 Notification permissions
};

///申请权限状态 Application permissions status
typedef NS_ENUM(NSUInteger, HDPrivatePermissionStatus) {
    kHDAuthorized = 1,  //用户允许 Authorized
    kHDAuthorRestricted,//被限制修改不了状态,比如家长控制选项等 Restricted status, such as parental control options, etc.
    kHDDenied,          //用户拒绝 Denied
    kHDNotDetermined    //用户尚未选择 NotDetermined
};

///申请定位权限的类型 The type of application for positioning permission
typedef NS_ENUM(NSUInteger, HDGPSPermissionType) {
    kHDGPSPermissionWhenInUse,      //申请使用期间访问位置 Access location WhenInUse
    kHDGPSPermissionAlways,         //申请一直访问位置  Always
    kHDGPSPermissionBoth            //两者都申请 Both
};

///常用的系统语言 Common system language
typedef NS_ENUM(NSUInteger, HDSystemLanguage) {
    kHDLanguageEn = 1,  //英文 English
    kHDLanguageTC,      //繁体中文 Traditional Chinese
    kHDLanguageCN,       //简体 Simplified Chinese
    kHDLanguageOther     //其他语言 Other languages
};

///时间戳快速转换为时间字符串 The time stamp is quickly converted to a time string
typedef NS_ENUM(NSUInteger, HDQuickFormatType) {
    kHDQuickFormateTypeYMD,         //年月日   2010-09-02
    kHDQuickFormateTypeMD,          //月日     09-02
    kHDQuickFormateTypeYMDTime,     //年月日时间 2010-09-02 05:23:17
    kHDQuickFormateTypeTime,        //时间    05:23:17
    kHDQuickFormateTypeMDTime,       //月日时间 09-02 05:23
    kHDQuickFormateTypeYMDTimeZone    //年月日时区 2018-03-15T09:59:00+0800
};

///
typedef NS_ENUM(NSUInteger, HDChineseLunarCalendarFormatType) {
    kHDChineseLunarCalendarFormatTypeYMD,         //年月日   2018年正月初十
    kHDChineseLunarCalendarFormatTypeMD,          //月日     正月初十
};

///评分样式类型 Scoring style type
typedef NS_ENUM(NSUInteger, HDScoreType) {
    kHDScoreTypeInAppStore,  //强制跳转到appsStore中评分。 Forced jump to appsStore
    kHDScoreTypeInApp,      //强制在app中弹出评分弹窗，ios10.3版本以下无反应。 Force the score pop-up window in app, the score will not respond when lower than the ios10.3 version
    kHDScoreTypeAuto         //10.3版本以下去appStore评分，10.3版本以上在app中弹出评分弹窗。jump to appsStore when lower than the ios10.3 version and the score pop-up window in app when higher than the ios10.3 version
};

///打开指定软件的appstore样式类型 Open the Appstore style type of the specified software
typedef NS_ENUM(NSUInteger, HDJumpStoreType) {
    kHDJumpStoreTypeInAppStore,  //强制跳转到appsStore。 Forced jump to appsStore
    kHDJumpStoreTypeInApp,      //强制在app中弹出appStore，ios10.3版本以下无反应。Force the score pop-up window in app, the score will not respond when lower than the ios10.3 version
    kHDJumpStoreTypeAuto         //10.3版本以下跳转appStore，10.3版本以上在app中弹出Appstore。jump to appsStore when lower than the ios10.3 version and the score pop-up window in app when higher than the ios10.3 version
};

///星座 Constellation
typedef NS_ENUM(NSUInteger, HDConstellation) {
    kHDConstellationCapricorn,      //摩羯座
    kHDConstellationAquarius,       //水瓶座
    kHDConstellationPisces,         //双鱼座
    kHDConstellationAries,          //白羊座
    kHDConstellationTaurus,         //金牛座
    kHDConstellationGemini,         //双子座
    kHDConstellationCancer,         //巨蟹座
    kHDConstellationLeo,            //狮子座
    kHDConstellationVirgo,          //处女座
    kHDConstellationLibra,          //天秤座
    kHDConstellationScorpio,        //天蝎座
    kHDConstellationSagittarius     //射手座
};

///十二生肖 Chinese Zodiac
typedef NS_ENUM(NSUInteger, HDChineseZodiac) {
    kHDChineseZodiacRat = 1,        //子鼠
    kHDChineseZodiacOx,         //丑牛
    kHDChineseZodiacTiger,      //寅虎
    kHDChineseZodiacRabbit,     //卯兔
    kHDChineseZodiacDragon,     //辰龙
    kHDChineseZodiacSnake,      //巳蛇
    kHDChineseZodiacHorse,      //午马
    kHDChineseZodiacGoat,       //未羊
    kHDChineseZodiacMonkey,     //申猴
    kHDChineseZodiacRooster,    //酉鸡
    kHDChineseZodiacDog,        //戌狗
    kHDChineseZodiacPig,        //亥猪
};
#endif /* HDCommonToolsConfig_h */
