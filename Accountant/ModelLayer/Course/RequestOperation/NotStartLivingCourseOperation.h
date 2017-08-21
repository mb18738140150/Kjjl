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
- (void)setCurrentNotStartLivingCourseWithModel:(HottestCourseModel *)model;
- (void)didRequestNotStartLivingCourseWithNotifiedObject:(id<CourseModule_NotStartLivingCourse>)object;

@end
