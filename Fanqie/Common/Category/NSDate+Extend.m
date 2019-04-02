//
//  NSDate+Extend.m
//  Tracker_care_iOS
//
//  Created by luffy on 15/6/19.
//  Copyright (c) 2015年 Jimi. All rights reserved.
//

#import "NSDate+Extend.h"

@implementation NSDate (Extend)

+ (NSString*)getDateStringWithSecond:(NSInteger)second
{
    NSInteger hours = second/3600;
    NSInteger minite = (second%3600)/60;
    NSInteger curSecond = second%60;
    
    NSString* string = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",(long)hours,(long)minite,(long)curSecond];
    return string;
}

+ (NSString*)getDateStringWithMillisecond:(NSInteger)millisecond
{
    NSInteger second = millisecond/1000;
    NSInteger hours = second/3600;
    NSInteger minite = (second%3600)/60;
    NSInteger curSecond = second%60;
    
    NSString* string = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",(long)hours,(long)minite,(long)curSecond];
    return string;
    
}

//小于1小时则显示多少分钟，小于1天则显示多少小时。大于1天则显示多少天
+ (NSString*)getTimeWithSecond:(NSInteger)second
{
    NSInteger days = second/(3600*24);
    NSInteger hours = second/3600 - days*24;
    NSInteger minite = (second%3600)/60;
    NSInteger curSecond = second%60;
    if (days) return [NSString stringWithFormat:@"%zd 天", days];
    if (hours) return [NSString stringWithFormat:@"%zd 时", hours];
    
    if (minite) return [NSString stringWithFormat:@"%zd 分钟", minite];
    
    if (curSecond) return @"";
    return @"";
}

+ (NSString*)getChStringWithSecond:(NSInteger)second
{
//    NSInteger hours = second/3600;
//    NSInteger minite = (second%3600)/60;
//    NSInteger curSecond = second%60;

//    if(hours){
//        NSString* string = [NSString stringWithFormat:@"%ld%@%ld%@%ld%@",(long)hours,DNSLocalizedString(@"common_hour", @"小时"),(long)minite,DNSLocalizedString(@"common_minute", @"分"),(long)curSecond,DNSLocalizedString(@"common_second", @"秒")];
//        return string;
//    }else{
//        NSString* string = [NSString stringWithFormat:@"%ld%@%ld%@",(long)minite,DNSLocalizedString(@"common_minute", @"分钟"),(long)curSecond,DNSLocalizedString(@"common_second", @"秒")];
//        return string;
//    }
    return @"";
}

+ (NSString*)getIntervalTimeStrWithSecond:(NSInteger)second
{
//    NSInteger days = second/(3600*24);
//    NSInteger hours = second/3600 - days*24;
//    NSInteger minite = (second%3600)/60;
//    NSInteger curSecond = second%60;
//    
//    NSString *day = [NSString stringWithFormat:@"%zd%@ ", days,DNSLocalizedString(@"command_day", @"天")];
//    NSString *hour = [NSString stringWithFormat:@"%zd:", hours];
//    NSString *min = [NSString stringWithFormat:@"%zd\'", minite];
//    NSString *sec = [NSString stringWithFormat:@"%zd\"", curSecond];
//    
//    NSString *intervalStr = @"";
//    if (days>0) intervalStr = [intervalStr stringByAppendingString:day];
//    if (hours>0 || days>0) intervalStr = [intervalStr stringByAppendingString:hour];
//    if (minite>0 || hours>0 || days>0) intervalStr = [intervalStr stringByAppendingString:min];
//    if (curSecond>0 || minite>0 || hours>0 || days>0) intervalStr = [intervalStr stringByAppendingString:sec];
    
//    return intervalStr;
    
    NSInteger hours = second/3600;
    NSInteger minite = (second%3600)/60;
    NSInteger curSecond = second%60;
    
    if(hours){
        NSString* string = [NSString stringWithFormat:@"%zd:%zd\'%zd\"", hours,minite,curSecond];
        return string;
    }
    if (minite) {
        NSString* string = [NSString stringWithFormat:@"%zd\'%zd\"", minite,curSecond];
        return string;
    }
    
    NSString* string = [NSString stringWithFormat:@"%zd\"",curSecond];
    return string;
}

+ (long )getMonthBeginAndEndWith:(NSString *)dateStr First:(BOOL)first{
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月"];
    NSDate *newDate=[format dateFromString:dateStr];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];
    //设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为
//    NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
        
    }else {
        return 0;
    }
    if (first) {
        return (long)[beginDate timeIntervalSince1970]*1000;
    }else{
        return (long)[endDate timeIntervalSince1970]*1000;
    }
    
}

+ (NSString*)getDateStringWithAllDate:(NSInteger)second
{
    second = second/1000;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:second]];
}
+ (NSString*)getDateStringWithAllDateYYMMdd:(long)second
{
    second = second/1000;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSString*dateString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:second]];
    return dateString;
}
+(NSString*)getDateStringWithAllDateMMdd:(long)second{
    second = second/1000;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSString*dateString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:second]];
    return dateString;
}
//[NSDate getDay:aDate withNextOrPrevious:NO]
+ (NSDate *)getDay:(NSDate *)aDate withNextOrPrevious:(BOOL)isNext{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    //这三个参数在iOS8后废弃, 建议使用 NSCalendarUnitHour这三个参数代替
    //NSHourCalendarUnit NSMinuteCalendarUnit NSSecondCalendarUnit
    comps = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:[[NSDate alloc] init]];
    
    if (isNext) {
        //下一天加上24小时
        [comps setHour:+24];
    }else{
        [comps setHour:-24];
    }
    
    [comps setMinute:0];
    [comps setSecond:0];
    NSDate *previousDate = [calendar dateByAddingComponents:comps toDate:aDate options:0];
    
    return previousDate;
}
+(NSString*)getYYYYMMddHHmmssDateStringWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}
+(NSString*)getYYYYMMDateStringWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY年MM月"];
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}
+(NSString*)getYYYYMMDateStringWithMonth:(int)month{
    //
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    
    [components setMonth:month];
    NSDate* date = [cal dateFromComponents:components];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY年MM月"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
+ (NSString *)getYYYYMMddFormatDateStringWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}

+(NSString *)getTimeStringWithTimeStringSince1970:(NSString *)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeInterval timeInterval = time.longLongValue / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *stringDate = [formatter stringFromDate:date];
    return stringDate;
}

+ (NSString *)getDateStartTime:(NSDate *)date {
    
    NSString *curTime = [self getLocationTime:date];
    NSString *dayStr = [curTime componentsSeparatedByString:@" "].firstObject;
    //start time
    NSString *startHourTime = @" 00:00:00";
    return [dayStr stringByAppendingString:startHourTime];
}

+ (NSString *)getDateEndTime:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dayStr = [formatter stringFromDate:date];
    
    //end time
    NSString *endtHourTime = @" 23:59:59";
    return [dayStr stringByAppendingString:endtHourTime];
}

// 获取当前是星期几
+ (NSInteger)getNowWeekday:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps = [calendar components:NSCalendarUnitWeekday fromDate:date];
    return comps.weekday;
}
+(NSInteger)getNowmonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps = [calendar components:NSCalendarUnitMonth fromDate:[NSDate date]];
    return comps.month;
}
///str yyyy-MM-dd HH:mm:ss -> date
+ (NSDate *)getLocationDate:(NSString *)dateStr {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:dateStr];
}

///转换日期"Asia/Shanghai" yyyy-MM-dd HH:mm:ss
+ (NSString *)getLocationTime:(NSDate *)date {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    return [dateFormatter stringFromDate:date];
}

///转换日期"GMT" -> "Asia/Shanghai" yyyy-MM-dd HH:mm:ss
+ (NSString *)getLocationTimeStr:(NSString *)dateStr {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    return [dateFormatter stringFromDate:date];
}



///获取这周日 yyyy-MM-dd HH:mm:ss
+ (NSDate *)getThisWeekSunday:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    return [cal dateFromComponents:components];
}

///获取上周日 yyyy-MM-dd HH:mm:ss
+ (NSDate *)getLastWeekSunday:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    
    [components setDay:([components day] - 7 - [NSDate getNowWeekday:date] + 1)];
    return [cal dateFromComponents:components];
}
+(NSDate*)getLastWeekLastday:(NSDate *)date{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    
    [components setDay:([components day] - 7 - [NSDate getNowWeekday:date] +7)];
    return [cal dateFromComponents:components];
}
///获取这个月一号 yyyy-MM-dd HH:mm:ss
+ (NSDate *)getThisMonthFirstday:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    
    [components setDay:([components day] - ([components day] -1))];
    return [cal dateFromComponents:components];
}

///获取这上月一号 yyyy-MM-dd HH:mm:ss
+ (NSDate *)getLastMonthFirstday:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    
    [components setMonth:([components month] - 1)];
    return [cal dateFromComponents:components];
}

+ (NSDate *)date:(NSString *)datestr WithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:datestr];
    return date;
}

///比较两个时间的大小
+(int)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *dateA = [dateFormatter dateFromString:oneDay];
    
    NSDate *dateB = [dateFormatter dateFromString:anotherDay];
    
    NSComparisonResult result = [dateA compare:dateB];
    
    if (result == NSOrderedDescending) {
        //NSLog(@"oneDay比 anotherDay时间晚");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"oneDay比 anotherDay时间早");
        return -1;
    }
    //NSLog(@"两者时间是同一个时间");
    return 0;
    
}

+ (NSInteger)getDifferenceByDate:(NSString *)date {
    //获得当前时间
    NSDate *now = [NSDate date];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *oldDate = [dateFormatter dateFromString:date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:oldDate  toDate:now  options:0];
    return [comps day];
}

- (NSInteger)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int uintFlags = NSCalendarUnitYear;
    NSDateComponents *dateComponents = [calendar components:uintFlags
                                                   fromDate:self];
    return [dateComponents year];
}

- (NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int uintFlags = NSCalendarUnitMonth;
    NSDateComponents *dateComponents = [calendar components:uintFlags
                                                   fromDate:self];
    return [dateComponents month];
}

- (NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int uintFlags = NSCalendarUnitDay;
    NSDateComponents *dateComponents = [calendar components:uintFlags
                                                   fromDate:self];
    return [dateComponents day];
}

- (NSInteger)hour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int uintFlags = NSCalendarUnitHour;
    NSDateComponents *dateComponents = [calendar components:uintFlags
                                                   fromDate:self];
    return [dateComponents hour];
}

- (NSInteger)minute
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int uintFlags = NSCalendarUnitMinute;
    NSDateComponents *dateComponents = [calendar components:uintFlags
                                                   fromDate:self];
    return [dateComponents minute];
}


+ (NSString*)getTimeStringWithFormatter:(NSString*)format TimeInterval:(long)timeInterval{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

+ (long)getTimeInterValWithFormatter:(NSString*)format DateString:(NSString*)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return [date timeIntervalSince1970];
}

///获取这前后几个月的今天 yyyy-MM-dd HH:mm:ss +-代表前后
+ (NSString *)getNearbyMonth:(int)months {
    //得到当前的时间
    NSDate * mydate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setMonth:months];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    NSString *nearDate = [dateFormatter stringFromDate:newdate];
    return nearDate;
}

+(long)getCurrentTimeStamp{
    NSDate*currentDate = [NSDate date];
    long timeStamp = (long)(currentDate.timeIntervalSince1970*1000);
    
    return timeStamp;
}
@end
