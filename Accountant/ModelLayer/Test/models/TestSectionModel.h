//
//  TestSectionModel.h
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestQuestionModel.h"

@interface TestSectionModel : NSObject

@property (nonatomic,assign) int             sectionId;
@property (nonatomic,assign) int             totalQuestionCount;
@property (nonatomic, assign)int             sectionQuestionCount;
@property (nonatomic,strong) NSString       *sectionName;
@property (nonatomic,strong) NSMutableArray *questionArray;


- (void)removeAllQuestion;
- (void)addQuestion:(TestQuestionModel *)test;

@end
