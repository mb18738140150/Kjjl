//
//  TestSimulateQuestionOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/22.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestModuleProtocol.h"
#import "TestSimulateModel.h"

@interface TestSimulateQuestionOperation : NSObject

@property (nonatomic,weak) id<TestModule_SimulateQuestionProtocol>                   notifiedObject;
@property (nonatomic,weak) TestSimulateModel                                        *simulateModel;

- (void)didRequestSimulateQuestionWithTestId:(int)testId andNotifiedObject:(id<TestModule_SimulateQuestionProtocol>)object;

@end
