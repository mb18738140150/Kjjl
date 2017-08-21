//
//  NoteModuleProtocol.h
//  Accountant
//
//  Created by aaa on 2017/3/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NoteModule_MyVideoNoteProtocol <NSObject>

- (void)didRequestMyVideoNoteSuccess;
- (void)didRequestMyVideoNoteFailed:(NSString *)failedInfo;

@end

@protocol NoteModule_AddVideoNoteProtocol <NSObject>

- (void)didRequestAddVideoNoteSuccess;
- (void)didRequestAddVideoNoteFailed:(NSString *)failedInfo;

@end

@protocol NoteModule_DeleteVideoNoteProtocol <NSObject>

- (void)didRequestDeleteVideoNoteSuccess;
- (void)didRequestDeleteVideoNoteFailed:(NSString *)failedInfo;

@end
