//
//  AddVideoNoteOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "AddVideoNoteOperation.h"
#import "HttpRequestManager.h"
#import "CommonMacro.h"

@interface AddVideoNoteOperation ()<HttpRequestProtocol>

@end

@implementation AddVideoNoteOperation

- (void)didRequestAddVideoNoteWithInfo:(NSDictionary *)info andNotifiedObject:(id<NoteModule_AddVideoNoteProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestAddVideoNoteWithInfo:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAddVideoNoteSuccess];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAddVideoNoteFailed:failInfo];
    }
}

@end
