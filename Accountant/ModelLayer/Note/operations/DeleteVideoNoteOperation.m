//
//  DeleteVideoNoteOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DeleteVideoNoteOperation.h"
#import "HttpRequestManager.h"
#import "CommonMacro.h"

@interface DeleteVideoNoteOperation ()<HttpRequestProtocol>

@end

@implementation DeleteVideoNoteOperation

- (void)didRequestDeleteVideoNoteWithId:(int)noteId andNotifiedObject:(id<NoteModule_DeleteVideoNoteProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestDeleteVideoNoteWithId:noteId andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestDeleteVideoNoteSuccess];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestDeleteVideoNoteFailed:failInfo];
    }
}

@end
