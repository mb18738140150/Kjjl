//
//  MyNoteOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MyVideoNoteOperation.h"
#import "HttpRequestManager.h"
#import "VideoNoteModel.h"
#import "CommonMacro.h"

@interface MyVideoNoteOperation ()<HttpRequestProtocol>

@end

@implementation MyVideoNoteOperation

- (void)didRequestMyNoteWithNotifiedObject:(id<NoteModule_MyVideoNoteProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestAllMyNoteWithProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.myVideoNotes removeAllObjects];
    NSArray *data = [successInfo objectForKey:@"data"];
    for (NSDictionary *dic in data) {
        VideoNoteModel *model = [[VideoNoteModel alloc] init];
        model.noteId = [[dic objectForKey:@"id"] intValue];
        model.courseName = [dic objectForKey:@"courseName"];
        model.courseId = [[dic objectForKey:@"courseId"] intValue];
        model.chapterName = [dic objectForKey:@"chapterName"];
        model.chapterId = [[dic objectForKey:@"chapterId"] intValue];
        model.videoId = [[dic objectForKey:@"videoId"] intValue];
        model.videoName = [dic objectForKey:@"videoName"];
        model.content = [dic objectForKey:@"contents"];
        model.time = [self getStr:[dic objectForKey:@"time"]];
        [self.myVideoNotes addObject:model];
    }
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestMyVideoNoteSuccess];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestMyVideoNoteFailed:failInfo];
    }
}

- (NSString *)getStr:(NSString *)str
{
    if (str) {
        return str;
    }else
    {
        return @"";
    }
}

@end
