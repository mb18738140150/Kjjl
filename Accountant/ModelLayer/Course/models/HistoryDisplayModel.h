//
//  HistoryDisplayModel.h
//  Accountant
//
//  Created by aaa on 2017/3/18.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryDisplayModel : NSObject

@property (nonatomic,strong) NSString       *courseName;
@property (nonatomic,assign) int             courseId;
@property (nonatomic,strong) NSString       *courseCover;
@property (nonatomic,strong) NSString       *chapterName;
@property (nonatomic,assign) int             chapterId;
@property (nonatomic,strong) NSString       *videoName;
@property (nonatomic,assign) int             videoId;

@end
