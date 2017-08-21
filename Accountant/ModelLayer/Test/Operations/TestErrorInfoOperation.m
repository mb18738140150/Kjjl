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
    NSArray *data = [successInfo objectForKey:@"data"];
    for (NSDictionary *dic in data) {
        TestChapterModel *model = [[TestChapterModel alloc] init];
        model.chapterId = [[dic objectForKey:@"id"] intValue];
        model.chapterName = [dic objectForKey:@"name"];
        model.chapterQuestionCount = [[dic objectForKey:@"questionCount"] intValue];
        [self.errorChapterArray addObject:model];
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
