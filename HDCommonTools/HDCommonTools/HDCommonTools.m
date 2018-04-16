//
//  HDCommonTools.m
//  HDCommonTools
//
//  Created by Damon on 2018/2/15.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "HDCommonTools.h"
#import <UIKit/UIKit.h>

@implementation HDCommonTools
///工具的单例 singleton
+ (HDCommonTools *)sharedHDCommonTools {
    static HDCommonTools *aCommonTools;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aCommonTools = [[HDCommonTools alloc] init];
    });
    return aCommonTools;
}

/**
 将log打印信息输出到文件中，调用此函数后控制台将不再显示log的打印信息
 @return 返回打印信息所在的文件路径
 The log print information is exported to the file, and the console will no longer display the print information of the log after calling this function
 Returns the path of the file where the print information is located
 */
- (NSString *)setHdDebugLogToFile {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"HDNSLog.txt"];// 注意不是NSData!
    
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    // 先删除已经存在的文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:logFilePath error:nil];
    
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    return logFilePath;
}
#pragma mark -
#pragma mark - 数据处理类

/// 将字典或者数组转化为Data数据
//Translate dictionaries or arrays into Data
- (NSData *)JSONDataCreatedByArrayOrDictionary:(id)arrayOrDictionary {
    NSError *error = nil;
    if (!arrayOrDictionary) {
        NSAssert(NO, @"theData is nil");
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrayOrDictionary options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    } else {
        return nil;
    }
}

/// 将字典或者数组转化为json字符串数据
//Translate dictionaries or arrays into JSON string data
- (NSString *)JSONStrCreatedByArrayOrDictionary:(id)arrayOrDictionary {
    if (!arrayOrDictionary) {
        NSAssert(NO, @"theData is nil");
        return nil;
    }
    NSData *jsonData = [self JSONDataCreatedByArrayOrDictionary:arrayOrDictionary];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

/// 将JSON Data串转化为字典或者数组
//Converting the JSON string Data into a dictionary or array
- (id)arrayOrNSDictionaryCreatedByJSONData:(NSData *)jsonData {
    if (!jsonData) {
        NSAssert(NO, @"jsonData is nil");
        return nil;
    }
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if (jsonObject != nil && error == nil) {
        return jsonObject;
    } else {
        // 解析错误
        return nil;
    }
}

/// 将JSON串转化为字典或者数组
//Converting the JSON string into a dictionary or array
- (id)arrayOrNSDictionaryCreatedByJSONStr:(NSString *)jsonStr {
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    return [self arrayOrNSDictionaryCreatedByJSONData:jsonData];
}

///NSArray转为NSString
//Converting NSArray into NSString
- (NSString *)stringCreatedByArray:(NSArray *)array {
    return [array componentsJoinedByString:@","];
}

///NSString通过指定的分割符转为NSArray，如果symbol为空，则默认为","
//NSString turns to NSArray by the specified division, and if symbol is empty, the default is ","
- (NSArray *)arrayCreatedByString:(NSString *)str withSymbol:(NSString *)symbol {
    if (!str || str.length == 0) {
        return [NSArray array];
    } else if (symbol && symbol.length >0) {
        return [str componentsSeparatedByString:symbol];
    } else if ([str containsString:@","]) {
        return [str componentsSeparatedByString:@","];
    } else {
        return [NSArray arrayWithObjects:str, nil];
    }
}

///unicode转换为中文
//Unicode conversion to Chinese
- (NSString *)stringConvertWithUnicodeString:(NSString *)unicodeStr {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
//    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
//                                                           mutabilityOption:NSPropertyListImmutable
//                                                                     format:NULL
//                                                           errorDescription:NULL];
    NSString *returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

///从指定文件名文件获取json内容
//Getting the JSON content from the specified file name file
- (id)getObjectWithJSONFileName:(NSString *)jsonFileName {
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:jsonFileName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return result;
}

///是否是本地URL链接
///is it a local URL link
- (BOOL)isLocalURLLink:(NSString *)urlStr {
    return ![urlStr hasPrefix:@"http://"] && ![urlStr hasPrefix:@"https://"];
}

///URL字符串转为URL
///URL string to URL
- (NSURL *)urlCreatedByString:(NSString *)urlStr {
    if ([self isLocalURLLink:urlStr]) {
        return [NSURL fileURLWithPath:urlStr];
    }
    else{
        return [NSURL URLWithString:urlStr];
    }
}

///URL转为字符串
///URL into a string
- (NSString *)urlStrCreateByURL:(NSURL *)url {
    if ([self isLocalURLLink:url.absoluteString]) {
        return url.path;
    }
    else{
        return url.absoluteString;
    }
}

///UIApplication openURL无参数方式
///UIApplication openURL parameterless method
- (void)applicationOpenURL:(NSURL *)url {
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:[NSDictionary dictionary] completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
}
@end
