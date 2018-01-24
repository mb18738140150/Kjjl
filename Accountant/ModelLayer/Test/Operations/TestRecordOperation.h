//
//  TestRecordOperation.h
//  Accountant
//
//  Created by aaa on 2018/1/19.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestRecordOperation : NSObject

@property (nonatomic,weak) id<TestModule_TestRecord>        testRecordNotifiedObject;
@property (nonatomic, strong)NSArray * dataArray;

- (void)didRequestTestRecordWithInfo:(NSDictionary *)infoDic andNotifiedObject:(id<TestModule_TestRecord>)object;

@end
