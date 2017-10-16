//
//  NSString+MD5.m
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (MD5)

- (NSString *)MD5
{
    const char *fooData = [self UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);

    NSMutableString *saveResult = [NSMutableString string];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }

    return saveResult;
}
- (NSString *)MD5_Cap
{
    const char *fooData = [self UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    
    NSMutableString *saveResult = [NSMutableString string];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02X", result[i]];
    }
    
    return saveResult;
}

+ (BOOL)judgeCurrentDay:(NSString * )livingTime
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    // 截止时间字符串格式
    NSString * expireDateStr = livingTime;
    
    expireDateStr = [[expireDateStr componentsSeparatedByString:@"~"] objectAtIndex:0];
    
    // 当前时间字符串格式
    NSString *nowDateStr = [dateFomatter stringFromDate:nowDate];
    // 截止时间data格式
    NSDate *expireDate = [dateFomatter dateFromString:expireDateStr];
    // 当前时间data格式
    nowDate = [dateFomatter dateFromString:nowDateStr];
    
    NSDateFormatter *dateFomatter1 = [[NSDateFormatter alloc] init];
    dateFomatter1.dateFormat = @"yyyy-MM-dd";
    
    NSString * exDateStr = [dateFomatter1 stringFromDate:expireDate];
    NSString * todayStr = [dateFomatter1 stringFromDate:nowDate];
    
    if ([exDateStr isEqualToString:todayStr]) {
        return YES;
    }
    return NO;
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:0];
    
    if (dateCom.year == 0 && dateCom.month == 0 && dateCom.day == 0) {
        return YES;
    }
    
    return NO;
}

+ (int )getCurrentMonth
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"MM";
    
    NSString * timeStr = [dateFomatter stringFromDate:nowDate];
    
    return timeStr.intValue;
}

@end
