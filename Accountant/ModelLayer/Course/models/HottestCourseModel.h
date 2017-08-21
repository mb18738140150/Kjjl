//
//  HottestCourseModel.h
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModel.h"

@interface HottestCourseModel : NSObject

@property (nonatomic,strong) NSMutableArray     *hottestCourses;

- (void)removeAllCourses;

- (void)addCourse:(CourseModel *)model;

@end
