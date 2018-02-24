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
///工具的单例 singleton
+ (HDCommonTools*)sharedHDCommonTools;

#pragma mark -
#pragma mark - 数据处理类
/**
 将log打印信息输出到文件中，调用此函数后控制台将不再显示log的打印信息
 @return 返回打印信息所在的文件路径
 The log print information is exported to the file, and the console will no longer display the print information of the log after calling this function
 Returns the path of the file where the print information is located
 */
- (NSString*)setHdDebugLogToFile;

/// 将字典或者数组转化为Data数据
//Translate dictionaries or arrays into Data
- (NSData *)toJSONData:(id)theData;

/// 将字典或者数组转化为json字符串数据
//Translate dictionaries or arrays into JSON string data
- (NSString *)toJSONStr:(id)theData;

/// 将JSON Data串转化为字典或者数组
//Converting the JSON string Data into a dictionary or array
- (id)DataToArrayOrNSDictionary:(NSData *)jsonData;

/// 将JSON串转化为字典或者数组
//Converting the JSON string into a dictionary or array
- (id)StrToArrayOrNSDictionary:(NSString *)jsonStr;

///NSArray转为NSString
//Converting NSArray into NSString
- (NSString*)ArrayToString:(NSArray*)array;

///NSString通过指定的分割符转为NSArray，如果symbol为空，则默认为","
//NSString turns to NSArray by the specified division, and if symbol is empty, the default is ","
- (NSArray*)StringToArray:(NSString*)str bySymbol:(NSString*)symbol;

///unicode转换为中文
//Unicode conversion to Chinese
- (NSString*)convertUnicodeString:(NSString*)unicodeStr;

///从指定文件名文件获取json内容
//Getting the JSON content from the specified file name file
- (id)getJsonDataFromFileName:(NSString*)jsonName;

///获取当前时间的时间戳
//Get the timestamp of the current time
- (NSString*)getCurrentTimeStamp;

///获取指定时间的时间戳
//Get the timestamp of the specified time
- (NSString*)getTimeStampByDate:(NSDate*)date;

/**
 时间戳获取时间
 Getting time through a timestamp
 
 @param timeStamp 时间戳
 @param quickType 快速格式化时间，如果传None则自己定义foramatter。
 Fast formatting time, if you pass None, you define foramatter
 @param formatter 自己定义foramatter
 you define foramatter
 @return 格式化过的时间
 */
- (NSString*)getTimeFromTimeStamp:(NSString*)timeStamp andQuickFormatType:(HDQuickFormatType)quickType orCustomFormatter:(NSDateFormatter*)formatter;

@end
