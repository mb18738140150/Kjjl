//
//  AddVideoNoteOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteModuleProtocol.h"

@interface AddVideoNoteOperation : NSObject

@property (nonatomic,weak) id<NoteModule_AddVideoNoteProtocol>       notifiedObject;

- (void)didRequestAddVideoNoteWithInfo:(NSDictionary *)info andNotifiedObject:(id<NoteModule_AddVideoNoteProtocol>)object;

@end
