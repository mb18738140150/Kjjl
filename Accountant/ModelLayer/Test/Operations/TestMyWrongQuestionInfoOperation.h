//
//  TestMyWrongQuestionInfoOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestModuleProtocol.h"
#import "TestSectionModel.h"

@interface TestMyWrongQuestionInfoOperation : NSObject

@property (nonatomic,weak) id<TestModule_MyWrongQuestionsListProtocol>       notifiedObject;

@property (nonatomic,weak) TestSectionModel                                 *currentTestSection;

- (void)didRequestMyWrongQuestionListWithChapterId:(NSDictionary *)chapterId andNotifiedObject:(id<TestModule_MyWrongQuestionsListProtocol>)object;

@end
