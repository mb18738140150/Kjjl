//
//  TestChapterOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestChapterOperation.h"
#import "HttpRequestManager.h"
#import "TestChapterModel.h"
#import "TestSectionModel.h"
#import "CommonMacro.h"

@interface TestChapterOperation ()<HttpRequestProtocol>

@end

@implementation TestChapterOperation

- (void)didRequestTestChapterInfoWithCategoryId:(int)cateId andNotifiedObject:(id<TestModule_ChapterInfoProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestTestChapterInfoWithCateId:cateId andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    
//    NSLog(@"%@", [successInfo description]);
    
    [self.testChapterArray removeAllObjects];
    NSArray *data = [successInfo objectForKey:@"data"];
    for (NSDictionary *dic in data) {
        TestChapterModel *chapterModel = [[TestChapterModel alloc] init];
        chapterModel.chapterId = [[dic objectForKey:@"id"] intValue];
        chapterModel.chapterName = [dic objectForKey:@"name"];
        chapterModel.chapterQuestionCount = [[dic objectForKey:@"questionCount"] intValue];
//        chapterModel.chapterParentId = [[dic objectForKey:@"parentId"] intValue];
        NSArray *sections = [dic objectForKey:@"subject"];
        for (NSDictionary *secDic in sections) {
            
            TestSectionModel *sectionModel = [[TestSectionModel alloc] init];
            sectionModel.sectionId = [[secDic objectForKey:@"id"] intValue];
            sectionModel.sectionName = [secDic objectForKey:@"name"];
            sectionModel.sectionQuestionCount = [[secDic objectForKey:@"questionCount"] intValue];
            [chapterModel.sectionArray addObject:sectionModel];
        }
        [self.testChapterArray addObject:chapterModel];
    }
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestChapterInfoSuccess];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestChapterInfoFailed:failInfo];
    }
}

@end
