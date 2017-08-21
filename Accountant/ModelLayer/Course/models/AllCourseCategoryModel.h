//
//  AllCourseCategoryModel.h
//  Accountant
//
//  Created by aaa on 2017/3/3.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseCategoryModel.h"

@interface AllCourseCategoryModel : NSObject

@property (nonatomic,strong) NSMutableArray     *allCategory;

- (void)removeAllCategory;

- (void)addCategory:(CourseCategoryModel *)model;

@end
