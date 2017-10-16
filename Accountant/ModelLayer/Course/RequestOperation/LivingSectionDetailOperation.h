//
//  LivingSectionDetailOperation.h
//  Accountant
//
//  Created by aaa on 2017/9/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CourseModuleProtocol.h"
#import "HottestCourseModel.h"

@interface LivingSectionDetailOperation : NSObject

@property (nonatomic,weak) id<CourseModule_LivingSectionDetail>              notifiedObject;

- (void)setCurrentLivingSectionDetailWithModel:(HottestCourseModel *)model;
- (void)didRequestLivingSectionDetailWithInfo:(NSDictionary *)infoDic andNotifiedObject:(id<CourseModule_LivingSectionDetail>)object;

@end
