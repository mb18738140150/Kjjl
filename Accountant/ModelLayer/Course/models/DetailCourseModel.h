//
//  DetailCourseModel.h
//  Accountant
//
//  Created by aaa on 2017/3/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChapterModel.h"
#import "CourseModel.h"

@interface DetailCourseModel : NSObject

@property (nonatomic,strong) CourseModel        *courseModel;

@property (nonatomic,strong) NSMutableArray     *chapters;

- (void)removeAllChapters;

- (void)addCourseChapter:(ChapterModel *)chapter;

@end
