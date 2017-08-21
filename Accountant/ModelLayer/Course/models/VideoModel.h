//
//  VideoModel.h
//  Accountant
//
//  Created by aaa on 2017/3/1.
//  Copyright © 2017年 tianming. All rights reserved.
//
//
//
//  单个视频model
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject

@property (nonatomic,assign) int         videoID;
@property (nonatomic,strong) NSString   *videoName;
@property (nonatomic,strong) NSString   *videoURLString;

@property (nonatomic,assign) int         videoSort;

@property (nonatomic,assign) int         isChapterVideo;

@end
