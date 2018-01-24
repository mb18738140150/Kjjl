//
//  TestErrorQuestionOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestModuleProtocol.h"
#import "TestSectionModel.h"

@interface TestErrorQuestionOperation : NSObject

@property (nonatomic,weak) id<TestModule_ErrorQuestionProtocol>          notifiedObject;

@property (nonatomic,weak) TestSectionModel                                 *currentTestSection;

- (void)didRequestErrorQuestionWithSectionId:(NSDictionary *)sectionInfo andNotifiedObject:(id<TestModule_ErrorQuestionProtocol>)object;

@end
