//
//  CourseCategoryDetailModel.h
//  Accountant
//
//  Created by aaa on 2017/3/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModel.h"
#import "CourseCategorysecondModel.h"
@interface CourseCategoryDetailModel : NSObject

@property (nonatomic,strong) NSString       *categoryName;
@property (nonatomic,assign) int             categoryId;
@property (nonatomic,strong) NSString       *categoryCoverUrl;

@property (nonatomic,strong) NSMutableArray *courseModels;

- (void)removeAllCourses;

- (void)addCourse:(CourseCategorysecondModel *)model;

@end
