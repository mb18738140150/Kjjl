//
//  CollectCourseOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModuleProtocol.h"

@interface CollectCourseOperation : NSObject

@property (nonatomic,weak) NSMutableArray                               *collectCourseArray;

@property (nonatomic,weak) id<CourseModule_CollectCourseProtocol>        notifiedObject;

- (void)didRequestCollectCourseWithNotifiedObject:(id<CourseModule_CollectCourseProtocol>)object;

@end
