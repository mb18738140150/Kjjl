//
//  DeleteVideoNoteOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteModuleProtocol.h"

@interface DeleteVideoNoteOperation : NSObject

@property (nonatomic,weak) id<NoteModule_DeleteVideoNoteProtocol>            notifiedObject;

- (void)didRequestDeleteVideoNoteWithId:(int)noteId andNotifiedObject:(id<NoteModule_DeleteVideoNoteProtocol>)object;

@end
