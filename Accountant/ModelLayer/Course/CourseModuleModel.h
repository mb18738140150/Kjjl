//
//  CourseModuleModel.h
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModel.h"
#import "HottestCourseModel.h"
#import "AllCourseModel.h"
#import "DetailCourseModel.h"
#import "AllCourseCategoryModel.h"
#import "CourseCategoryDetailModel.h"
#import "HistoryDayModel.h"
#import "PlayingVideoModel.h"
#import "PlayingInfoModel.h"

@interface CourseModuleModel : NSObject

//首页热门课程的信息
@property (nonatomic,strong) HottestCourseModel             *hottestCourseModel;

// 热门搜索课程
@property (nonatomic, strong) HottestCourseModel *hotSearchVideoModel;

// 热门搜索直播课
@property (nonatomic, strong) HottestCourseModel *hotSearchLivingStreamModel;

// 搜索页视频课信息
@property (nonatomic, strong) HottestCourseModel *searchVideoCourseModel;

// 搜索页直播课信息
@property (nonatomic, strong) HottestCourseModel *searchLiveStreamModel;

// 今日直播课信息
@property (nonatomic, strong) HottestCourseModel *notStartLivingCourseModel;

// 近期直播课信息
@property (nonatomic, strong) HottestCourseModel *endLivingCourseModel;

//全部课程的信息
@property (nonatomic,strong) AllCourseModel                 *allCourseModel;

//点击课程播放时 课程的详细信息
@property (nonatomic,strong) DetailCourseModel              *detailCourseModel;

//全部课程类型信息
@property (nonatomic,strong) AllCourseCategoryModel         *allCourseCategoryModel;

//课程类别的详细信息
@property (nonatomic,strong) CourseCategoryDetailModel      *courseCategoryDetailModel;

//正在播放视频的信息
@property (nonatomic,strong) PlayingInfoModel               *playingInfoModel;

/**
 设置中学习记录models
 */
@property (nonatomic,strong) NSMutableArray                 * historyDisplayModels;

//设置 我的课程中  学习中的课程信息
@property (nonatomic,strong) NSMutableArray                 *learningCourseArray;

//设置 我的课程中  收藏的课程信息
@property (nonatomic,strong) NSMutableArray                 *collectCourseArray;




@end
