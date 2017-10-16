//
//  LivingSectionDetailOperation.m
//  Accountant
//
//  Created by aaa on 2017/9/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "LivingSectionDetailOperation.h"

#import "HottestCourseModel.h"
#import "HttpRequestManager.h"
#import "CourseModel+HottestCourse.h"
@interface LivingSectionDetailOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) HottestCourseModel       *hottestModel;
@end

@implementation LivingSectionDetailOperation

- (void)setCurrentLivingSectionDetailWithModel:(HottestCourseModel *)model
{
    self.hottestModel = model;
}

- (void)didRequestLivingSectionDetailWithInfo:(NSDictionary *)infoDic andNotifiedObject:(id<CourseModule_LivingSectionDetail>)delegate
{
    self.notifiedObject = delegate;
    [[HttpRequestManager sharedManager] requestGetLivingSectionDetailWithInfo:infoDic andProcessDelegate:self];
}

#pragma mark - http delegate
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.hottestModel removeAllCourses];
    
    NSArray *courses = [successInfo objectForKey:@"data"];
    for (NSDictionary *dic in courses){
        CourseModel *courseModel = [[CourseModel alloc] initWithHosttestDicInfo:dic];
        [self.hottestModel addCourse:courseModel];
    }
    if (self.notifiedObject != nil) {
        [self.notifiedObject didRequestLivingSectionDetailSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
     [self.hottestModel removeAllCourses];
    if (self.notifiedObject != nil) {
        [self.notifiedObject didRequestLivingSectionDetailFailed:failInfo];
    }
}

@end
