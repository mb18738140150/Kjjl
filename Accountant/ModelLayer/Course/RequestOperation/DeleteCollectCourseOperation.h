//
//  DeleteCollectCourseOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModuleProtocol.h"

@interface DeleteCollectCourseOperation : NSObject

@property (nonatomic,weak) id<CourseModule_DeleteCollectCourseProtocol>              notifiedObject;

- (void)didRequestDeleteCollectCourseWithId:(int)courseId andNotifiedObject:(id<CourseModule_DeleteCollectCourseProtocol>)object;

@end
