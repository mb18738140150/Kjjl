//
//  TestMyCollectionInfoOperation.h
//  Accountant
//
//  Created by aaa on 2017/6/24.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestModuleProtocol.h"

@interface TestMyCollectionInfoOperation : NSObject

@property (nonatomic,weak) id<TestModule_CollectQuestionInfoProtocol>          collectInfoNotifiedObject;

@property (nonatomic,weak) NSMutableArray                           *collectChapterArray;

- (void)didRequestCollectInfoWithCategoryId:(int)cateId andNotifiedObject:(id<TestModule_CollectQuestionInfoProtocol>)object;

@end
