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

//课程名称
@property (nonatomic,strong) NSString       *courseName;

@property (nonatomic, copy) NSString      *coueseTeacherName;

//课程url string
@property (nonatomic,strong) NSString       *courseURLString;

@property (nonatomic,assign) BOOL            isCollect;

@property (nonatomic, strong)NSString * time;
@property (nonatomic, assign)int playState;


// 直播课
@property (nonatomic, strong)NSString *teacherPortraitUrl;
@property (nonatomic, strong)NSString *teacherDetail;
@property (nonatomic, strong)NSString *livingDetail;

@end
