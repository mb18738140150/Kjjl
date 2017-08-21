//
//  LearningCourseOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModuleProtocol.h"

@interface LearningCourseOperation : NSObject

@property (nonatomic,weak) NSMutableArray                                   *learningCourseArray;

@property (nonatomic,weak) id<CourseModule_LearningCourseProtocol>           notifiedObject;

- (void)didRequestLearningCourseWithNotifiedObject:(id<CourseModule_LearningCourseProtocol>)object;

@end
