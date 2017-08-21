//
//  TestMyCollectionInfoOperation.m
//  Accountant
//
//  Created by aaa on 2017/6/24.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestMyCollectionInfoOperation.h"
#import "HttpRequestManager.h"
#import "TestChapterModel.h"

@interface TestMyCollectionInfoOperation()<HttpRequestProtocol>

@end

@implementation TestMyCollectionInfoOperation

- (void)didRequestCollectInfoWithCategoryId:(int)cateId andNotifiedObject:(id<TestModule_CollectQuestionInfoProtocol>)object
{
    self.collectInfoNotifiedObject = object;
    [[HttpRequestManager sharedManager] requestTestCollectInfoWithCateId:cateId andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    NSLog(@"%@", [successInfo description]);
    
    [self.collectChapterArray removeAllObjects];
    NSArray *data = [successInfo objectForKey:@"data"];
    for (NSDictionary *dic in data) {
        TestChapterModel *model = [[TestChapterModel alloc] init];
        model.chapterId = [[dic objectForKey:@"id"] intValue];
        model.chapterName = [dic objectForKey:@"name"];
        model.chapterQuestionCount = [[dic objectForKey:@"questionCount"] intValue];
        [self.collectChapterArray addObject:model];
    }
    if (isObjectNotNil(self.collectInfoNotifiedObject)) {
        [self.collectInfoNotifiedObject didRequestCollectQuestionInfoSuccess];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.collectInfoNotifiedObject)) {
        [self.collectInfoNotifiedObject didRequestCollectQuestionInfoFailed:failInfo];
    }
}

@end
