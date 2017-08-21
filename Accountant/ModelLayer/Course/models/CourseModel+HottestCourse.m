//
//  CourseModel+HottestCourse.m
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CourseModel+HottestCourse.h"

@implementation CourseModel (HottestCourse)

- (instancetype)initWithHosttestDicInfo:(NSDictionary *)dicInfo
{
    if (self = [super init]) {
        self.courseName = [dicInfo objectForKey:@"courseName"];
        self.courseURLString = [dicInfo objectForKey:@"courseUrl"];
        self.courseCover = [dicInfo objectForKey:@"cover"];
        self.courseID = [[dicInfo objectForKey:@"id"] intValue];
        self.coueseTeacherName = [dicInfo objectForKey:@"teacherName"];
        if ([self.coueseTeacherName isKindOfClass:[NSNull class]] || !self.coueseTeacherName) {
            self.coueseTeacherName = @"";
        }
        self.time = [dicInfo objectForKey:@"time"];
        if ([self.time isKindOfClass:[NSNull class]] || !self.time) {
            self.time = @"";
        }
        NSNumber *playState = [dicInfo objectForKey:@"playState"];
        if ([playState isKindOfClass:[NSNull class]] ) {
            playState = @0;
        }
        self.playState = playState.intValue;
        
        self.teacherPortraitUrl = [dicInfo objectForKey:@"teacherPortraitUrl"];
        if ([self.teacherPortraitUrl isKindOfClass:[NSNull class]] || !self.teacherPortraitUrl) {
            self.teacherPortraitUrl = @"";
        }
        self.teacherDetail = [dicInfo objectForKey:@"teacherDetail"];
        if ([self.teacherDetail isKindOfClass:[NSNull class]] || !self.teacherDetail) {
            self.teacherDetail = @"暂无介绍";
        }
        self.livingDetail = [dicInfo objectForKey:@"livingDetail"];
        if ([self.livingDetail isKindOfClass:[NSNull class]] || !self.livingDetail) {
            self.livingDetail = @"暂无视频详情";
        }
        
    }
    return self;
}

@end
