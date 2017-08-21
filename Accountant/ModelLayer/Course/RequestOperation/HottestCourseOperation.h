//
//  HottestCourseOperation.h
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HottestCourseModel.h"
#import "CourseModuleProtocol.h"

@interface HottestCourseOperation : NSObject

- (void)setCurrentHottestCoursesWithModel:(HottestCourseModel *)model;

- (void)didRequestHosttestCourseWithNotifiedObject:(id<CourseModule_HottestCourseProtocl>)delegate;

@end
