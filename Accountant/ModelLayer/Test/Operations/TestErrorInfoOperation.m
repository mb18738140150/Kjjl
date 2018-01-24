//
//  TestErrorInfoOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestErrorInfoOperation.h"
#import "HttpRequestManager.h"
#import "TestChapterModel.h"
#import "CommonMacro.h"

@interface TestErrorInfoOperation ()<HttpRequestProtocol>

@end

@implementation TestErrorInfoOperation

- (void)didRequestErrorInfoWithCategoryId:(int)cateId andNotifiedObject:(id<TestModule_ErrorInfoProtocol>)object;
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestTestErrorInfoWithCateId:cateId andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.errorChapterArray removeAllObjects];
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
        [self.errorChapterArray addObject:chapterModel];
    }
    
    NSArray *simulateSata = [successInfo objectForKey:@"simulateData"];
    for (NSDictionary *dic in simulateSata) {
        TestSimulateModel *model = [[TestSimulateModel alloc] init];
        model.simulateId = [[dic objectForKey:@"id"] intValue];
        model.simulateName = [dic objectForKey:@"name"];
        model.simulateQuestionCount = [[dic objectForKey:@"questionCount"] intValue];
        [self.simulateArray addObject:model];
    }
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didReqeustErrorInfoSuccess];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didReqeustErrorInfoFailed:failInfo];
    }
}



@end
