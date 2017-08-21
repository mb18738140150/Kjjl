//
//  VideoNoteModel.h
//  Accountant
//
//  Created by aaa on 2017/3/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoNoteModel : NSObject

@property (nonatomic,assign) int                 noteId;

@property (nonatomic,strong) NSString           *courseName;
@property (nonatomic,strong) NSString           *chapterName;
@property (nonatomic,strong) NSString           *videoName;
@property (nonatomic,assign) int                 courseId;
@property (nonatomic,assign) int                 chapterId;
@property (nonatomic,assign) int                 videoId;
@property (nonatomic, strong)NSString           *time;
@property (nonatomic,strong) NSString           *content;

@end
