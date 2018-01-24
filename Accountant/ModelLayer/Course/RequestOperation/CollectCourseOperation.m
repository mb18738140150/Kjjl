//
//  CollectCourseOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CollectCourseOperation.h"
#import "HttpRequestManager.h"
#import "CourseraManager.h"
#import "CommonMacro.h"

@interface CollectCourseOperation ()<HttpRequestProtocol>

@end

@implementation CollectCourseOperation

- (NSMutableArray *)collectCourseArray
{
    if (!_collectCourseArray) {
        _collectCourseArray = [NSMutableArray array];
    }
    return _collectCourseArray;
}

- (void)didRequestCollectCourseWithNotifiedObject:(id<CourseModule_CollectCourseProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestCollectCourseWithProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.collectCourseArray removeAllObjects];
    NSArray *data = [successInfo objectForKey:@"data"];
    for (NSDictionary *dic in data) {
        CourseModel *model = [[CourseModel alloc] init];
        model.courseID = [[dic objectForKey:@"id"] intValue];
        model.courseName = [dic objectForKey:@"courseName"];
        model.courseCover = [dic objectForKey:@"cover"];
        model.coueseTeacherName = [dic objectForKey:@"teacherName"];
        if ([model.coueseTeacherName isKindOfClass:[NSNull class]]) {
            model.coueseTeacherName = @"";
        }
        [self.collectCourseArray addObject:model];
    }
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestCollectCourseSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestCollectCourseFailed:failInfo];
    }
}

@end
