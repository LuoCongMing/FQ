//
//  NSDate+Extend.h
//  Tracker_care_iOS
//
//  Created by luffy on 15/6/19.
//  Copyright (c) 2015年 Jimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extend)

+ (NSString*)getDateStringWithSecond:(NSInteger)second;

+ (NSString*)getDateStringWithMillisecond:(NSInteger)millisecond;

+ (NSString*)getChStringWithSecond:(NSInteger)second;

+ (NSString*)getDateStringWithAllDate:(NSInteger)second;

+ (NSString*)getDateStringWithAllDateYYMMdd:(long)second;

+ (NSString*)getDateStringWithAllDateMMdd:(long)second;

/// dateStr 2018年10月
+ (long )getMonthBeginAndEndWith:(NSString *)dateStr First:(BOOL)first;

/**
 获取上一天或者下一天的时间

 @param aDate 指定的时间
 @param isNext 是否是下一天 YES为下一天, NO为后一天时间
 @return 指定时间的前一天或者后一天
 */
+ (NSDate *)getDay:(NSDate *)aDate withNextOrPrevious:(BOOL)isNext;

////获取YYYY-MM-dd HH:mm:ss形式日期
+(NSString*)getYYYYMMddHHmmssDateStringWithDate:(NSDate*)date;
////获取YYYY年MM形式日期
+(NSString*)getYYYYMMDateStringWithDate:(NSDate*)date;
////获取YYYY年MM形式日期
+(NSString*)getYYYYMMDateStringWithMonth:(int)month;
//获取YYYY-MM-dd形式日期
+(NSString *)getYYYYMMddFormatDateStringWithDate:(NSDate *)date;

//获取时间戳时间
+(NSString *)getTimeStringWithTimeStringSince1970:(NSString *)time;

///获取日期当天起点 yyyy-MM-dd HH:mm:ss
+(NSString *)getDateStartTime:(NSDate *)date;

///获取日期当天终点 yyyy-MM-dd HH:mm:ss
+(NSString *)getDateEndTime:(NSDate *)date;

///获取当前是星期几 dd
+ (NSInteger)getNowWeekday:(NSDate *)date;

///获取当前月份
+(NSInteger)getNowmonth;

///str yyyy-MM-dd HH:mm:ss -> date
+ (NSDate *)getLocationDate:(NSString *)dateStr;

///转换日期"GMT" -> "Asia/Shanghai" yyyy-MM-dd HH:mm:ss
+ (NSString *)getLocationTime:(NSDate *)date;
///转换日期"GMT" -> "Asia/Shanghai" yyyy-MM-dd HH:mm:ss
+ (NSString *)getLocationTimeStr:(NSString *)dateStr;

///获取这周日 yyyy-MM-dd HH:mm:ss
+ (NSDate *)getThisWeekSunday:(NSDate *)date;

///获取上周日 yyyy-MM-dd HH:mm:ss
+ (NSDate *)getLastWeekSunday:(NSDate *)date;
///获取上周最后一天 yyyy-MM-dd HH:mm:ss
+ (NSDate *)getLastWeekLastday:(NSDate *)date;

///获取这个月一号 yyyy-MM-dd HH:mm:ss
+ (NSDate *)getThisMonthFirstday:(NSDate *)date;

///获取这上月一号 yyyy-MM-dd HH:mm:ss
+ (NSDate *)getLastMonthFirstday:(NSDate *)date;

///小于1小时则显示多少分钟，小于1天则显示多少小时。大于1天则显示多少天
+ (NSString*)getTimeWithSecond:(NSInteger)second;

+ (NSString*)getIntervalTimeStrWithSecond:(NSInteger)second;

+ (NSDate *)date:(NSString *)datestr WithFormat:(NSString *)format;
///比较两个时间的大小
+(int)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay;

///比较与当前时间相差多少天
+ (NSInteger)getDifferenceByDate:(NSString *)date;
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;

///时间戳和时间格式返回对应的时间字符串
+ (NSString*)getTimeStringWithFormatter:(NSString*)format TimeInterval:(long)timeInterval;
///日期字符串转时间戳
+ (long)getTimeInterValWithFormatter:(NSString*)format DateString:(NSString*)dateString;
///获取附近几个月 months分正负 
+ (NSString *)getNearbyMonth:(int)months;
///获取当前时间戳
+(long)getCurrentTimeStamp;

@end
