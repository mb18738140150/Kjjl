//
//  DailyPracticeOperation.h
//  Accountant
//
//  Created by aaa on 2018/1/20.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyPracticeOperation : NSObject

@property (nonatomic,weak) id<TestModule_TestDailyPractice>        testDailyPracticeNotifiedObject;
@property (nonatomic, strong)NSArray * dataArray;
@property (nonatomic, strong)NSArray * lastDataArray;

- (void)didRequestTestDailyPracticeWithInfo:(NSDictionary *)infoDic andNotifiedObject:(id<TestModule_TestDailyPractice>)object;

@end
