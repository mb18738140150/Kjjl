//
//  CourseModuleProtocol.h
//  Accountant
//
//  Created by aaa on 2017/3/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CourseModule_DetailCourseProtocol <NSObject>

- (void)didRequestCourseDetailSuccessed;
- (void)didRequestCourseDetailFailed:(NSString *)failedInfo;

@end

@protocol CourseModule_AllCourseProtocol <NSObject>

- (void)didRequestAllCourseSuccessed;
- (void)didRequestAllCourseFailed;

@end

@protocol CourseModule_AllCourseCategoryProtocol <NSObject>

- (void)didRequestAllCourseCategorySuccessed;
- (void)didRequestAllCourseFailed;

@end

@protocol CourseModule_CourseCategoryDetailProtocol <NSObject>

- (void)didReuquestCourseCategoryDetailSuccessed;
- (void)didReuquestCourseCategoryDetailFailed:(NSString *)failedInfo;

@end

@protocol CourseModule_HottestCourseProtocl <NSObject>

- (void)didRequestHottestCourseSuccessed;
- (void)didRequestHottestFailed;

@end

@protocol CourseModule_HistoryCourseProtocol <NSObject>

- (void)didRequestHistroyCourseSuccessed;
- (void)didRequestHistroyCourseFailed:(NSString *)failedInfo;

@end

@protocol CourseModule_LearningCourseProtocol <NSObject>

- (void)didRequestLearningCourseSuccessed;
- (void)didRequestLearningCourseFailed:(NSString *)failedInfo;

@end

@protocol CourseModule_CompleteCourseProtocol <NSObject>

- (void)didRequestCompleteCourseSuccessed;
- (void)didRequestCompleteCourseFailed:(NSString *)failedInfo;

@end

@protocol CourseModule_CollectCourseProtocol <NSObject>

- (void)didRequestCollectCourseSuccessed;
- (void)didRequestCollectCourseFailed:(NSString *)failedInfo;

@end

@protocol CourseModule_AddCollectCourseProtocol <NSObject>

- (void)didRequestAddCollectCourseSuccessed;
- (void)didRequestAddCollectCourseFailed:(NSString *)failedInfo;

@end

@protocol CourseModule_DeleteCollectCourseProtocol <NSObject>

- (void)didRequestDeleteCollectCourseSuccessed;
- (void)didRequestDeleteCollectCourseFailed:(NSString *)failedInfo;

@end

@protocol CourseModule_HotSearchProtocol <NSObject>

- (void)didRequestHotSearchCourseSuccessed;
- (void)didRequestHotSearchCourseFailed:(NSString *)faildInfo;

@end

@protocol CourseModule_VideoCourseProtocol <NSObject>

- (void)didRequestVideoCourseSuccessed;
- (void)didRequestVideoCourseFailed;

@end

@protocol CourseModule_LiveStreamProtocol <NSObject>

- (void)didRequestLiveStreamSuccessed;
- (void)didRequestLiveStreamFailed:(NSString *)failStr;

@end

@protocol CourseModule_NotStartLivingCourse <NSObject>

- (void)didRequestNotStartLivingCourseSuccessed;
- (void)didRequestNotStartLivingCourseFailed:(NSString *)failedInfo;

@end

@protocol CourseModule_EndLivingCourse <NSObject>

- (void)didRequestEndLivingCourseSuccessed;
- (void)didRequestEndLivingCourseFailed:(NSString *)failedInfo;

@end

@protocol CourseModule_LivingSectionDetail <NSObject>

- (void)didRequestLivingSectionDetailSuccessed;
- (void)didRequestLivingSectionDetailFailed:(NSString *)failedInfo;

@end
