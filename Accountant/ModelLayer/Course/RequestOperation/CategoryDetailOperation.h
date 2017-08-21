//
//  CategoryDetailOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseCategoryDetailModel.h"
#import "CourseModuleProtocol.h"

@interface CategoryDetailOperation : NSObject

- (void)setCurrentCourseCategoryDetailModel:(CourseCategoryDetailModel *)model;

- (void)didRequestCategoryDetailWithCategoryId:(int)categoryId andUserId:(int)userId withNotified:(id<CourseModule_CourseCategoryDetailProtocol>)object;

@end
