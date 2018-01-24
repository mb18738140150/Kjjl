//
//  TestRecordQuestionOperation.h
//  Accountant
//
//  Created by aaa on 2018/1/19.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestRecordQuestionOperation : NSObject
@property (nonatomic,weak) id<TestModule_TestRecordQuestion>        testRecordNotifiedObject;
@property (nonatomic,weak) TestSectionModel                                 *currentTestSection;
- (void)didRequestTestRecordQuestionWithInfo:(NSDictionary *)infoDic andNotifiedObject:(id<TestModule_TestRecordQuestion>)object;
@end
