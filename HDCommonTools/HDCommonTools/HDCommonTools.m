//
//  HDCommonTools.m
//  HDCommonTools
//
//  Created by Damon on 2018/2/15.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "HDCommonTools.h"
#import <CommonCrypto/CommonDigest.h>

@implementation HDCommonTools
///工具的单例
+ (HDCommonTools*)sharedHDCommonTools
{
    static HDCommonTools *aCommonTools = nil;
    if (!aCommonTools) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            aCommonTools = [[HDCommonTools alloc] init];
        });
    }
    return aCommonTools;
}

#pragma mark -
#pragma mark - 数据处理类
/// 将字典或者数组转化为Data数据
- (NSData *)toJSONData:(id)theData{
    NSError *error = nil;
    if (!theData) {
        NSAssert(NO, @"转换数据为空");
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

/// 将字典或者数组转化为json字符串数据
- (NSString *)toJSONStr:(id)theData{
    if (!theData) {
        NSAssert(NO, @"转换数据为空");
        return nil;
    }
    NSData *jsonData = [self toJSONData:theData];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

/// 将JSON Data串转化为字典或者数组
- (id)DataToArrayOrNSDictionary:(NSData *)jsonData{
    if (!jsonData) {
        NSAssert(NO, @"转换数据为空");
        return nil;
    }
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

/// 将JSON串转化为字典或者数组
- (id)StrToArrayOrNSDictionary:(NSString *)jsonStr{
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    return [self DataToArrayOrNSDictionary:jsonData];
}

///NSArray转为NSString
- (NSString*)ArrayToString:(NSArray*)array{
    return [array componentsJoinedByString:@","];
}

///NSString通过指定的分割符转为NSArray
- (NSArray*)StringToArray:(NSString*)str bySymbol:(NSString*)symbol{
    if (!str || str.length == 0) {
        return [NSArray array];
    }else if (symbol && symbol.length >0){
        return [str componentsSeparatedByString:symbol];
    }else if ([str containsString:@","]) {
        return [str componentsSeparatedByString:@","];
    }else{
        return [NSArray arrayWithObjects:str, nil];
    }
}

///unicode转换为中文
- (NSString*)convertUnicodeString:(NSString*)unicodeStr{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
//    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
//                                                           mutabilityOption:NSPropertyListImmutable
//                                                                     format:NULL
//                                                           errorDescription:NULL];
    NSString* returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

///从指定文件名文件获取json内容
- (id)getJsonDataFromFileName:(NSString*)jsonName{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return result;
}

///字符串MD5加密
- (NSString*)getMD5withStr:(NSString*)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

///获取当前时间的时间戳
- (NSString*)getCurrentTimeStamp{
    return [self getTimeStampByDate:[NSDate date]];
}

///获取指定时间的时间戳
- (NSString*)getTimeStampByDate:(NSDate*)date{
    return [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]];
}

/**
 时间戳获取时间
 
 @param timeStamp 时间戳
 @param quickType 快速格式化时间，如果传None则自己定义foramatter
 @param formatter 自己定义foramatter
 @return 格式化过的时间
 */
- (NSString*)getTimeFromTimeStamp:(NSString*)timeStamp andQuickFormatType:(HDQuickFormatType)quickType orCustomFormatter:(NSDateFormatter*)formatter{
    NSDateFormatter *temp_formatter;
    switch (quickType) {
        case kHDQuickFormateTypeNone:
        {
        if (!formatter) {
            temp_formatter = [[NSDateFormatter alloc] init];
            [temp_formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        }
        else{
            temp_formatter = formatter;
        }
        }
            break;
        case kHDQuickFormateTypeYMD:
        {
        temp_formatter = [[NSDateFormatter alloc] init];
        [temp_formatter setDateFormat:@"yyyy-MM-dd"];
        }
            break;
        case kHDQuickFormateTypeMD:
        {
        temp_formatter = [[NSDateFormatter alloc] init];
        [temp_formatter setDateFormat:@"MM-dd"];
        }
            break;
        case kHDQuickFormateTypeYMDTime:
        {
        temp_formatter = [[NSDateFormatter alloc] init];
        [temp_formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        }
            break;
        case kHDQuickFormateTypeTime:
        {
        temp_formatter = [[NSDateFormatter alloc] init];
        [temp_formatter setDateFormat:@"hh:mm:ss"];
        }
            break;
        case kHDQuickFormateTypeMDTime:
        {
        temp_formatter = [[NSDateFormatter alloc] init];
        [temp_formatter setDateFormat:@"MM-dd hh:mm"];
        }
            break;
        default:
            break;
    }
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    NSString* dateString = [temp_formatter stringFromDate:date];
    return dateString;
}
@end
