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
    [self.simulateArray removeAllObjects];
    NSArray *data = [successInfo objectForKey:@"data"];
    for (NSDictionary *dic in data) {
        TestChapterModel *chapterModel = [[TestChapterModel alloc] init];
        chapterModel.chapterId = [[dic objectForKey:@"id"] intValue];
        chapterModel.chapterName = [dic objectForKey:@"name"];
        chapterModel.chapterQuestionCount = [[dic objectForKey:@"questionCount"] intValue];
        //        chapterModel.chapterParentId = [[dic objectForKey:@"parentId"] intValue];
        NSArray *sections = [dic objectForKey:@"chaptersonlist"];
        for (NSDictionary *secDic in sections) {
            
            TestSectionModel *sectionModel = [[TestSectionModel alloc] init];
            sectionModel.sectionId = [[secDic objectForKey:@"id"] intValue];
            sectionModel.sectionName = [secDic objectForKey:@"name"];
            sectionModel.sectionQuestionCount = [[secDic objectForKey:@"questionCount"] intValue];
            [chapterModel.sectionArray addObject:sectionModel];
        }
        [self.collectChapterArray addObject:chapterModel];
    }
    
    NSArray *simulateSata = [successInfo objectForKey:@"simulateData"];
    for (NSDictionary *dic in simulateSata) {
        TestSimulateModel *model = [[TestSimulateModel alloc] init];
        model.simulateId = [[dic objectForKey:@"id"] intValue];
        model.simulateName = [dic objectForKey:@"name"];
        model.simulateQuestionCount = [[dic objectForKey:@"questionCount"] intValue];
        [self.simulateArray addObject:model];
    }
    
//    NSArray *data = [successInfo objectForKey:@"data"];
//    for (NSDictionary *dic in data) {
//        TestChapterModel *model = [[TestChapterModel alloc] init];
//        model.chapterId = [[dic objectForKey:@"id"] intValue];
//        model.chapterName = [dic objectForKey:@"name"];
//        model.chapterQuestionCount = [[dic objectForKey:@"questionCount"] intValue];
//        [self.collectChapterArray addObject:model];
//    }
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
