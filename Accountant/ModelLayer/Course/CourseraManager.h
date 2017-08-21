//
//  CourseraManager.h
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModuleProtocol.h"
#import "CourseModuleModel.h"

@interface CourseraManager : NSObject

+ (instancetype)sharedManager;


- (PlayingInfoModel *)getPlayingInfo;

/**
 请求主页热门课程接口

 @param delegate 请求成功后通知的对象
 */
- (void)didRequestHottestCoursesWithNotifiedObject:(id<CourseModule_HottestCourseProtocl>)delegate;


/**
 请求所有课程信息接口

 @param delegate 请求成功后通知的对象
 */
- (void)didRequestAllCoursesWithNotifiedObject:(id<CourseModule_AllCourseProtocol>)delegate;


/**
 请求某一课程详细信息接口

 @param courseID 课程id
 @param object 请求成功后通知的对象
 */
- (void)didRequestDetailCourseWithCourseID:(int)courseID withNotifiedObject:(id<CourseModule_DetailCourseProtocol>)object;


/**
 请求全部课程类别接口

 @param object 请求成功后通知的对象
 */
- (void)didRequestAllCourseCategoryWithNotifiedObject:(id<CourseModule_AllCourseCategoryProtocol>)object;



/**
 请求某一个类别下所有课程信息接口

 @param categoryId 课程类别id
 @param userId 用户id
 @param object 请求成功后通知的对象
 */
- (void)didRequestCategoryDetailWithCategoryId:(int)categoryId andUserId:(int)userId withNotifiedObject:(id<CourseModule_CourseCategoryDetailProtocol>)object;


/**
 请求学习记录

 @param object 请求成功后通知的对象
 */
- (void)didRequestCourseHistoryWithNotifiedObject:(id<CourseModule_HistoryCourseProtocol>)object;


/**
 请求添加课程播放记录

 @param dic 播放的视频信息
 */
- (void)didRequestAddCourseHistoryWithInfo:(NSDictionary *)dic;


/**
 请求我的 我的课程 学习中的信息

 @param object 请求成功后通知的对象
 */
- (void)didRequestLearningCourseWithNotifiedObject:(id<CourseModule_LearningCourseProtocol>)object;


/**
 请求 我的 我的课程 收藏的信息

 @param object 请求成功后通知的对象
 */
- (void)didRequestCollectCourseWithNotifiedObject:(id<CourseModule_CollectCourseProtocol>)object;


/**
 请求 添加课程收藏

 @param courseId 课程id
 @param object 请求成功后通知的对象
 */
- (void)didRequestAddCollectCourseWithCourseId:(int)courseId andNotifiedObject:(id<CourseModule_AddCollectCourseProtocol>)object;


/**
 请求 删除收藏的课程

 @param courseId 课程id
 @param object 请求成功后通知的对象
 */
- (void)didRequestDeleteCollectCourseWithCourseId:(int)courseId andNotifiedObject:(id<CourseModule_DeleteCollectCourseProtocol>)object;

@property (nonatomic,strong) CourseModuleModel              *courseModuleModel;


// 获取热门搜索
- (void)didRequestHotSearchCourseWithNotifiedObject:(id<CourseModule_HotSearchProtocol>)delegate;

/**
 请求搜索页视频接口
 
 @param keyword 关键词
 @param delegate 请求成功后通知的对象
 */
- (void)didRequestSearchVideoCoursesWithkeyWord:(NSString *)keyword NotifiedObject:(id<CourseModule_VideoCourseProtocol>)delegate;


/**
 请求搜索页直播接口
 
 @param keyword 关键词
 @param delegate 请求成功后通知的对象
 */
- (void)didRequestSearchliveStreamCoursesWithkeyWord:(NSString *)keyword NotifiedObject:(id<CourseModule_LiveStreamProtocol>)delegate;

- (void)didRequestNotStartLivingCourseWithNotifiedObject:(id<CourseModule_NotStartLivingCourse>)delegate;

- (void)didRequestEndLivingCourseWithNotifiedObject:(id<CourseModule_EndLivingCourse>)delegate;

/**
 获取热门课程信息

 @return 热门课程信息
 */
- (NSArray *)getHottestCourseArray;

/**
 获取热门搜索课程信息
 
 @return 热门搜索视频课程信息
 */
- (NSMutableDictionary *)getHotSearchCourseArray;

/**
 获取搜索课程信息
 
 @return 搜索视频课程信息
 */
- (NSArray *)getSearchVideoCourseArray;

/**
 获取搜索直播课程信息
 
 @return 搜索页直播课程信息
 */
- (NSArray *)getSearchLiveStreamArray;

/**
 获取未开始直播课程
 
 @return 未开始直播课程
 */
- (NSArray *)getNotStartLivingCourseArray;

/**
 获取已结束直播课程
 
 @return 已结束直播课程
 */
- (NSArray *)getEndLivingCourseArray;


/**
 获取所有课程信息

 @return 所有课程信息
 */
- (NSArray *)getAllCourseArray;


/**
 获取正在播放课程的信息

 @return 正在播放的课程的信息
 */
- (NSDictionary *)getPlayCourseInfo;


/**
 获取正在播放课程里的章节信息

 @return 章节信息
 */
- (NSArray *)getPlayChapterInfo;


/**
 获取正在播放课程里每一章里每一小节的信息

 @return 小节信息
 */
- (NSArray *)getPlayChapterVideoInfo;


/**
 获取所有课程类别信息

 @return 所有课程类别信息
 */
- (NSArray *)getAllCategoryArray;


/**
 获取请求过某一类别下所有课程的信息

 @return 课程信息
 */
- (NSArray *)getCategoryCoursesInfo;


/**
 获取 我的 学习记录 中的信息

 @return 学习记录
 */
- (NSArray *)getHistoryInfoArray;


/**
 获取正在播放的视频的信息

 @return 正在播放的视频信息
 */
- (NSMutableDictionary *)getPlayingInfoDic;


/**
 获取 我的 我的课程  学习中  的课程

 @return 学习中的课程信息
 */
- (NSArray *)getLearningCourseInfoArray;


/**
 获取 我的 我的课程 收藏 的课程

 @return 收藏的课程信息
 */
- (NSArray *)getCollectCourseInfoArray;


@end
