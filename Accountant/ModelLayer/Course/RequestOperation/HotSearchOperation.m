//
//  HotSearchOperation.m
//  Accountant
//
//  Created by aaa on 2017/7/8.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "HotSearchOperation.h"
#import "HttpRequestManager.h"
#import "CourseModel+HottestCourse.h"
#import "NotificaitonMacro.h"

#define kCover @"cover"

@interface HotSearchOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) HottestCourseModel       *searchVideoCourseModel;
@property (nonatomic,weak) HottestCourseModel       *liveStreamModel;
@property (nonatomic,weak) id<CourseModule_HotSearchProtocol>             notifiedObject;

@end

@implementation HotSearchOperation


- (void)setCurrentHotSearchVideoCoursesWithModel:(HottestCourseModel *)model
{
     self.searchVideoCourseModel = model;
}
- (void)setCurrentHotSearchLiveStreamWithModel:(HottestCourseModel *)model
{
    self.liveStreamModel = model;
}
- (void)didRequestHotSearchCoursesWithNotifiedObject:(id<CourseModule_HotSearchProtocol>)delegate
{
    self.notifiedObject = delegate;
    [[HttpRequestManager sharedManager] requestHotSearchCourseDelegate:self];
}

#pragma mark - http delegate
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.searchVideoCourseModel removeAllCourses];
    
    NSArray *courses = [successInfo objectForKey:@"VideoData"];
    for (NSDictionary *dic in courses){
        CourseModel *courseModel = [[CourseModel alloc] initWithHosttestDicInfo:dic];
        [self.searchVideoCourseModel addCourse:courseModel];
    }
    
    NSArray *livingcourses = [successInfo objectForKey:@"LivingStreamData"];
    for (NSDictionary *dic in livingcourses){
        CourseModel *courseModel = [[CourseModel alloc] initWithHosttestDicInfo:dic];
        [self.liveStreamModel addCourse:courseModel];
    }
    
    if (self.notifiedObject != nil) {
        [self.notifiedObject didRequestHotSearchCourseSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (self.notifiedObject != nil) {
        [self.notifiedObject didRequestHotSearchCourseFailed:failInfo];
    }
}

@end
