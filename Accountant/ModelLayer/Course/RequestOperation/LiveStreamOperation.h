//
//  LiveStreamOperation.h
//  Accountant
//
//  Created by aaa on 2017/6/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HottestCourseModel.h"
#import "CourseModuleProtocol.h"
@interface LiveStreamOperation : NSObject

- (void)setCurrentSearchLiveStreamWithModel:(HottestCourseModel *)model;

- (void)didRequestSearchliveStreamCoursesWithkeyWord:(NSString *)keyword NotifiedObject:(id<CourseModule_LiveStreamProtocol>)delegate;

@end
