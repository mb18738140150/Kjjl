//
//  DetailCourseOperation.h
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModuleProtocol.h"
#import "DetailCourseModel.h"

@interface DetailCourseOperation : NSObject

- (void)setCurrentDetailCourse:(DetailCourseModel *)model;

- (void)requestDetailCourseWithID:(int)courseID withNotifiedObject:(id<CourseModule_DetailCourseProtocol>)object;

@end
