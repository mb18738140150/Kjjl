//
//  HotSearchOperation.h
//  Accountant
//
//  Created by aaa on 2017/7/8.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HottestCourseModel.h"
#import "CourseModuleProtocol.h"

@interface HotSearchOperation : NSObject

- (void)setCurrentHotSearchVideoCoursesWithModel:(HottestCourseModel *)model;
- (void)setCurrentHotSearchLiveStreamWithModel:(HottestCourseModel *)model;
- (void)didRequestHotSearchCoursesWithNotifiedObject:(id<CourseModule_HotSearchProtocol>)delegate;

@end
