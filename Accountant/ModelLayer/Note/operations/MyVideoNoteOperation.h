//
//  MyNoteOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteModuleProtocol.h"

@interface MyVideoNoteOperation : NSObject

@property (nonatomic,weak) NSMutableArray                           *myVideoNotes;

@property (nonatomic,weak) id<NoteModule_MyVideoNoteProtocol>             notifiedObject;

- (void)didRequestMyNoteWithNotifiedObject:(id<NoteModule_MyVideoNoteProtocol>)object;

@end
