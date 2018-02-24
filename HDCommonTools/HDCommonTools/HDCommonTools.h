//
//  HDCommonTools.h
//  HDCommonTools
//
//  Created by Damon on 2018/2/15.
//  Copyright © 2018年 damon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDCommonToolsConfig.h"

@interface HDCommonTools : NSObject
///工具的单例
+ (HDCommonTools*)sharedHDCommonTools;

#pragma mark -
#pragma mark - 数据处理类
/**
 将log打印信息输出到文件中，调用此函数后控制台将不再显示log的打印信息
 @return 返回打印信息所在的文件路径
 */
+(NSString*)setHdDebugLogToFile;

/// 将字典或者数组转化为Data数据
- (NSData *)toJSONData:(id)theData;

/// 将字典或者数组转化为json字符串数据
- (NSString *)toJSONStr:(id)theData;

/// 将JSON Data串转化为字典或者数组
- (id)DataToArrayOrNSDictionary:(NSData *)jsonData;

/// 将JSON串转化为字典或者数组
- (id)StrToArrayOrNSDictionary:(NSString *)jsonStr;

///NSArray转为NSString
- (NSString*)ArrayToString:(NSArray*)array;

///NSString通过指定的分割符转为NSArray，如果symbol为空，则默认为","
- (NSArray*)StringToArray:(NSString*)str bySymbol:(NSString*)symbol;

///unicode转换为中文
- (NSString*)convertUnicodeString:(NSString*)unicodeStr;

///从指定文件名文件获取json内容
- (id)getJsonDataFromFileName:(NSString*)jsonName;

///获取当前时间的时间戳
- (NSString*)getCurrentTimeStamp;

///获取指定时间的时间戳
- (NSString*)getTimeStampByDate:(NSDate*)date;

/**
 时间戳获取时间
 
 @param timeStamp 时间戳
 @param quickType 快速格式化时间，如果传None则自己定义foramatter
 @param formatter 自己定义foramatter
 @return 格式化过的时间
 */
- (NSString*)getTimeFromTimeStamp:(NSString*)timeStamp andQuickFormatType:(HDQuickFormatType)quickType orCustomFormatter:(NSDateFormatter*)formatter;

@end
