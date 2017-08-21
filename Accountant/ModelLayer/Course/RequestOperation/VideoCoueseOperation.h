//
//  VideoCoueseOperation.h
//  Accountant
//
//  Created by aaa on 2017/6/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HottestCourseModel.h"
#import "CourseModuleProtocol.h"
@interface VideoCoueseOperation : NSObject

- (void)setCurrentSearchVideoCoursesWithModel:(HottestCourseModel *)model;

- (void)didRequestSearchVideoCoursesWithkeyWord:(NSString *)keyword NotifiedObject:(id<CourseModule_VideoCourseProtocol>)delegate;

@end
