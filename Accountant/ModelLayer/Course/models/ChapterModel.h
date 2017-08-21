//
//  ChapterModel.h
//  Accountant
//
//  Created by aaa on 2017/3/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoModel.h"

@interface ChapterModel : NSObject

@property (nonatomic,assign) int                     chapterId;

//该章下是否有小节视频
@property (nonatomic,assign) BOOL                    isSingleVideo;
@property (nonatomic,strong) NSString               *chapterName;
@property (nonatomic,strong) NSString               *chapterURL;

@property (nonatomic,strong) NSMutableArray         *chapterVideos;

@property (nonatomic,assign) int                     chapterSort;

- (void)removeAllVideos;
- (void)addVideo:(VideoModel *)video;

@end
