//
//  DailyPracticeQuestionOperation.h
//  Accountant
//
//  Created by aaa on 2018/1/20.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyPracticeQuestionOperation : NSObject

@property (nonatomic,weak) id<TestModule_TestDailyPracticeQuestion>        testDailyPracticeNotifiedObject;
@property (nonatomic,weak) TestSectionModel                                 *currentTestSection;
- (void)didRequestTestDailyPracticeQuestionWithInfo:(NSDictionary *)infoDic andNotifiedObject:(id<TestModule_TestDailyPracticeQuestion>)object;

@end
