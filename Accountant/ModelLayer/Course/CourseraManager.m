//
//  CourseraManager.m
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CourseraManager.h"
#import "HottestCourseOperation.h"
#import "HottestCourseModel.h"
#import "DetailCourseOperation.h"
#import "CourseModuleModel.h"
#import "AllCourseOperation.h"
#import "CommonMacro.h"
#import "CourseCategoryOperation.h"
#import "CategoryDetailOperation.h"
#import "HistoryCourseOperation.h"
#import "LearningCourseOperation.h"
#import "CollectCourseOperation.h"
#import "AddCollectCourseOperation.h"
#import "DeleteCollectCourseOperation.h"
#import "VideoCoueseOperation.h"
#import "LiveStreamOperation.h"
#import "NotStartLivingCourseOperation.h"
#import "EndLivingCourseOperation.h"
#import "HotSearchOperation.h"
#import "LivingSectionDetailOperation.h"
#import "PackageOperation.h"
#import "PackageDetailOperation.h"

@interface CourseraManager ()

@property (nonatomic,strong) HottestCourseOperation         *hottestOperation;
@property (nonatomic,strong) DetailCourseOperation          *detailCourseOperation;
@property (nonatomic,strong) AllCourseOperation             *allCourseOperation;
@property (nonatomic,strong) CourseCategoryOperation        *courseCategoryOperation;
@property (nonatomic,strong) CategoryDetailOperation        *categoryDetailOperation;
@property (nonatomic,strong) HistoryCourseOperation         *historyCourseOperation;
@property (nonatomic,strong) LearningCourseOperation        *learningCourseOperation;
@property (nonatomic,strong) CollectCourseOperation         *collectCourseOperation;
@property (nonatomic,strong) AddCollectCourseOperation      *addCollectCourseOperation;
@property (nonatomic,strong) DeleteCollectCourseOperation   *deleteCollectCourseOperation;
@property (nonatomic,strong) VideoCoueseOperation           *videoCourseOperation;
@property (nonatomic,strong) LiveStreamOperation            *liveStreamOperation;
@property (nonatomic, strong)NotStartLivingCourseOperation  *notStartLivingOperation;
@property (nonatomic, strong)EndLivingCourseOperation       *endLivingOperation;
@property (nonatomic,strong)HotSearchOperation              *hotSearchOperation;
@property (nonatomic,strong)LivingSectionDetailOperation    *livingSectionDetailOperation;
@property (nonatomic, strong)PackageOperation               *packageOperation;
@property (nonatomic, strong)PackageDetailOperation         *packageDetailOperation;

@end

@implementation CourseraManager

+ (instancetype)sharedManager
{
    static CourseraManager *__manager__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager__ = [[CourseraManager alloc] init];
    });
    return __manager__;
}

- (instancetype)init
{
    if (self = [super init]){
        self.courseModuleModel = [[CourseModuleModel alloc] init];
        
        self.detailCourseOperation = [[DetailCourseOperation alloc] init];
        [self.detailCourseOperation setCurrentDetailCourse:self.courseModuleModel.detailCourseModel];
        
        self.allCourseOperation = [[AllCourseOperation alloc] init];
        [self.allCourseOperation setCurrentAllCourseModel:self.courseModuleModel.allCourseModel];
        
        self.hottestOperation = [[HottestCourseOperation alloc] init];
        [self.hottestOperation setCurrentHottestCoursesWithModel:self.courseModuleModel.hottestCourseModel];
        
        self.hotSearchOperation = [[HotSearchOperation alloc]init];
        [self.hotSearchOperation setCurrentHotSearchVideoCoursesWithModel:self.courseModuleModel.hotSearchVideoModel];
        [self.hotSearchOperation setCurrentHotSearchLiveStreamWithModel:self.courseModuleModel.hotSearchLivingStreamModel];
        
        self.videoCourseOperation = [[VideoCoueseOperation alloc]init];
        [self.videoCourseOperation setCurrentSearchVideoCoursesWithModel:self.courseModuleModel.searchVideoCourseModel];
        
        self.liveStreamOperation = [[LiveStreamOperation alloc]init];
        [self.liveStreamOperation setCurrentSearchLiveStreamWithModel:self.courseModuleModel.searchLiveStreamModel];
        
        self.notStartLivingOperation = [[NotStartLivingCourseOperation alloc]init];
        [self.notStartLivingOperation setCurrentNotStartLivingCourseWithModel:self.courseModuleModel.notStartLivingCourseModel];
        [self.notStartLivingOperation setMyLivingCourseWithModel:self.courseModuleModel.myLivingCourseModel];
//        [self.notStartLivingOperation setCurrentNotStartLivingSectionCourseWithModel:self.courseModuleModel.notStartLivingSectionCourseModel];
        
        self.endLivingOperation = [[EndLivingCourseOperation alloc]init];
        [self.endLivingOperation setCurrentEndLivingCourseWithModel:self.courseModuleModel.endLivingCourseModel];
        
        self.livingSectionDetailOperation = [[LivingSectionDetailOperation alloc]init];
        [self.livingSectionDetailOperation setCurrentLivingSectionDetailWithModel:self.courseModuleModel.livingSectionDetailModel];
        
        self.courseCategoryOperation = [[CourseCategoryOperation alloc] init];
        [self.courseCategoryOperation setCurrentAllCourseCategoryModel:self.courseModuleModel.allCourseCategoryModel];
        
        self.categoryDetailOperation = [CategoryDetailOperation new];
        [self.categoryDetailOperation setCurrentCourseCategoryDetailModel:self.courseModuleModel.courseCategoryDetailModel];
        
        self.historyCourseOperation = [HistoryCourseOperation new];
        self.historyCourseOperation.historyArray = self.courseModuleModel.historyDisplayModels;
        
        self.collectCourseOperation = [CollectCourseOperation new];
        self.collectCourseOperation.collectCourseArray = self.courseModuleModel.collectCourseArray;
        
        self.learningCourseOperation = [LearningCourseOperation new];
        
        
        self.addCollectCourseOperation = [AddCollectCourseOperation new];
        self.deleteCollectCourseOperation = [DeleteCollectCourseOperation new];
        
        self.packageOperation = [[PackageOperation alloc]init];
        [self.packageOperation setCurrentAllPackageModel:self.courseModuleModel.allPackage];
        
        self.packageDetailOperation = [[PackageDetailOperation alloc]init];
        
    }
    return self;
}

- (PlayingInfoModel *)getPlayingInfo
{
    return self.courseModuleModel.playingInfoModel;
}

#pragma mark - request func
- (void)didRequestHottestCoursesWithNotifiedObject:(id<CourseModule_HottestCourseProtocl>)delegate
{
    [self.hottestOperation didRequestHosttestCourseWithNotifiedObject:delegate];
}

- (void)didRequestHotSearchCourseWithNotifiedObject:(id<CourseModule_HotSearchProtocol>)delegate
{
    [self.hotSearchOperation didRequestHotSearchCoursesWithNotifiedObject:delegate];
}

- (void)didRequestSearchVideoCoursesWithkeyWord:(NSString *)keyword NotifiedObject:(id<CourseModule_VideoCourseProtocol>)delegate
{
    [self.videoCourseOperation didRequestSearchVideoCoursesWithkeyWord:keyword NotifiedObject:delegate];
}


- (void)didRequestSearchliveStreamCoursesWithkeyWord:(NSString *)keyword NotifiedObject:(id<CourseModule_LiveStreamProtocol>)delegate
{
    [self.liveStreamOperation didRequestSearchliveStreamCoursesWithkeyWord:keyword NotifiedObject:delegate];
}

- (void)didRequestAllCoursesWithNotifiedObject:(id<CourseModule_AllCourseProtocol>)delegate
{
    [self.allCourseOperation didRequestAllCourseWithNotifiedObject:delegate];
}

- (void)didRequestDetailCourseWithCourseID:(int)courseID withNotifiedObject:(id<CourseModule_DetailCourseProtocol>)object
{
    [self.detailCourseOperation requestDetailCourseWithID:courseID withNotifiedObject:object];
}

- (void)didRequestAllCourseCategoryWithNotifiedObject:(id<CourseModule_AllCourseCategoryProtocol>)object
{
    [self.courseCategoryOperation didRequestAllCourseCategoryWithNotifiedObject:object];
}

- (void)didRequestAllPackageWithNotifiedObject:(id<CourseModule_PackageProtocol>)object
{
    [self.packageOperation didRequestAllPackageWithNotifiedObject:object];
}

- (void)didRequestPackageDetailWithPackageId:(int)packageId NotifiedObject:(id<CourseModule_PackageDetailProtocol>)object
{
    [self.packageDetailOperation didRequestPackageDetailWithpackageId:packageId andNotifiedObject:object];
}

- (void)didRequestCategoryDetailWithCategoryId:(int)categoryId andUserId:(int)userId withNotifiedObject:(id<CourseModule_CourseCategoryDetailProtocol>)object
{
    [self.categoryDetailOperation didRequestCategoryDetailWithCategoryId:categoryId andUserId:userId withNotified:object];
}

- (void)didRequestCourseHistoryWithNotifiedObject:(id<CourseModule_HistoryCourseProtocol>)object
{
    [self.historyCourseOperation didRequestHistoryCourseWithNotifiedObject:object];
}

- (void)didRequestAddCourseHistoryWithInfo:(NSDictionary *)dic
{
    [self.historyCourseOperation didRequestAddHistoryCourseWithInfo:dic];
}

- (void)didRequestLearningCourseWithInfoDic:(NSDictionary *)infoDic NotifiedObject:(id<CourseModule_LearningCourseProtocol>)object
{
    [self.learningCourseOperation didRequestLearningCourseWith:infoDic NotifiedObject:object];
}

- (void)didRequestCompleteCourseWithInfoDic:(NSDictionary *)infoDic NotifiedObject:(id<CourseModule_CompleteCourseProtocol>)object
{
    [self.learningCourseOperation didRequestCompleteCourseWith:infoDic NotifiedObject:object];
}

- (void)didRequestCollectCourseWithNotifiedObject:(id<CourseModule_CollectCourseProtocol>)object
{
    [self.collectCourseOperation didRequestCollectCourseWithNotifiedObject:object];
}

- (void)didRequestAddCollectCourseWithCourseId:(int)courseId andNotifiedObject:(id<CourseModule_AddCollectCourseProtocol>)object
{
    [self.addCollectCourseOperation didRequestAddCollectCourseWithId:courseId andNotifiedObject:object];
}

- (void)didRequestDeleteCollectCourseWithCourseId:(int)courseId andNotifiedObject:(id<CourseModule_DeleteCollectCourseProtocol>)object
{
    [self.deleteCollectCourseOperation didRequestDeleteCollectCourseWithId:courseId andNotifiedObject:object];
}

- (void)didRequestDeleteMyLearningCourseWithCourseInfo:(NSDictionary *)infoDic andNotifiedObject:(id<CourseModule_DeleteCollectCourseProtocol>)object
{
    [self.deleteCollectCourseOperation didRequestDeleteMyLearningCourseWithInfo:infoDic andNotifiedObject:object];
}

- (void)didRequestNotStartLivingCourseWithInfo:(NSDictionary *)infoDic NotifiedObject:(id<CourseModule_NotStartLivingCourse>)delegate
{
    [self.notStartLivingOperation didRequestNotStartLivingCourseWithInfo:infoDic NotifiedObject:delegate];
}

- (void)didRequestMyLivingCourseWithInfo:(NSDictionary *)infoDic NotifiedObject:(id<CourseModule_MyLivingCourse>)delegate
{
    [self.notStartLivingOperation didRequestMyLivingCourseWithInfo:infoDic NotifiedObject:delegate];
}

- (void)didRequestEndLivingCourseWithNotifiedObject:(id<CourseModule_EndLivingCourse>)delegate
{
    [self.endLivingOperation didRequestEndLivingCourseWithNotifiedObject:delegate];
}

- (void)didrequestLivingSectionDetailWithInfo:(NSDictionary *)infoDic andNotifiedObject:(id<CourseModule_LivingSectionDetail>)delegate
{
    [self.livingSectionDetailOperation didRequestLivingSectionDetailWithInfo:infoDic andNotifiedObject:delegate];
}

- (int)getIsHaveJurisdiction
{
    return [self.notStartLivingOperation getIsHaveJurisdiction];
}

#pragma mark - getter funcs
- (NSArray *)getHottestCourseArray
{
    NSMutableArray *hottestArray = [[NSMutableArray alloc] init];
//    for (CourseModel *model in self.courseModuleModel.hottestCourseModel.hottestCourses) {
//        NSDictionary *dic = @{kCourseID:@(model.courseID),
//                              kCourseCover:model.courseCover,
//                              kCourseName:model.courseName,
//                              kCourseTeacherName:model.coueseTeacherName};
//        [hottestArray addObject:dic];
//    }
    
    for (int i = 4 * self.exchangeNumber; i < 4 * self.exchangeNumber + 4 && 4 * self.exchangeNumber + 3 < self.courseModuleModel.hottestCourseModel.hottestCourses.count; i++) {
        CourseModel * model = self.courseModuleModel.hottestCourseModel.hottestCourses[i];
        NSDictionary *dic = @{kCourseID:@(model.courseID),
                              kCourseCover:model.courseCover,
                              kCourseName:model.courseName,
                              kCourseTeacherName:model.coueseTeacherName,
                              kPrice:@(model.price)
                              };
        [hottestArray addObject:dic];
    }
    
    return hottestArray;
}

- (NSMutableDictionary *)getHotSearchCourseArray
{
    NSMutableDictionary * infoDic = [NSMutableDictionary dictionary];
    NSMutableArray *hottestArray = [[NSMutableArray alloc] init];
    for (CourseModel *model in self.courseModuleModel.hotSearchVideoModel.hottestCourses) {
        NSDictionary *dic = @{kCourseID:@(model.courseID),
                              kCourseCover:model.courseCover,
                              kCourseName:model.courseName};
        [hottestArray addObject:dic];
    }
    
    NSMutableArray *livinghottestArray = [[NSMutableArray alloc] init];
    for (CourseModel *model in self.courseModuleModel.hotSearchLivingStreamModel.hottestCourses) {
        NSDictionary *dic = @{kCourseID:@(model.courseID),
                              kCourseCover:model.courseCover,
                              kCourseName:model.courseName};
        [livinghottestArray addObject:dic];
    }
    
    
    [infoDic setObject:hottestArray forKey:@"VideoData"];
    [infoDic setObject:livinghottestArray forKey:@"LivingStreamData"];
    
    return infoDic;
}

- (NSArray *)getSearchVideoCourseArray
{
    NSMutableArray *hottestArray = [[NSMutableArray alloc] init];
    for (CourseModel *model in self.courseModuleModel.searchVideoCourseModel.hottestCourses) {
        NSDictionary *dic = @{kCourseID:@(model.courseID),
                              kCourseCover:model.courseCover,
                              kCourseName:model.courseName,
                              kCourseTeacherName:model.coueseTeacherName};
        [hottestArray addObject:dic];
    }
    return hottestArray;
}

- (NSArray *)getSearchLiveStreamArray
{
    NSMutableArray *hottestArray = [[NSMutableArray alloc] init];
    for (CourseModel *model in self.courseModuleModel.searchLiveStreamModel.hottestCourses) {
        NSDictionary *dic = @{kCourseID:@(model.courseID),
                              kCourseCover:model.courseCover,
                              kCourseName:model.courseName,
                              kCourseTeacherName:model.coueseTeacherName};
        [hottestArray addObject:dic];
    }
    return hottestArray;
}

- (NSArray *)getLivingTeacherInfoArrar
{
    NSMutableArray * teacherArr = [NSMutableArray array];
    for (TeacherModel * tModel in self.courseModuleModel.notStartLivingCourseModel.teacherDataArray) {
        NSDictionary *  dic = @{kCourseTeacherName:tModel.teacherName,
                                kteacherId:tModel.teacherId};
        [teacherArr addObject:dic];
    }
    return teacherArr;
}

- (NSArray *)getNotStartLivingCourseArray
{
    NSMutableArray *hottestArray = [[NSMutableArray alloc] init];
    
    // 课程数据源
    NSMutableArray *livingCourseArr = [NSMutableArray array];
    
    NSMutableArray *noStartlivingCourseArr = [NSMutableArray array];
    NSMutableArray *endlivingCourseArr = [NSMutableArray array];
    
    for (CourseModel *model in self.courseModuleModel.notStartLivingCourseModel.hottestCourses) {
        
        NSDictionary *dic = @{kCourseID:@(model.courseID),
                              kCourseCover:model.courseCover,
                              kCourseName:model.courseName,
                              kCourseTeacherName:model.coueseTeacherName,
                              kLivingTime:model.time,
                              kLivingState:@(model.playState),
                              kTeacherDetail:model.teacherDetail,
                              kTeacherPortraitUrl:model.teacherPortraitUrl,
                              kLivingDetail:model.livingDetail,
                              kHaveJurisdiction:@(model.haveJurisdiction),
                              kLivinglastTime:model.lastTime,
                              kCourseSecondID:@(model.sectionId)};
        
        if (model.lastTime.length == 0) {
            [endlivingCourseArr addObject:dic];
        }else
        {
            [noStartlivingCourseArr addObject:dic];
        }
    }
    
    noStartlivingCourseArr = [[noStartlivingCourseArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString * time1 = [(NSDictionary *)obj1 objectForKey:kLivinglastTime];
        
        NSString * time2 = [(NSDictionary *)obj2 objectForKey:kLivinglastTime];
        
        NSComparisonResult result = [time1 compare:time2 options:NSCaseInsensitiveSearch];
        return result;
    }] mutableCopy];
    
    // 将直播中的
    NSMutableArray * livingArray = [NSMutableArray array];
    for (int i = 0; i < noStartlivingCourseArr.count; i++) {
        NSDictionary * infoDic = [noStartlivingCourseArr objectAtIndex:i];
        if ([[infoDic objectForKey:kLivingState] intValue] == 1) {
            [livingArray addObject:infoDic];
        }
    }
    if (livingArray.count > 0) {
        for (NSDictionary * infoDic in livingArray) {
            [noStartlivingCourseArr removeObject:infoDic];
            [noStartlivingCourseArr insertObject:infoDic atIndex:0];
        }
    }
    
    for (NSDictionary * infoDic in noStartlivingCourseArr) {
        [livingCourseArr addObject:infoDic];
    }
    for (NSDictionary *infoDic in endlivingCourseArr) {
        [livingCourseArr addObject:infoDic];
    }
    
    [hottestArray addObject:livingCourseArr];
    
    // 直播课程小结数据源
    NSMutableArray * livingScrtionCourseArray = [NSMutableArray arrayWithArray:self.courseModuleModel.livingSectionDetailModel.hottestCourses];
    
    NSMutableArray * noStartArr = [NSMutableArray array];
    NSMutableArray * endArr = [NSMutableArray array];
    
    [hottestArray addObject:noStartArr];
    [hottestArray addObject:endArr];
    
    for (int i = 0; i < livingScrtionCourseArray.count; i++) {
        
        CourseModel * jModel = [livingScrtionCourseArray objectAtIndex:i];
        
        NSDictionary *dic = @{kCourseID:@(jModel.courseID),
                              kCourseTeacherName:jModel.coueseTeacherName,
                              kLivingTime:jModel.time,
                              kLivingState:@(jModel.playState),
                              kTeacherDetail:jModel.teacherDetail,
                              kTeacherPortraitUrl:jModel.teacherPortraitUrl,
                              kLivingDetail:jModel.livingDetail,
                              kHaveJurisdiction:@(jModel.haveJurisdiction),
                              kCourseSecondID:@(jModel.sectionId),
                              kCourseSecondName:jModel.courseName,
                              kCourseURL:jModel.courseURLString,
                              kChatRoomID:jModel.chatRoomId,
                              kAssistantID:jModel.assistantId,
                              kPlayBackUrl:jModel.playback,
                              kIsLivingCourseFree:@(jModel.isFree),
                              kIsBack:@(jModel.isBack)};
        
        
        if (jModel.playState == 3) {
            [endArr addObject:dic];
        }else
        {
            [noStartArr addObject:dic];
        }
    }
    
//    NSMutableArray * currentMonthLivingCourseArr = nil;
//    BOOL havaCurrentMonthLivingCOurse = NO;
//    for (int i = 1; i <hottestArray.count; i++) {
//        NSMutableArray * array = [hottestArray objectAtIndex:i];
//        for (NSDictionary * infoDic in array) {
//            havaCurrentMonthLivingCOurse = [NSString judgeCurrentDay:[infoDic objectForKey:kLivingTime]];
//            if (havaCurrentMonthLivingCOurse) {
//                break;
//            }
//        }
//        if (havaCurrentMonthLivingCOurse) {
//            currentMonthLivingCourseArr = array;
//            break;
//        }
//    }
//    if (havaCurrentMonthLivingCOurse) {
//        [hottestArray removeObject:currentMonthLivingCourseArr];
//        [hottestArray insertObject:currentMonthLivingCourseArr atIndex:1];
//    }
    
    return hottestArray;
}

- (NSArray *)getMyLivingCourseArray
{
    // 课程数据源
    NSMutableArray *livingCourseArr = [NSMutableArray array];
    
    NSMutableArray *noStartlivingCourseArr = [NSMutableArray array];
    NSMutableArray *endlivingCourseArr = [NSMutableArray array];
    
    for (CourseModel *model in self.courseModuleModel.myLivingCourseModel.hottestCourses) {
        
        NSDictionary *dic = @{kCourseID:@(model.courseID),
                              kCourseCover:model.courseCover,
                              kCourseName:model.courseName,
                              kCourseTeacherName:model.coueseTeacherName,
                              kLivingTime:model.time,
                              kLivingState:@(model.playState),
                              kTeacherDetail:model.teacherDetail,
                              kTeacherPortraitUrl:model.teacherPortraitUrl,
                              kLivingDetail:model.livingDetail,
                              kHaveJurisdiction:@(model.haveJurisdiction),
                              kLivinglastTime:model.lastTime,
                              kCourseSecondID:@(model.sectionId)};
        
        if (model.lastTime.length == 0) {
            [endlivingCourseArr addObject:dic];
        }else
        {
            [noStartlivingCourseArr addObject:dic];
        }
    }
    
    noStartlivingCourseArr = [[noStartlivingCourseArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString * time1 = [(NSDictionary *)obj1 objectForKey:kLivinglastTime];
        
        NSString * time2 = [(NSDictionary *)obj2 objectForKey:kLivinglastTime];
        
        NSComparisonResult result = [time1 compare:time2 options:NSCaseInsensitiveSearch];
        return result;
    }] mutableCopy];
    
    for (NSDictionary * infoDic in noStartlivingCourseArr) {
        [livingCourseArr addObject:infoDic];
    }
    for (NSDictionary *infoDic in endlivingCourseArr) {
        [livingCourseArr addObject:infoDic];
    }
    
    return livingCourseArr;
}

- (NSArray *)getEndLivingCourseArray
{
    NSMutableArray *hottestArray = [[NSMutableArray alloc] init];
    for (CourseModel *model in self.courseModuleModel.endLivingCourseModel.hottestCourses) {
        NSDictionary *dic = @{kCourseID:@(model.courseID),
                              kCourseCover:model.courseCover,
                              kCourseName:model.courseName,
                              kCourseTeacherName:model.coueseTeacherName,
                              kCourseURL:model.courseURLString,
                              kLivingTime:model.time,
                              kLivingState:@(model.playState),
                              kTeacherDetail:model.teacherDetail,
                              kTeacherPortraitUrl:model.teacherPortraitUrl,
                              kLivingDetail:model.livingDetail};
        [hottestArray addObject:dic];
    }
    return hottestArray;
}

/**
 获取已结束直播课程
 
 @return 已结束直播课程
 */
- (NSArray *)getLivingSectionDetailArray
{
    NSMutableArray *LivingSectionDetailArray = [[NSMutableArray alloc] init];
    
    for (CourseModel *jModel in self.courseModuleModel.livingSectionDetailModel.hottestCourses) {
        NSDictionary *dic = @{kCourseID:@(jModel.courseID),
                              kCourseTeacherName:jModel.coueseTeacherName,
                              kLivingTime:jModel.time,
                              kLivingState:@(jModel.playState),
                              kTeacherDetail:jModel.teacherDetail,
                              kTeacherPortraitUrl:jModel.teacherPortraitUrl,
                              kLivingDetail:jModel.livingDetail,
                              kHaveJurisdiction:@(jModel.haveJurisdiction),
                              kCourseSecondID:@(jModel.sectionId),
                              kCourseSecondName:jModel.courseName,
                              kCourseURL:jModel.courseURLString,
                              kChatRoomID:jModel.chatRoomId,
                              kAssistantID:jModel.assistantId,
                              kPlayBackUrl:jModel.playback,
                              kIsLivingCourseFree:@(jModel.isFree),
                              kIsBack:@(jModel.isBack),
                              kCourseName:jModel.name,
                              kCourseCover:jModel.courseCover,
                              kPrice:@(jModel.price),
                              kOldPrice:@(jModel.oldPrice),
                              kIsDownload:@(jModel.isDownload)
                              };
        [LivingSectionDetailArray addObject:dic];
    }
    return LivingSectionDetailArray;
}

- (NSArray *)getLivingSectionBackDetailArray
{
    NSMutableArray *LivingSectionDetailBackArray = [[NSMutableArray alloc] init];
    
    for (CourseModel *jModel in self.courseModuleModel.livingSectionDetailModel.hottestCourses) {
        NSDictionary *dic = @{kCourseID:@(jModel.courseID),
                              kCourseCover:jModel.courseCover,
                              kCourseName:jModel.name,
                              kCourseTeacherName:jModel.coueseTeacherName,
                              kLivingTime:jModel.time,
                              kLivingState:@(jModel.playState),
                              kTeacherDetail:jModel.teacherDetail,
                              kTeacherPortraitUrl:jModel.teacherPortraitUrl,
                              kLivingDetail:jModel.livingDetail,
                              kHaveJurisdiction:@(jModel.haveJurisdiction),
                              kCourseSecondID:@(jModel.sectionId),
                              kCourseSecondName:jModel.courseName,
                              kCourseURL:jModel.courseURLString,
                              kChatRoomID:jModel.chatRoomId,
                              kAssistantID:jModel.assistantId,
                              kPlayBackUrl:jModel.playback,
                              kIsLivingCourseFree:@(jModel.isFree),
                              kIsBack:@(jModel.isBack),
                              @"type":@(2)};
        
        if (jModel.playState == 3 && jModel.playback.length > 0) {
            [LivingSectionDetailBackArray addObject:dic];
        }
        
    }
    return LivingSectionDetailBackArray;
}

- (NSArray *)getLivingOrderedSectionDetailArray
{
    NSMutableArray *LivingSectionDetailArray = [[NSMutableArray alloc] init];
    
    for (CourseModel *jModel in self.courseModuleModel.livingSectionDetailModel.hottestCourses) {
        NSDictionary *dic = @{kCourseID:@(jModel.courseID),
                              kCourseTeacherName:jModel.coueseTeacherName,
                              kLivingTime:jModel.time,
                              kLivingState:@(jModel.playState),
                              kTeacherDetail:jModel.teacherDetail,
                              kTeacherPortraitUrl:jModel.teacherPortraitUrl,
                              kLivingDetail:jModel.livingDetail,
                              kHaveJurisdiction:@(jModel.haveJurisdiction),
                              kCourseSecondID:@(jModel.sectionId),
                              kCourseSecondName:jModel.courseName,
                              kCourseURL:jModel.courseURLString,
                              kChatRoomID:jModel.chatRoomId,
                              kAssistantID:jModel.assistantId,
                              kPlayBackUrl:jModel.playback,
                              kIsLivingCourseFree:@(jModel.isFree),
                              kIsBack:@(jModel.isBack),
                              kCourseCover:jModel.courseCover,
                              kIsDownload:@(jModel.isDownload)};
        if (jModel.playState == 1) {
            [LivingSectionDetailArray addObject:dic];
        }
    }
    return LivingSectionDetailArray;
}

- (NSArray *)getAllCourseArray
{
    NSMutableArray *allCourseArray = [[NSMutableArray alloc] init];
    for (CourseModel *model in self.courseModuleModel.allCourseModel.allCourseModels) {
        NSDictionary *dic = @{kCourseID:@(model.courseID),
                              kCourseCover:model.courseCover,
                              kCourseName:model.courseName};
        [allCourseArray addObject:dic];
    }
    return allCourseArray;
}

- (NSDictionary *)getPlayCourseInfo
{
    CourseModel *model = self.courseModuleModel.detailCourseModel.courseModel;
    if (model.price == 0.0) {
        model.canWatch = 1;
    }
    
    NSDictionary *dic = @{kCourseID:@(model.courseID),
                          kCourseCover:model.courseCover,
                          kCourseName:model.courseName,
                          kCourseIsCollect:@(model.isCollect),
                          kCourseCanDownLoad:@(model.canDownload),
                          kCanWatch:@(model.canWatch),
                          kPrice:@(model.price),
                          kOldPrice:@(model.oldPrice)};
    return dic;
}

- (NSArray *)getPlayChapterInfo
{
    NSMutableArray *playChapterInfo = [[NSMutableArray alloc] init];
    for (ChapterModel *model in self.courseModuleModel.detailCourseModel.chapters) {
        NSMutableDictionary *chapterDic = [[NSMutableDictionary alloc] init];
        [chapterDic setObject:@(model.isSingleVideo) forKey:kIsSingleChapter];
        [chapterDic setObject:@(model.chapterId) forKey:kChapterId];
        [chapterDic setObject:model.chapterName forKey:kChapterName];
        [chapterDic setObject:model.chapterURL forKey:kChapterURL];
        [chapterDic setObject:@(model.chapterSort) forKey:kChapterSort];
        [playChapterInfo addObject:chapterDic];
    }
    return playChapterInfo;
}

- (NSArray *)getPlayChapterVideoInfo
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (ChapterModel *model in self.courseModuleModel.detailCourseModel.chapters) {
        NSMutableArray *videoArray = [[NSMutableArray alloc] init];
        //每一章只有一个视频
        if (model.isSingleVideo == YES) {
            NSMutableDictionary *videoDic = [[NSMutableDictionary alloc] init];
            [videoDic setObject:model.chapterName forKey:kVideoName];
            [videoDic setObject:model.chapterURL forKey:kVideoURL];
            [videoDic setObject:@(1) forKey:kVideoSort];
            [videoDic setObject:@(YES) forKey:kVideoIsChapterVideo];
            [videoDic setObject:@(model.chapterId) forKey:kVideoId];
            [videoArray addObject:videoDic];
        }else{
            for (VideoModel *video in model.chapterVideos){
                NSMutableDictionary *videoDic = [[NSMutableDictionary alloc] init];
                [videoDic setObject:video.videoName forKey:kVideoName];
                [videoDic setObject:@(video.videoID) forKey:kVideoId];
                [videoDic setObject:@(video.videoSort) forKey:kVideoSort];
                [videoDic setObject:@(NO) forKey:kVideoIsChapterVideo];
                [videoDic setObject:video.videoURLString forKey:kVideoURL];
                
                [videoArray addObject:videoDic];
            }
        }
        [array addObject:videoArray];
    }
    return array;
}

- (NSArray *)getAllCategoryArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (CourseCategoryModel *model in self.courseModuleModel.allCourseCategoryModel.allCategory) {
        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
        [tmpDic setObject:model.categoryName forKey:kCourseCategoryName];
        [tmpDic setObject:@(model.categoryId) forKey:kCourseCategoryId];
        [tmpDic setObject:model.categoryImageUrl forKey:kCourseCategoryCoverUrl];
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        for (CourseCategorysecondModel *courseSecondModel in model.categrorySecondCoursesArray) {
            NSMutableDictionary *tmpDic2 = [[NSMutableDictionary alloc] init];
            [tmpDic2 setObject:@(courseSecondModel.categorySecondId) forKey:kCourseSecondID];
            [tmpDic2 setObject:courseSecondModel.categorySecondName forKey:kCourseSecondName];
            [tmpDic2 setObject:courseSecondModel.categorySecondImageUrl forKey:kCourseSecondCover];
            [tmpDic2 setObject:@(1) forKey:kIsFold];
            NSMutableArray * array2 = [[NSMutableArray alloc]init];
            for (CourseModel *courseModel in courseSecondModel.categroryCoursesArray) {
                NSMutableDictionary * tmpDic3 = [[NSMutableDictionary alloc]init];
                [tmpDic3 setObject:@(courseModel.courseID) forKey:kCourseID];
                [tmpDic3 setObject:courseModel.courseName forKey:kCourseName];
                [tmpDic3 setObject:courseModel.courseCover forKey:kCourseCover];
                [tmpDic3 setObject:courseModel.coueseTeacherName forKey:kCourseTeacherName];
                [tmpDic3 setObject:@(courseModel.price) forKey:kPrice];
                [array2 addObject:tmpDic3];
            }
            [tmpDic2 setObject:array2 forKey:kCourseCategorySecondCourseInfos];
            
            [array1 addObject:tmpDic2];
        }
        [tmpDic setObject:array1 forKey:kCourseCategoryCourseInfos];
        
        [array addObject:tmpDic];
    }
    return array;
}

- (NSArray *)getAllPackageList
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (CourseCategoryModel *model in self.courseModuleModel.allPackage.allCategory) {
        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
        
        
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        for (CourseCategorysecondModel *courseSecondModel in model.categrorySecondCoursesArray) {
            NSMutableDictionary *tmpDic2 = [[NSMutableDictionary alloc] init];
            [tmpDic2 setObject:@(courseSecondModel.categorySecondId) forKey:kCourseSecondID];
            [tmpDic2 setObject:courseSecondModel.categorySecondName forKey:kCourseSecondName];
            [tmpDic setObject:@(courseSecondModel.categorySecondId) forKey:kCourseCategoryId];
            [tmpDic setObject:courseSecondModel.categorySecondName forKey:kCourseCategoryName];
            
//            [tmpDic2 setObject:courseSecondModel.categorySecondImageUrl forKey:kCourseSecondCover];
            [tmpDic2 setObject:@(1) forKey:kIsFold];
            NSMutableArray * array2 = [[NSMutableArray alloc]init];
            for (CourseModel *courseModel in courseSecondModel.categroryCoursesArray) {
                NSMutableDictionary * tmpDic3 = [[NSMutableDictionary alloc]init];
                [tmpDic3 setObject:@(courseModel.courseID) forKey:kCourseID];
                [tmpDic3 setObject:courseModel.courseName forKey:kCourseName];
                [tmpDic3 setObject:courseModel.courseCover forKey:kCourseCover];
                [tmpDic3 setObject:courseModel.priceSection forKey:kPrice];
                [tmpDic3 setObject:@(courseModel.isRecommend) forKey:kIsRecommend];
                [tmpDic3 setObject:@(YES) forKey:@"package"];
                [array2 addObject:tmpDic3];
            }
            [tmpDic2 setObject:array2 forKey:kCourseCategorySecondCourseInfos];
            
            [array1 addObject:tmpDic2];
        }
        [tmpDic setObject:array1 forKey:kCourseCategoryCourseInfos];
        
        [array addObject:tmpDic];
    }
    return array;
}

- (NSDictionary *)getRecommendInfoDic
{
    NSDictionary * infoDic = [NSDictionary dictionary];
    for (CourseCategoryModel *model in self.courseModuleModel.allPackage.allCategory) {
       
        for (CourseCategorysecondModel *courseSecondModel in model.categrorySecondCoursesArray) {
            
            for (CourseModel *courseModel in courseSecondModel.categroryCoursesArray) {
                if (courseModel.isRecommend) {
                    NSMutableDictionary * tmpDic3 = [[NSMutableDictionary alloc]init];
                    [tmpDic3 setObject:@(courseModel.courseID) forKey:kCourseID];
                    [tmpDic3 setObject:courseModel.courseName forKey:kCourseName];
                    [tmpDic3 setObject:courseModel.courseCover forKey:kCourseCover];
                    [tmpDic3 setObject:courseModel.priceSection forKey:kPrice];
                    [tmpDic3 setObject:@(courseModel.isRecommend) forKey:kIsRecommend];
                    [tmpDic3 setObject:@(YES) forKey:@"package"];
                    infoDic = tmpDic3;
                }
            }
        }
    }
    return infoDic;
}

- (NSDictionary *)getPackageDetailInfo
{
    return self.packageDetailOperation.infoDic;
}

- (NSArray *)getMainVCCategoryArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (CourseCategoryModel *model in self.courseModuleModel.allCourseCategoryModel.allCategory) {
        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
        [tmpDic setObject:model.categoryName forKey:kCourseCategoryName];
        [tmpDic setObject:@(model.categoryId) forKey:kCourseCategoryId];
        [tmpDic setObject:model.categoryImageUrl forKey:kCourseCategoryCoverUrl];
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        
        switch (model.categoryId) {
            case 52:
            case 62:
            case 44:
            case 46:
            case 40:
            {
                for (CourseCategorysecondModel *courseSecondModel in model.categrorySecondCoursesArray) {
                    NSMutableDictionary *tmpDic2 = [[NSMutableDictionary alloc] init];
                    [tmpDic2 setObject:@(courseSecondModel.categorySecondId) forKey:kCourseSecondID];
                    [tmpDic2 setObject:courseSecondModel.categorySecondName forKey:kCourseSecondName];
                    [tmpDic2 setObject:courseSecondModel.categorySecondImageUrl forKey:kCourseSecondCover];
                    
                    NSMutableArray * array2 = [[NSMutableArray alloc]init];
                    for (CourseModel *courseModel in courseSecondModel.categroryCoursesArray) {
                        NSMutableDictionary * tmpDic3 = [[NSMutableDictionary alloc]init];
                        [tmpDic3 setObject:@(courseModel.courseID) forKey:kCourseID];
                        [tmpDic3 setObject:courseModel.courseName forKey:kCourseName];
                        [tmpDic3 setObject:courseModel.courseCover forKey:kCourseCover];
                        [tmpDic3 setObject:courseModel.coueseTeacherName forKey:kCourseTeacherName];
                        [tmpDic3 setObject:@(courseModel.price) forKey:kPrice];
                        [array2 addObject:tmpDic3];
                    }
                    [tmpDic2 setObject:array2 forKey:kCourseCategorySecondCourseInfos];
                    
                    [array1 addObject:tmpDic2];
                }
                [tmpDic setObject:array1 forKey:kCourseCategoryCourseInfos];
                
                [array addObject:tmpDic];
            }
                break;
                
            default:
                break;
        }
        
        
    }
    return array;
}


- (NSArray *)getCategoryCoursesInfo
{
    NSMutableArray *courseArray = [[NSMutableArray alloc] init];
    for (CourseCategorysecondModel *courseSecondModel in self.courseModuleModel.courseCategoryDetailModel.courseModels) {
        NSMutableDictionary *tmpDic2 = [[NSMutableDictionary alloc] init];
        [tmpDic2 setObject:@(courseSecondModel.categorySecondId) forKey:kCourseSecondID];
        [tmpDic2 setObject:courseSecondModel.categorySecondName forKey:kCourseSecondName];
        [tmpDic2 setObject:courseSecondModel.categorySecondImageUrl forKey:kCourseSecondCover];
        
        NSMutableArray * array2 = [[NSMutableArray alloc]init];
        for (CourseModel *courseModel in courseSecondModel.categroryCoursesArray) {
            NSMutableDictionary * tmpDic3 = [[NSMutableDictionary alloc]init];
            [tmpDic3 setObject:@(courseModel.courseID) forKey:kCourseID];
            [tmpDic3 setObject:courseModel.courseName forKey:kCourseName];
            [tmpDic3 setObject:courseModel.courseCover forKey:kCourseCover];
            [tmpDic3 setObject:courseModel.coueseTeacherName forKey:kCourseTeacherName];
            [array2 addObject:tmpDic3];
        }
        [tmpDic2 setObject:array2 forKey:kCourseCategorySecondCourseInfos];
        
        [courseArray addObject:tmpDic2];
    }
    return courseArray;
}

- (NSArray *)getHistoryInfoArray
{
    NSMutableArray *infoArray = [[NSMutableArray alloc] init];
    for (HistoryDayModel *model in self.courseModuleModel.historyDisplayModels) {
        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
        [tmpDic setObject:model.timeString forKey:kHistoryTime];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (HistoryDisplayModel *disModel in model.historyModels) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:disModel.courseName forKey:kCourseName];
            [dic setObject:@(disModel.courseId) forKey:kCourseID];
            [dic setObject:disModel.courseCover forKey:kCourseCover];
            [dic setObject:disModel.chapterName forKey:kChapterName];
            [dic setObject:@(disModel.chapterId) forKey:kChapterId];
            [dic setObject:disModel.videoName forKey:kVideoName];
            [dic setObject:@(disModel.videoId) forKey:kVideoId];
            [array addObject:dic];
        }
        
        [tmpDic setObject:array forKey:kHistoryInfos];
        [infoArray addObject:tmpDic];
    }
    return infoArray;
}

- (NSMutableDictionary *)getPlayingInfoDic
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    PlayingInfoModel *model = self.courseModuleModel.playingInfoModel;
    [dic setObject:model.courseName forKey:kCourseName];
    [dic setObject:@(model.courseId) forKey:kCourseID];
    [dic setObject:model.chapterName forKey:kChapterName];
    [dic setObject:@(model.chapterId) forKey:kChapterId];
    [dic setObject:model.videoName forKey:kVideoName];
    [dic setObject:@(model.videoId) forKey:kVideoId];
    return dic;
}

- (NSArray *)getLearningCourseInfoArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (CourseModel *model in self.learningCourseOperation.learningCourseArray) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:model.courseName forKey:kCourseName];
        [dic setObject:@(model.courseID) forKey:kCourseID];
        [dic setObject:model.courseCover forKey:kCourseCover];
        [dic setObject:model.coueseTeacherName forKey:kCourseTeacherName];
        [dic setObject:model.lastTime forKey:kLivingTime];
        [dic setObject:[NSNumber numberWithDouble:model.learnProgress] forKey:kLearnProgress];
        [array addObject:dic];
    }
    return array;
}

- (NSArray *)getCompleteCourseInfoArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (CourseModel *model in self.learningCourseOperation.completeCourseArray) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:model.courseName forKey:kCourseName];
        [dic setObject:@(model.courseID) forKey:kCourseID];
        [dic setObject:model.courseCover forKey:kCourseCover];
        [dic setObject:model.coueseTeacherName forKey:kCourseTeacherName];
        [dic setObject:model.lastTime forKey:kLivingTime];
        [dic setObject:[NSNumber numberWithDouble:model.learnProgress] forKey:kLearnProgress];
        [array addObject:dic];
    }
    return array;
}

- (NSArray *)getCollectCourseInfoArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (CourseModel *model in self.courseModuleModel.collectCourseArray) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:model.courseName forKey:kCourseName];
        [dic setObject:@(model.courseID) forKey:kCourseID];
        [dic setObject:model.courseCover forKey:kCourseCover];
        [dic setObject:model.coueseTeacherName forKey:kCourseTeacherName];
        [array addObject:dic];
    }
    return array;
}

- (void )refreshLivingSectionStateOrder_complate:(int)index
{
    CourseModel * model = self.courseModuleModel.livingSectionDetailModel.hottestCourses[index];
    model.playState = 1;
}

- (void )refreshLivingSectionStateOrder_complateWith:(NSDictionary *)infoDic
{
    for (CourseModel * model in self.courseModuleModel.livingSectionDetailModel.hottestCourses) {
        if (model.sectionId == [[infoDic objectForKey:kCourseSecondID] intValue]) {
            if (model.playState == 1) {
                model.playState = 0;
            }else
            {
                model.playState = 1;
            }
        }
        
    }
}

#pragma mark - utility func

@end
