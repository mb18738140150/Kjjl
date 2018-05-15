//
//  LiveStreamOperation.m
//  Accountant
//
//  Created by aaa on 2017/6/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "LiveStreamOperation.h"
#import "HttpRequestManager.h"
#import "CourseModel+HottestCourse.h"
#import "NotificaitonMacro.h"
@interface LiveStreamOperation()<HttpRequestProtocol>
@property (nonatomic,weak) HottestCourseModel       *liveStreamModel;
@property (nonatomic,weak) id<CourseModule_LiveStreamProtocol>             notifiedObject;
@end

@implementation LiveStreamOperation

- (void)setCurrentSearchLiveStreamWithModel:(HottestCourseModel *)model
{
    self.liveStreamModel = model;
}

- (void)didRequestSearchliveStreamCoursesWithkeyWord:(NSString *)keyword NotifiedObject:(id<CourseModule_LiveStreamProtocol>)delegate
{
    self.notifiedObject = delegate;
    [[HttpRequestManager sharedManager] requestSearchLivestreamWithProcessKeyWord:keyword Delegate:self];
}

#pragma mark - http delegate
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.liveStreamModel removeAllCourses];
    
    NSArray *courses = [successInfo objectForKey:@"Data"];
    for (NSDictionary *dic in courses){
        CourseModel *courseModel = [[CourseModel alloc] initWithHosttestDicInfo:dic];
        [self.liveStreamModel addCourse:courseModel];
    }
    if (self.notifiedObject != nil) {
        [self.notifiedObject didRequestLiveStreamSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (self.notifiedObject != nil) {
        [self.notifiedObject didRequestLiveStreamFailed:failInfo];
    }
}


@end
