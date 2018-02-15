//
//  HDCommonTools+SystemInfo.h
//  HDCommonTools
//
//  Created by Damon on 2018/2/15.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "HDCommonTools.h"

@interface HDCommonTools (SystemInfo)
#pragma mark -
#pragma mark - 系统信息类
///软件版本
- (NSString*)getAppVersion;

///工程的build版本
- (NSString*)getAppBuildVersion;

///系统的ios版本
- (NSString*)getIOSVersion;

///获取系统语言
- (NSString*)getIOSLanguage;

///是否是英文语言环境
- (BOOL)isEnglishLanguage;

///返回系统使用语言
- (HDSystemLanguage)getLanguage;

///软件Bundle Identifier
- (NSString*)getBundleIdentifier;

///模拟软件唯一标示，如果idfa可用使用idfa，否则则使用模拟的idfa
- (NSString*)getIphoneIdfa;

///获取具体的手机型号字符串
- (NSString*)getDetailModel;

///是否是平板
- (BOOL)isPad;

///是否是iphoneX
-(BOOL)isPhoneX;
@end
