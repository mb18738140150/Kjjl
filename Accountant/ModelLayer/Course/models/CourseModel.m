//
//  CourseModel.m
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CourseModel.h"

@implementation CourseModel

- (NSString *)description
{
    NSMutableString *des = [[NSMutableString alloc] init];
    [des appendString:[NSString stringWithFormat:@"ID : %d,Name : %@,Cover : %@,URLString : %@",self.courseID,self.courseName,self.courseCover,self.courseURLString]];
    return des;
}

@end
