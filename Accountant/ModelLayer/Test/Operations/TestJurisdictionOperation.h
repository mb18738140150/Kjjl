//
//  TestJurisdictionOperation.h
//  Accountant
//
//  Created by aaa on 2017/9/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestModuleProtocol.h"
@interface TestJurisdictionOperation : NSObject

@property (nonatomic,weak) id<TestModule_JurisdictionProtocol>        jurisdictionNotifiedObject;

- (void)didJurisdictionWithCourseId:(int)courseId andNotifiedObject:(id<TestModule_JurisdictionProtocol>)object;

@end
