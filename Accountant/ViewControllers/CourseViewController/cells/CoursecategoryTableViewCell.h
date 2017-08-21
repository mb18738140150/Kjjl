//
//  CoursecategoryTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/4/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelayButton.h"

typedef enum : NSUInteger {
    CourseCategoryType_hot,
    CourseCategoryType_nomal,
    CourseCategoryType_downLoading,
} CourseCategoryType;

@interface CoursecategoryTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView        *courseCoverImageView;
@property (nonatomic, strong)UILabel *courseChapterNameLabel;// 课程所属分类名
@property (nonatomic, strong)UIView *maskView;// 蒙版
@property (nonatomic, strong)UIProgressView *progressView;
@property (nonatomic, strong)UILabel * progresslabel;

@property (nonatomic,strong) UILabel            *courseNameLabel;// 课程名

@property (nonatomic, strong)UIImageView *teacherIconImageView;
@property (nonatomic, strong)UILabel *teacherNameLabel;
@property (nonatomic, strong)UIImageView *countImageView;
@property (nonatomic,strong) UILabel            *courseCountLabel;
@property (nonatomic, strong)UIView *seperateLine;

@property (nonatomic, strong)DelayButton *stateBT;
@property (nonatomic, assign)CourseCategoryType courseType;

@property (nonatomic, copy)void(^DownStateBlock)(BOOL isPause);

- (void)resetCellContent:(NSDictionary *)courseInfo;
@end
