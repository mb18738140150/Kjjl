//
//  NotStartLivingCourseOperation.h
//  Accountant
//
//  Created by aaa on 2017/6/30.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModuleProtocol.h"
#import "HottestCourseModel.h"
@interface NotStartLivingCourseOperation : NSObject

@property (nonatomic,weak) id<CourseModule_NotStartLivingCourse>              notifiedObject;
@property (nonatomic, weak)id<CourseModule_MyLivingCourse>                   myNotifiedObject;

- (void)setCurrentNotStartLivingCourseWithModel:(HottestCourseModel *)model;

- (void)setMyLivingCourseWithModel:(HottestCourseModel *)model;

//- (void)setCurrentNotStartLivingSectionCourseWithModel:(HottestCourseModel *)model;
- (void)didRequestNotStartLivingCourseWithInfo:(NSDictionary *)infoDic NotifiedObject:(id<CourseModule_NotStartLivingCourse>)object;

- (void)didRequestMyLivingCourseWithInfo:(NSDictionary *)infoDic NotifiedObject:(id<CourseModule_MyLivingCourse>)object;

- (int)getIsHaveJurisdiction;

@end
