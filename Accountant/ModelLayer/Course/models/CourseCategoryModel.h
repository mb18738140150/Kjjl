//
//  CourseCategoryModel.h
//  Accountant
//
//  Created by aaa on 2017/3/3.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModel.h"
#import "CourseCategorysecondModel.h"
#import "CourseCategorysecondModel.h"

@interface CourseCategoryModel : NSObject

@property (nonatomic,assign) int             categoryId;
@property (nonatomic,strong) NSString       *categoryName;
@property (nonatomic,strong) NSString       *categoryImageUrl;

@property (nonatomic,strong) NSMutableArray *categrorySecondCoursesArray;

- (void)addSecondCourseModel:(CourseCategorysecondModel *)model;

- (void)removeAllCourses;

@end
