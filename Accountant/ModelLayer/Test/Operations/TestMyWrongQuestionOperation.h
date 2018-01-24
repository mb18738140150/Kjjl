//
//  TestMyWrongQuestionOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestModuleProtocol.h"

@interface TestMyWrongQuestionOperation : NSObject

- (void)didAddMyWrongQuestionWithQuestionId:(int)questionId;

@property (nonatomic,weak) id<TestModule_MyWrongQuestionInfoProtocol>      notifiedObject;
@property (nonatomic,weak) NSMutableArray       *myWrongChapterArray;
@property (nonatomic,weak) NSMutableArray                           *simulateArray;

- (void)didRequesMyWrongChapterWithCategoryId:(int)cateId andNotifiedObject:(id<TestModule_MyWrongQuestionInfoProtocol>)object;

@end
