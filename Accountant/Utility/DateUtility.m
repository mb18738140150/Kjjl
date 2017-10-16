//
//  DateUtility.m
//  Accountant
//
//  Created by aaa on 2017/3/6.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DateUtility.h"

@implementation DateUtility

+ (NSString *)getDateShowString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger currentYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger dateYear = [calendar component:NSCalendarUnitYear fromDate:date];
    if (currentYear != dateYear) {
        NSInteger dateMonth = [calendar component:NSCalendarUnitMonth fromDate:date];
        NSInteger dateDay = [calendar component:NSCalendarUnitDay fromDate:date];
        return [NSString stringWithFormat:@"%ld/%ld/%ld",(long)dateYear,(long)dateMonth,(long)dateDay];
    }
    
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateCom = [calendar components:unit fromDate:date toDate:[NSDate date] options:0];
    NSInteger year = dateCom.year;
    NSInteger month = dateCom.month;
    NSInteger day = dateCom.day;
    NSInteger hour = dateCom.hour;
    NSInteger min = dateCom.minute;
    NSInteger sec = dateCom.second;
    
    if (year != 0) {
        return [NSString stringWithFormat:@"%ld 年前",(long)year];
    }
    if (month != 0) {
        return [NSString stringWithFormat:@"%ld 个月前",(long)month];
    }
    if (day != 0) {
        return [NSString stringWithFormat:@"%ld 天前",(long)day];
    }
    if (hour != 0) {
        return [NSString stringWithFormat:@"%ld 小时前",(long)hour];
    }
    if (min != 0) {
        return [NSString stringWithFormat:@"%ld 分钟前",(long)min];
    }
    if (sec != 0) {
        return [NSString stringWithFormat:@"%ld 秒前",(long)sec];
    }
    return nil;
}

+ (NSString *)getLivingDateShowString:(NSString *)dateString
{
    NSLog(@"%@", dateString);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateFormatter * formatter1 = [[NSDateFormatter alloc]init];
    formatter1.dateFormat = @"HH:mm";
    
    NSString * dateStr = [formatter1 stringFromDate:date];
    
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateCom = [calendar components:unit fromDate:date ];
    
    NSInteger month = dateCom.month;
    NSInteger day1 = dateCom.day;
    
    NSDateComponents *cdateCom = [calendar components:unit fromDate:[NSDate date]];
    
    NSInteger cmonth = cdateCom.month;
    NSInteger cday = cdateCom.day;
    
    
    NSInteger day = 0;
    if (cmonth == month) {
        day = cday - day1;
    }else
    {
        day = 100;
    }
    
    if (day != 0) {
        if (day == 1) {
            return [NSString stringWithFormat:@"昨天 %@", dateStr];
        }else if (day == -1)
        {
            return [NSString stringWithFormat:@"明天 %@", dateStr];
        }else{
            return [NSString stringWithFormat:@"%ld月%ld日 %@", (long)month, (long)day1, dateStr];
        }
    }else
    {
        return [NSString stringWithFormat:@"今天 %@", dateStr];
    }
    
    return nil;
}

+ (NSString *)getCurrentDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str = [dateFormatter stringFromDate:[NSDate date]];
    return str;
}

+ (NSString *)getCurrentFormatDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
//    NSInteger interval = [zone secondsFromGMTForDate: date];
    
//    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
    NSString *str = [dateFormatter stringFromDate:date];
    return str;
}

+ (NSString *)getDateIdString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [NSDate date];
    NSString *str = [dateFormatter stringFromDate:date];
    NSString *str1 = [NSString stringWithFormat:@"%d%@",[[UserManager sharedManager] getUserId],str];
    return str1;
}

@end
