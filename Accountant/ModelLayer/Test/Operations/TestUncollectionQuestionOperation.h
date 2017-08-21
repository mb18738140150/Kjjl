//
//  TestUncollectionQuestionOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/30.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestModuleProtocol.h"

@interface TestUncollectionQuestionOperation : NSObject

@property (nonatomic,weak) id<TestModule_UncollectQuestionProtocol>        uncollectNotifiedObject;

- (void)didUncollectQuestionWithQuestionId:(int)questionId andNotifiedObject:(id<TestModule_UncollectQuestionProtocol>)object;

@end
