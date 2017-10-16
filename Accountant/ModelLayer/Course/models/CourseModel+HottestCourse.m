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
        if (![[dicInfo objectForKey:@"courseUrl"] isKindOfClass:[NSNull class]] && [dicInfo objectForKey:@"courseUrl"]) {
            self.courseURLString = [dicInfo objectForKey:@"courseUrl"];
        }
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
        
        NSNumber *sectionId = [dicInfo objectForKey:@"sectionId"];
        if ([sectionId isKindOfClass:[NSNull class]] ) {
            sectionId = @0;
        }
        self.sectionId = sectionId.intValue;
        
        NSNumber *isFree = [dicInfo objectForKey:@"isFree"];
        if ([isFree isKindOfClass:[NSNull class]] ) {
            isFree = @0;
        }
        self.isFree = isFree.intValue;
        
        NSNumber *haveJurisdiction = [dicInfo objectForKey:@"haveJurisdiction"];
        if ([haveJurisdiction isKindOfClass:[NSNull class]] ) {
            haveJurisdiction = @1;
        }
        self.haveJurisdiction = haveJurisdiction.intValue;
        
        self.chatRoomId = @"";
        if (![[dicInfo objectForKey:@"chatRoomId"] isKindOfClass:[NSNull class]] && [dicInfo objectForKey:@"chatRoomId"]) {
            self.chatRoomId = [dicInfo objectForKey:@"chatRoomId"];
        }
        
        self.assistantId = @"";
        if (![[dicInfo objectForKey:@"assistantId"] isKindOfClass:[NSNull class]] && [dicInfo objectForKey:@"assistantId"]) {
            self.assistantId = [dicInfo objectForKey:@"assistantId"];
        }
        
        if (![[dicInfo objectForKey:@"playback"] isKindOfClass:[NSNull class]] && [dicInfo objectForKey:@"playback"]) {
            self.playback = [dicInfo objectForKey:@"playback"];
        }
        
        self.lastTime = @"";
        if (![[dicInfo objectForKey:@"lastTime"] isKindOfClass:[NSNull class]] && [dicInfo objectForKey:@"lastTime"]) {
            self.lastTime = [dicInfo objectForKey:@"lastTime"];
        }
        
        
    }
    return self;
}

@end
