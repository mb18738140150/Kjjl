//
//  TestErrorInfoOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestModuleProtocol.h"

@interface TestErrorInfoOperation : NSObject

@property (nonatomic,weak) id<TestModule_ErrorInfoProtocol>          notifiedObject;
@property (nonatomic,weak) NSMutableArray                           *errorChapterArray;
@property (nonatomic,weak) NSMutableArray                           *simulateArray;
- (void)didRequestErrorInfoWithCategoryId:(int)cateId andNotifiedObject:(id<TestModule_ErrorInfoProtocol>)object;

@end
