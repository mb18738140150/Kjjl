//
//  CourseCategorysecondModel.h
//  Accountant
//
//  Created by aaa on 2017/4/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModel.h"

@interface CourseCategorysecondModel : NSObject

@property (nonatomic,assign) int             categorySecondId;
@property (nonatomic,strong) NSString       *categorySecondName;
@property (nonatomic,strong) NSString       *categorySecondImageUrl;

@property (nonatomic,strong) NSMutableArray *categroryCoursesArray;

- (void)addCourseModel:(CourseModel *)model;

- (void)removeAllCourses;

@end
