//
//  AllCourseOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AllCourseModel.h"
#import "CourseModuleProtocol.h"

@interface AllCourseOperation : NSObject

- (void)setCurrentAllCourseModel:(AllCourseModel *)model;

- (void)didRequestAllCourseWithNotifiedObject:(id<CourseModule_AllCourseProtocol>)delegate;

@end
