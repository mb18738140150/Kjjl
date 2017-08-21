//
//  AllCourseModel.h
//  Accountant
//
//  Created by aaa on 2017/3/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModel.h"

@interface AllCourseModel : NSObject

@property (nonatomic,strong) NSMutableArray         *allCourseModels;

- (void)removeAllCourses;

- (void)addCourseModel:(CourseModel *)model;

@end
