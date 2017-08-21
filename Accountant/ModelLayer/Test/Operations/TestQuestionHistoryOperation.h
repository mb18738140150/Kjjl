//
//  TestQuestionHistoryOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/30.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestModuleProtocol.h"
#import "TestModuleModels.h"

@interface TestQuestionHistoryOperation : NSObject

@property (nonatomic,weak) id<TestModule_AddHistoryProtocol>         notifiedObject;
@property (nonatomic,weak) TestModuleModels                         *moduleModel;

- (void)didRequesAddQuestionHistoryWithInfo:(NSDictionary *)info andNotifedObject:(id<TestModule_AddHistoryProtocol>)object;
- (void)didRequestAddQuestionHistoryDetailWithInfo:(NSDictionary *)info;

@end
