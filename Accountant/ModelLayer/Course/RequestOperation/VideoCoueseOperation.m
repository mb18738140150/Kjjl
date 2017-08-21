//
//  VideoCoueseOperation.m
//  Accountant
//
//  Created by aaa on 2017/6/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "VideoCoueseOperation.h"
#import "HttpRequestManager.h"
#import "CourseModel+HottestCourse.h"
#import "NotificaitonMacro.h"
@interface VideoCoueseOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) HottestCourseModel       *searchVideoCourseModel;
@property (nonatomic,weak) id<CourseModule_VideoCourseProtocol>             notifiedObject;

@end

@implementation VideoCoueseOperation

- (void)setCurrentSearchVideoCoursesWithModel:(HottestCourseModel *)model
{
    self.searchVideoCourseModel = model;
}

- (void)didRequestSearchVideoCoursesWithkeyWord:(NSString *)keyword NotifiedObject:(id<CourseModule_VideoCourseProtocol>)delegate;
{
    self.notifiedObject = delegate;
    [[HttpRequestManager sharedManager] requestSearchVideoCoueseWithProcessKeyWord:keyword Delegate:self];
}

#pragma mark - http delegate
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.searchVideoCourseModel removeAllCourses];
    
        NSLog(@"%@", [successInfo description]);
    
    NSArray *courses = [successInfo objectForKey:@"Data"];
    for (NSDictionary *dic in courses){
        CourseModel *courseModel = [[CourseModel alloc] initWithHosttestDicInfo:dic];
        [self.searchVideoCourseModel addCourse:courseModel];
    }
    if (self.notifiedObject != nil) {
        [self.notifiedObject didRequestVideoCourseSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (self.notifiedObject != nil) {
        [self.notifiedObject didRequestVideoCourseFailed];
    }
}

@end
