//
//  TestSimulateScoreOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/22.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestModuleProtocol.h"
#import "TestSimulateModel.h"

@interface TestSimulateScoreOperation : NSObject

@property (nonatomic,weak) id<TestModule_SimulateScoreProtocol>              notifiedObject;
@property (nonatomic,weak) TestSimulateModel                                        *simulateResultModel;
- (void)didRequestSimulateScoreWithInfo:(NSArray *)array andNotifedObject:(id<TestModule_SimulateScoreProtocol>)object;

@end
