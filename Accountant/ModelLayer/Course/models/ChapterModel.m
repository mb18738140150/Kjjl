//
//  ChapterModel.m
//  Accountant
//
//  Created by aaa on 2017/3/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "ChapterModel.h"

@implementation ChapterModel

- (instancetype)init
{
    if (self = [super init]) {
        self.chapterVideos = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)removeAllVideos
{
    [self.chapterVideos removeAllObjects];
}

- (void)addVideo:(VideoModel *)video
{
    [self.chapterVideos addObject:video];
}

@end
