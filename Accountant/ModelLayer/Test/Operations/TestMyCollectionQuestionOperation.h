//
//  TestMyCollectionQuestionOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/30.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestModuleProtocol.h"

@interface TestMyCollectionQuestionOperation : NSObject

@property (nonatomic,weak) id<TestModule_CollectQuestionProtocol>          collectNotifiedObject;


- (void)didCollectQuestionWithQuestionId:(int)questionId andNotifiedObject:(id<TestModule_CollectQuestionProtocol>)object;


@end
