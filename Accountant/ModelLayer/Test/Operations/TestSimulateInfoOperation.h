//
//  TestSimulateInfoOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/22.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestModuleProtocol.h"

@interface TestSimulateInfoOperation : NSObject

@property (nonatomic,weak) id<TestModule_SimulateInfoProtocol>           notifiedObject;

@property (nonatomic,weak) NSMutableArray                               *simulateArray;

- (void)didRequestTestSimulateInfoWithCategoryId:(int)cateId andNotifiedObject:(id<TestModule_SimulateInfoProtocol>)object;

@end
