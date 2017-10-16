//
//  HottestCourseModel.h
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModel.h"
#import "TeacherModel.h"

@interface HottestCourseModel : NSObject

@property (nonatomic,strong) NSMutableArray     *hottestCourses;

@property (nonatomic,strong) NSMutableArray     *teacherDataArray;

- (void)removeAllCourses;

- (void)addCourse:(CourseModel *)model;

- (void)addTeacher:(TeacherModel *)model;

@end
