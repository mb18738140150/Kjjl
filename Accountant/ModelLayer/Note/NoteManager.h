//
//  NoteManager.h
//  Accountant
//
//  Created by aaa on 2017/3/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteModuleProtocol.h"

@interface NoteManager : NSObject

+ (instancetype)sharedManager;


/**
 请求全部笔记

 @param object 请求成功后通知的对象
 */
- (void)didRequestAllMyNoteWithNotifiedObject:(id<NoteModule_MyVideoNoteProtocol>)object;


/**
 请求添加视频笔记

 @param info 视频笔记内容
 @param object 请求成功后通知的对象
 */
- (void)didRequestAddVideoNoteWithInfo:(NSDictionary *)info andNotifiedObject:(id<NoteModule_AddVideoNoteProtocol>)object;


/**
 请求删除视频笔记

 @param noteId 笔记id
 @param object 请求成功后通知的对象
 */
- (void)didRequestDeleteVideoNoteWithId:(int)noteId andNotifiedObject:(id<NoteModule_DeleteVideoNoteProtocol>)object;


/**
 获取全部笔记的信息

 @return <#return value description#>
 */
- (NSArray *)getAllMyVideoNoteInfos;

@end
