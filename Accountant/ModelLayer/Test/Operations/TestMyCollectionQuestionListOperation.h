//
//  TestMyCollectionQuestionListOperation.h
//  Accountant
//
//  Created by aaa on 2017/6/24.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestModuleProtocol.h"
#import "TestSectionModel.h"

@interface TestMyCollectionQuestionListOperation : NSObject

@property (nonatomic, weak)id<TestModule_CollectQuestionListProtocol>notifiedObject;
@property (nonatomic, weak)TestSectionModel * currentTestSection;

- (void)didRequestTestMyCollectionQuestionListWithChapterId:(NSDictionary *)chapterId andNotifiedObject:(id<TestModule_CollectQuestionListProtocol>)object;

@end
