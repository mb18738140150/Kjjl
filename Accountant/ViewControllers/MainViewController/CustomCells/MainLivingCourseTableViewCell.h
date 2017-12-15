//
//  MainLivingCourseTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/10/10.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelayButton.h"

typedef enum : NSUInteger {
    LivingCellType_nomal,
    LivingCellType_Living,
    LivingCellType_Order,
} LivingCellType;

@interface MainLivingCourseTableViewCell : UITableViewCell

@property (nonatomic, assign)LivingCellType livingCellType;

@property (nonatomic,strong) UIImageView        *courseCoverImageView;
@property (nonatomic, strong)UIImageView        *payImageView;

@property (nonatomic, strong)UILabel *courseChapterNameLabel;// 课程所属分类名

@property (nonatomic,strong) UILabel            *courseNameLabel;// 课程名

@property (nonatomic, strong)UIImageView *teacherIconImageView;
@property (nonatomic, strong)UILabel *teacherNameLabel;
@property (nonatomic, strong)UIImageView *timeImageView;
@property (nonatomic,strong) UILabel            *timeLabel;
@property (nonatomic, strong)UIView *seperateLine;
@property (nonatomic, strong)UIButton *cancelBtn;


@property (nonatomic, strong)UILabel * playTimeLB;
@property (nonatomic, copy)void(^mainCountDownFinishBlock)();

@property (nonatomic, copy)void(^cancelOrderLivingCourseBlock)();

- (void)resetCellContent:(NSDictionary *)courseInfo;

@end
