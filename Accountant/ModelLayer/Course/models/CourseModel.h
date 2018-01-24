//
//  CourseModel.h
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseModel : NSObject

//课程id
@property (nonatomic,assign) int             courseID;

//课程封面url
@property (nonatomic,strong) NSString       *courseCover;

//课程小节名称
@property (nonatomic,strong) NSString       *courseName;
// 课程名称
@property (nonatomic, strong) NSString      *name;

@property (nonatomic, copy) NSString      *coueseTeacherName;

//课程url string
@property (nonatomic,strong) NSString       *courseURLString;

@property (nonatomic,assign) BOOL            isCollect;

@property (nonatomic, strong)NSString * time;
@property (nonatomic, assign)int playState;

@property (nonatomic, assign)int                    canDownload;// 视频是否有下载权限
@property (nonatomic, assign)int                    canWatch;// 视频是否有观看权限

@property (nonatomic, assign)double                 learnProgress;// 学习进度

@property (nonatomic, assign)double price;
@property (nonatomic, assign)double oldPrice;

// 直播课
@property (nonatomic, strong)NSString *teacherPortraitUrl;
@property (nonatomic, strong)NSString *teacherDetail;
@property (nonatomic, strong)NSString *livingDetail;
@property (nonatomic, assign)int haveJurisdiction;// 是否有观看直播课回放权限
@property (nonatomic, strong)NSString *lastTime;//课程最近小节播放时间

// 直播课小节
@property (nonatomic, assign)int sectionId;
@property (nonatomic, strong)NSString * chatRoomId;
@property (nonatomic, strong)NSString * assistantId;
@property (nonatomic, strong)NSString * playback;
@property (nonatomic, assign)int isFree;
@property (nonatomic, assign)int isBack;//回放是否有权限观看


@end
