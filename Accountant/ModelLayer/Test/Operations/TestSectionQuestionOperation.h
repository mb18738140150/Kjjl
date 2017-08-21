//
//  TestSectionQuestionOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/22.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestModuleProtocol.h"
#import "TestSectionModel.h"

@interface TestSectionQuestionOperation : NSObject

@property (nonatomic,weak) id<TestModule_SectionQuestionProtocol>            notifiedObject;

@property (nonatomic,weak) TestSectionModel                                 *currentTestSection;

- (void)didRequestSectionQuestionWithSectionId:(int)sectionId andNotifiedObject:(id<TestModule_SectionQuestionProtocol>)object;

@end
