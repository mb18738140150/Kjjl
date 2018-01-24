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

@property (nonatomic,strong) NSMutableArray                                   *learningCourseArray;
@property (nonatomic, strong)NSMutableArray                                   *completeCourseArray;

@property (nonatomic,weak) id<CourseModule_LearningCourseProtocol>           notifiedObject;
@property (nonatomic, weak)id<CourseModule_CompleteCourseProtocol>           complateNotifiedObject;

- (void)didRequestLearningCourseWith:(NSDictionary *)infoDic NotifiedObject:(id<CourseModule_LearningCourseProtocol>)object;

- (void)didRequestCompleteCourseWith:(NSDictionary *)infoDic NotifiedObject:(id<CourseModule_CompleteCourseProtocol>)object;
@end
