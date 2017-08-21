//
//  TestChapterOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestModuleProtocol.h"

@interface TestChapterOperation : NSObject

@property (nonatomic,weak) NSMutableArray                                   *testChapterArray;

@property (nonatomic,weak) id<TestModule_ChapterInfoProtocol>                notifiedObject;

- (void)didRequestTestChapterInfoWithCategoryId:(int)cateId andNotifiedObject:(id<TestModule_ChapterInfoProtocol>)object;

@end
