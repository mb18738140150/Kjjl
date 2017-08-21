//
//  NoteManager.m
//  Accountant
//
//  Created by aaa on 2017/3/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "NoteManager.h"
#import "MyVideoNoteOperation.h"
#import "AddVideoNoteOperation.h"
#import "DeleteVideoNoteOperation.h"
#import "NoteModuleModels.h"
#import "CommonMacro.h"

@interface NoteManager ()

@property (nonatomic,strong) NoteModuleModels               *noteModuleModels;

@property (nonatomic,strong) MyVideoNoteOperation           *myVideoNoteOperation;
@property (nonatomic,strong) AddVideoNoteOperation          *addVideoNoteOperation;
@property (nonatomic,strong) DeleteVideoNoteOperation       *deleteVideoNoteOperation;

@end

@implementation NoteManager

+ (instancetype)sharedManager
{
    static NoteManager *__noteManager__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __noteManager__ = [[NoteManager alloc] init];
    });
    return __noteManager__;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.noteModuleModels = [[NoteModuleModels alloc] init];
        
        self.myVideoNoteOperation = [[MyVideoNoteOperation alloc] init];
        self.myVideoNoteOperation.myVideoNotes = self.noteModuleModels.myVideoNoteModels;
        self.addVideoNoteOperation = [[AddVideoNoteOperation alloc] init];
        self.deleteVideoNoteOperation = [[DeleteVideoNoteOperation alloc] init];
    }
    return self;
}

- (void)didRequestAllMyNoteWithNotifiedObject:(id<NoteModule_MyVideoNoteProtocol>)object
{
    [self.myVideoNoteOperation didRequestMyNoteWithNotifiedObject:object];
}

- (void)didRequestAddVideoNoteWithInfo:(NSDictionary *)info andNotifiedObject:(id<NoteModule_AddVideoNoteProtocol>)object
{
    [self.addVideoNoteOperation didRequestAddVideoNoteWithInfo:info andNotifiedObject:object];
}

- (void)didRequestDeleteVideoNoteWithId:(int)noteId andNotifiedObject:(id<NoteModule_DeleteVideoNoteProtocol>)object
{
    [self.deleteVideoNoteOperation didRequestDeleteVideoNoteWithId:noteId andNotifiedObject:object];
}

- (NSArray *)getAllMyVideoNoteInfos
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (VideoNoteModel *model in self.noteModuleModels.myVideoNoteModels) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:model.courseName forKey:kCourseName];
        [dic setObject:@(model.courseId) forKey:kCourseID];
        [dic setObject:model.chapterName forKey:kChapterName];
        [dic setObject:@(model.chapterId) forKey:kChapterId];
        [dic setObject:model.videoName forKey:kVideoName];
        [dic setObject:@(model.videoId) forKey:kVideoId];
        [dic setObject:model.content forKey:kNoteVideoNoteContent];
        [dic setObject:@(model.noteId) forKey:kNoteVideoNoteId];
        [dic setObject:model.time forKey:@"time"];
        [array addObject:dic];
    }
    return array;
}

@end
