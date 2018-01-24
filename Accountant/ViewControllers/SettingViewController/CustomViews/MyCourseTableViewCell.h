//
//  MyCourseTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/12/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProcessView.h"

typedef enum : NSUInteger {
    MyCourseCategoryType_learning,
    MyCourseCategoryType_complate,
    MyCourseCategoryType_collection,
} MyCourseCategoryType;

@interface MyCourseTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView        *courseCoverImageView;
@property (nonatomic,strong) UILabel            *courseNameLabel;// 课程名

@property (nonatomic, strong)UIImageView *teacherIconImageView;
@property (nonatomic, strong)UILabel *teacherNameLabel;


@property (nonatomic, strong)UILabel * lastTimeLB;
@property (nonatomic, strong)UILabel * progresslabel;
@property (nonatomic, strong)ProcessView *learnProcessView;
@property (nonatomic,strong) UILabel            *courseStateLabel;
@property (nonatomic, strong)UIView *seperateLine;

@property (nonatomic, strong)UIButton *deleteBtn;

@property (nonatomic, assign)MyCourseCategoryType myCourseType;

@property (nonatomic, copy)void(^DeleteCourseBlock)(NSDictionary *infoDic,MyCourseCategoryType type);
@property (nonatomic, strong)NSDictionary *infoDic;

- (void)resetCellContent:(NSDictionary *)courseInfo;

@end
