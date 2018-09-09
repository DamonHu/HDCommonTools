//
//  HDCommonTools+Date.h
//  HDCommonTools
//
//  Created by Damon on 2018/4/9.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "HDBaseCommonTools.h"

@interface ChineseLunarCalendar : NSObject
/**
 *是否闰月
 */
@property (assign,nonatomic) BOOL isleap;
/**
 *农历 日
 */
@property (assign,nonatomic) int lunarDay;
/**
 *农历 月
 */
@property (assign,nonatomic) int lunarMonth;
/**
 *农历 年
 */
@property (assign,nonatomic) int lunarYear;

@end


@interface HDCommonTools (Date)

#pragma mark -
#pragma mark - 日期相关操作类

///获取指定时间的时间戳
//Get the timestamp of the specified time
- (NSString *)getTimestampWithDate:(NSDate *)date;

///通过时间戳获取时间
///Get the Date by timestamp
- (NSDate *)getDateWithTimestamp:(NSString *)timestamp;

/**
 通过时间戳获取时间字符串
 Getting time through a timestamp
 
 @param timestamp 时间戳
 @param quickFormatType 快速格式化时间 Fast formatting time type
 you define foramatter
 @return 格式化过的时间
 */
- (NSString *)getTimeWithTimestamp:(NSString *)timestamp withQuickFormatType:(HDQuickFormatType)quickFormatType;

/**
 通过时间戳获取时间字符串
 Getting time through a timestamp
 
 @param timestamp 时间戳
 @param formatter 自己定义foramatter  you define foramatter
 @return 格式化过的时间
 */
- (NSString *)getTimeWithTimestamp:(NSString *)timestamp withCustomFormatter:(NSDateFormatter *)formatter;

/**
 比较两个日期的先后顺序
 Compare the order of the two dates
 
 @param firstDay 第一个日期
 @param secondDay 第二个日期
 @param ignoreTime 是否忽略时间的比较 Whether or not to ignore the comparison of time
 @return 第一个日期和第二个日期比较的结果 the comparison between the first date and the second date
 NSOrderedAscending:第一个日期更早 The first date is earlier
 NSOrderedSame:两个日期一样 Two dates are the same
 NSOrderedDescending:第一个日期更晚 The first date is later
 */
- (NSComparisonResult)compareFirstDay:(NSDate *)firstDay withSecondDay:(NSDate *)secondDay withIgnoreTime:(BOOL)ignoreTime;

#pragma mark -
#pragma mark - 中国农历和公历转换、星座生肖

///通过时间获取中国农历的对象
//get Chinese lunar calendar by time
- (ChineseLunarCalendar *)getChineseLunarCalendarWithDate:(NSDate *)date;

///通过公历时间去创建中国农历的对象
//get the Chinese lunar calendar by the calendar time
- (ChineseLunarCalendar *)getChineseLunarCalendarWithYear:(int)year andMonth:(int)month andDay:(int)day;

///通过农历的年月日获取中国农历对象
//get Chinese lunar calendar by the lunar calendar
- (ChineseLunarCalendar *)getChineseLunarCalendarWithChineseLunarYear:(int)chineseLunaryear andChineseLunarMonth:(int)chineseLunarmonth andChineseLunarDay:(int)chineseLunarday andLeap:(BOOL)isleap;

///格式化农历的字符串
///Formatting the string of Chinese calendar
- (NSString *)getChineseLunarCalendarStrWithChineseLunarCalendar:(ChineseLunarCalendar *)chineseLunarCalendar withFormatType:(HDChineseLunarCalendarFormatType)chineseLunarCalendarFormatType;

///通过农历获取公历日期
///Get the date of the Gregorian calendar through the lunar calendar
- (NSDate *)getDateWithChineseLunarCalendar:(ChineseLunarCalendar *)chineseLunarCalendar;

///通过农历获取生肖
///Get the zodiac through the lunar calendar
- (HDChineseZodiac)getChineseZodiacWithYear:(int)year;

///通过日期获得星座
///Get the constellation by date
- (HDConstellation)getConstellationWithDate:(NSDate *)date;

@end
