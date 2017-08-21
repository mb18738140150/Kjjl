//
//  HistoryCourseOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModuleProtocol.h"

@interface HistoryCourseOperation : NSObject

@property (nonatomic,weak) NSMutableArray           *historyArray;

- (void)didRequestHistoryCourseWithNotifiedObject:(id<CourseModule_HistoryCourseProtocol>)notifiedObject;

- (void)didRequestAddHistoryCourseWithInfo:(NSDictionary *)info;

@end
