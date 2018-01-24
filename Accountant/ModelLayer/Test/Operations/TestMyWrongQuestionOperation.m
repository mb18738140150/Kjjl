//
//  TestMyWrongQuestionOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestMyWrongQuestionOperation.h"
#import "HttpRequestManager.h"
#import "TestChapterModel.h"
#import "CommonMacro.h"

@interface TestMyWrongQuestionOperation ()<HttpRequestProtocol>

@end

@implementation TestMyWrongQuestionOperation

- (void)didAddMyWrongQuestionWithQuestionId:(int)questionId
{
    [[HttpRequestManager sharedManager] reqestTestAddMyWrongQuestionWithQuestionId:questionId andProcessDelegate:nil];
}

- (void)didRequesMyWrongChapterWithCategoryId:(int)cateId andNotifiedObject:(id<TestModule_MyWrongQuestionInfoProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestTestMyWrongChapterInfoWithCategoryId:cateId andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.myWrongChapterArray removeAllObjects];
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
        [self.myWrongChapterArray addObject:chapterModel];
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
//    NSLog(@"%@",data);
//    for (NSDictionary *dic in data) {
//        TestChapterModel *model = [[TestChapterModel alloc] init];
//        model.chapterId = [[dic objectForKey:@"id"] intValue];
//        model.chapterName = [dic objectForKey:@"name"];
//        model.chapterQuestionCount = [[dic objectForKey:@"questionCount"] intValue];
//        [self.myWrongChapterArray addObject:model];
//    }
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestMyWrongQuestionSuccess];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    [self.notifiedObject didRequestMyWrongQuestionFailed:failInfo];
}

@end
