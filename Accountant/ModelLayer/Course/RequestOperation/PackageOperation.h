//
//  PackageOperation.h
//  Accountant
//
//  Created by aaa on 2018/4/8.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModuleProtocol.h"
#import "AllCourseCategoryModel.h"

@interface PackageOperation : NSObject

- (void)setCurrentAllPackageModel:(AllCourseCategoryModel *)model;

- (void)didRequestAllPackageWithNotifiedObject:(id<CourseModule_PackageProtocol>)object;

@end
