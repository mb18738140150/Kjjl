//
//  CourseModuleModel.m
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CourseModuleModel.h"

@implementation CourseModuleModel

- (instancetype)init
{
    if (self = [super init]) {
        [self initalModels];
    }
    return self;
}

- (void)initalModels
{
    self.hottestCourseModel = [[HottestCourseModel alloc] init];
    self.hotSearchVideoModel = [[HottestCourseModel alloc]init];
    self.hotSearchLivingStreamModel = [[HottestCourseModel alloc]init];
    self.searchLiveStreamModel = [[HottestCourseModel alloc]init];
    self.searchVideoCourseModel = [[HottestCourseModel alloc]init];
    self.notStartLivingCourseModel = [[HottestCourseModel alloc]init];
//    self.notStartLivingSectionCourseModel = [[HottestCourseModel alloc]init];
    self.endLivingCourseModel = [[HottestCourseModel alloc]init];
    self.allCourseModel = [[AllCourseModel alloc] init];
    self.detailCourseModel = [[DetailCourseModel alloc] init];
    self.allCourseCategoryModel = [[AllCourseCategoryModel alloc] init];
    self.allPackage = [[AllCourseCategoryModel alloc]init];
    self.courseCategoryDetailModel = [[CourseCategoryDetailModel alloc] init];
    self.livingSectionDetailModel = [[HottestCourseModel alloc]init];
    
    self.playingInfoModel = [[PlayingInfoModel alloc] init];
    
    self.historyDisplayModels = [[NSMutableArray alloc] init];
    
    self.learningCourseArray = [[NSMutableArray alloc] init];
    
    self.collectCourseArray = [[NSMutableArray alloc] init];
}

@end
