//
//  AddCollectCourseOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModuleProtocol.h"

@interface AddCollectCourseOperation : NSObject

@property (nonatomic,weak) id<CourseModule_AddCollectCourseProtocol>             notifiedObject;

- (void)didRequestAddCollectCourseWithId:(int)courseId andNotifiedObject:(id<CourseModule_AddCollectCourseProtocol>)object;

@end
