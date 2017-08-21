//
//  TestSimulateModel.h
//  Accountant
//
//  Created by aaa on 2017/3/22.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestQuestionModel.h"

@interface TestSimulateModel : NSObject

@property (nonatomic,strong) NSString       *simulateName;
@property (nonatomic,assign) int             simulateId;
@property (nonatomic,assign) int             simulateQuestionCount;

@property (nonatomic,strong) NSMutableArray *questionArray;

@property (nonatomic, strong) NSMutableArray *rightQuestionArr;
@property (nonatomic, strong) NSMutableArray *wrongQuestionArr;
@property (nonatomic, strong) NSMutableArray *singleQuestionArr;
@property (nonatomic, strong) NSMutableArray *multipleQuestionArr;
@property (nonatomic, strong) NSMutableArray *judgeQuestionArr;

- (void)removeAllQuestion;
- (void)addQuestion:(TestQuestionModel *)test;



@end
