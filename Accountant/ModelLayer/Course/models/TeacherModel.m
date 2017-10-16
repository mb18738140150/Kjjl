//
//  TeacherModel.m
//  Accountant
//
//  Created by aaa on 2017/9/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TeacherModel.h"

@implementation TeacherModel

- (instancetype)initWithInfoDic:(NSDictionary *)infoDic
{
    
    self = [super init];
    if (self) {
        self.teacherName = @"";
        if (![[infoDic objectForKey:@"teacherName"] isKindOfClass:[NSNull class]] && [infoDic objectForKey:@"teacherName"]) {
            self.teacherName = [infoDic objectForKey:@"teacherName"];
        }
        
        self.teacherId = @"";
        if (![[infoDic objectForKey:@"teacherId"] isKindOfClass:[NSNull class]] && [infoDic objectForKey:@"teacherId"]) {
            self.teacherId = [infoDic objectForKey:@"teacherId"];
        }
        
    }
    return self;
}

@end
