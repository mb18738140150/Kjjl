//
//  DateUtility.h
//  Accountant
//
//  Created by aaa on 2017/3/6.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtility : NSObject

+ (NSString *)getDateShowString:(NSString *)dateString;

+ (NSString *)getCurrentFormatDateString;

+ (NSString *)getLivingDateShowString:(NSString *)dateString;

+ (NSString *)getCurrentDateString;

+ (NSString *)getDateIdString;

@end
