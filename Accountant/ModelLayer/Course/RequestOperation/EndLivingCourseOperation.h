//
//  EndLivingCourseOperation.h
//  Accountant
//
//  Created by aaa on 2017/6/30.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModuleProtocol.h"
#import "HottestCourseModel.h"

@interface EndLivingCourseOperation : NSObject

@property (nonatomic,weak) id<CourseModule_EndLivingCourse>              notifiedObject;
- (void)setCurrentEndLivingCourseWithModel:(HottestCourseModel *)model;
- (void)didRequestEndLivingCourseWithNotifiedObject:(id<CourseModule_EndLivingCourse>)object;

@end
