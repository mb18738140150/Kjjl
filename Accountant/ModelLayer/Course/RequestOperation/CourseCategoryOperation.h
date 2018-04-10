//
//  CourseCategoryOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/3.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModuleProtocol.h"
#import "AllCourseCategoryModel.h"


@interface CourseCategoryOperation : NSObject

- (void)setCurrentAllCourseCategoryModel:(AllCourseCategoryModel *)model;

- (void)didRequestAllCourseCategoryWithNotifiedObject:(id<CourseModule_AllCourseCategoryProtocol>)object;

@end
