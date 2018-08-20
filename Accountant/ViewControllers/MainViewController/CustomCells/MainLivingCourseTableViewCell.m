//
//  MainLivingCourseTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/10/10.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MainLivingCourseTableViewCell.h"
#import "CommonMacro.h"
#import "UIImageView+AFNetworking.h"
#import "UIUtility.h"
#import "UIMacro.h"
#import "DelayButton+helper.h"

@interface MainLivingCourseTableViewCell ()

@property (nonatomic, assign)NSInteger      day;
@property (nonatomic, assign)NSInteger      hour;
@property (nonatomic, assign)NSInteger      minute;
@property (strong, nonatomic)  CountDown *countDown;

@end

@implementation MainLivingCourseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)resetCellContent:(NSDictionary *)courseInfo
{
    
    [self.contentView removeAllSubviews];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = [UIColor colorWithWhite:.98 alpha:1];
    
    // 课程icon
    self.courseCoverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 120, 80)];
    [self.courseCoverImageView setImageWithURL:[NSURL URLWithString:[courseInfo objectForKey:kCourseCover]]];
    self.courseCoverImageView.layer.cornerRadius = 2;
    self.courseCoverImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.courseCoverImageView];
    
//    self.payImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.courseCoverImageView.frame) - 43, 7, 40, 16)];
//    self.payImageView.image = [UIImage imageNamed:@"会员免费"];
//    [self.contentView addSubview:self.payImageView];
    
    /*
     
     CGFloat courseChapterNameLabelWidth = [UIUtility getWidthWithText:[courseInfo objectForKey:kCourseSecondName] font:[UIFont systemFontOfSize:11] height:15];
     // 课程分类
     self.courseChapterNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.courseCoverImageView.frame) - courseChapterNameLabelWidth, 10, courseChapterNameLabelWidth, 15)];
     self.courseChapterNameLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
     self.courseChapterNameLabel.textColor = [UIColor whiteColor];
     self.courseChapterNameLabel.text = [courseInfo objectForKey:kCourseSecondName];
     self.courseChapterNameLabel.font = [UIFont systemFontOfSize:11];
     [self.contentView addSubview:self.courseChapterNameLabel];
     */
    
    /*
     // 状态按钮
     self.stateBT = [DelayButton buttonWithType:UIButtonTypeCustom];
     self.stateBT.frame = CGRectMake(self.maskView.hd_centerX - 10, 10, 20, 20);
     self.stateBT.clickDurationTime = 1;
     [self.stateBT setImage:[UIImage imageNamed:@"download-pause"] forState:UIControlStateNormal];
     [self.stateBT setImage:[UIImage imageNamed:@"download-play"] forState:UIControlStateSelected];
     [self addSubview:self.stateBT];
     [self.stateBT addTarget:self action:@selector(downStateAction:) forControlEvents:UIControlEventTouchUpInside];
     
     */
    
    // 课程名称
    CGFloat height = [UIUtility getHeightWithText:[courseInfo objectForKey:kCourseName] font:kMainFont width:kScreenWidth - (self.courseCoverImageView.frame.origin.x + self.courseCoverImageView.frame.size.width + 10) - 15];
    height = 20;
    self.courseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.courseCoverImageView.frame.origin.x + self.courseCoverImageView.frame.size.width + 10, 10, kScreenWidth -(self.courseCoverImageView.frame.origin.x + self.courseCoverImageView.frame.size.width + 10) - 15 , 20)];
    self.courseNameLabel.text = [courseInfo objectForKey:kCourseName];
    self.courseNameLabel.font = kMainFont;
    self.courseNameLabel.numberOfLines = 0;
    self.courseNameLabel.textColor = kMainTextColor;
    [self.contentView addSubview:self.courseNameLabel];
       
    
    // 讲师
    self.teacherIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.courseCoverImageView.frame) + 10, self.courseCoverImageView.hd_centerY - 7 , 12, 13)];
    self.teacherIconImageView.image = [UIImage imageNamed:@"mainLiving_teacher"];
    [self.contentView addSubview:self.teacherIconImageView];
    
    self.teacherNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.teacherIconImageView.frame) + 5, self.courseCoverImageView.hd_centerY - 10, 60, 20)];
    self.teacherNameLabel.font = [UIFont systemFontOfSize:12];
    self.teacherNameLabel.textColor = kCommonMainTextColor_150;
    self.teacherNameLabel.text = [courseInfo objectForKey:kCourseTeacherName];
    [self.contentView addSubview:self.teacherNameLabel];
    
    // 时间
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 15, self.courseCoverImageView.hd_centerY - 10, 100, 20)];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = [UIColor redColor];
    if (self.livingCellType == LivingCellType_Order || self.livingCellType == LivingCellType_Living) {
        self.timeLabel.text = [self getTime1With:[NSString stringWithFormat:@"%@", [[[courseInfo objectForKey:kLivingTime] componentsSeparatedByString:@"~"] objectAtIndex:0]]];
    }else
    {
        self.timeLabel.text = [self getTimeWith:[courseInfo objectForKey:kLivinglastTime]];
    }

    CGFloat width = [UIUtility getWidthWithText:self.timeLabel.text font:[UIFont systemFontOfSize:13] height:20];
    self.timeLabel.frame = CGRectMake(kScreenWidth - 15 - width, self.courseCoverImageView.hd_centerY - 10, width + 5, 20);
    
    [self.contentView addSubview:self.timeLabel];
    
    self.timeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.timeLabel.hd_x - 5 - 12 , self.courseCoverImageView.hd_centerY - 7, 12, 13)];
    [self.contentView addSubview:self.timeImageView];
    
//    if (height >= 30) {
//        self.teacherIconImageView.hd_y = self.courseCoverImageView.hd_centerY;
//        self.teacherNameLabel.hd_y = self.courseCoverImageView.hd_centerY - 3;
//        self.timeLabel.hd_y = self.courseCoverImageView.hd_centerY - 3;
//        self.timeImageView.hd_y = self.courseCoverImageView.hd_centerY;
//    }
    
    self.playTimeLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.courseCoverImageView.frame) + 10, CGRectGetMaxY(self.courseCoverImageView.frame) - 20, self.hd_width - self.courseCoverImageView.hd_width - 50, 20)];
    self.playTimeLB.font = [UIFont systemFontOfSize:11];
    self.playTimeLB.textColor = kCommonMainTextColor_150;
    self.playTimeLB.text = [[[courseInfo objectForKey:kLivingTime] componentsSeparatedByString:@"~"] objectAtIndex:0];
    [self.contentView addSubview:self.playTimeLB];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake(kScreenWidth - 62, self.playTimeLB.hd_y - 1, 52, 21);
    [self.cancelBtn setTitle:@"取消预约" forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.cancelBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    self.cancelBtn.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
    self.cancelBtn.layer.borderWidth = 1;
    self.cancelBtn.layer.cornerRadius = 4;
    self.cancelBtn.layer.masksToBounds = YES;
    [self.cancelBtn addTarget:self action:@selector(cancelOrderAction) forControlEvents:UIControlEventTouchUpInside];
    if (self.livingCellType == LivingCellType_Order) {
        [self.contentView addSubview:self.cancelBtn];
    }
    
    // 分割线
    self.seperateLine = [[UIView alloc]initWithFrame:CGRectMake(0, 99, kScreenWidth, 1)];
    self.seperateLine.backgroundColor = kTableViewCellSeparatorColor;
    [self.contentView addSubview:self.seperateLine];
    
    [self showMask];
    
    if (self.livingCellType == LivingCellType_nomal) {
        ;
        int playType = [[courseInfo objectForKey:kLivingState] intValue];
        switch (playType) {
            case 0:
                self.timeImageView.image = [UIImage imageNamed:@"main_playTime"];
                break;
            case 1:
                self.timeImageView.image = [UIImage imageNamed:@"main_playing"];
                self.timeLabel.text = @"正在直播";
                [self refreshTimeFrame];
                break;
            case 2:
                [self hiddenMask];
                
                break;
            default:
                break;
        }
    }
    if (self.livingCellType == LivingCellType_Order || self.livingCellType == LivingCellType_Living) {
        self.timeLabel.textColor = UIColorFromRGB(0xff4e00);
        self.backgroundColor = [UIColor whiteColor];
        self.courseNameLabel.text = [courseInfo objectForKey:kCourseSecondName];
        self.timeImageView.image = [UIImage imageNamed:@"main_playTime"];
    }
    
    if ([self.timeLabel.text isEqualToString:@"正在直播"] || [self.timeLabel.text isEqualToString:@"已结束"]) {
        return;
    }
    
    
    self.countDown = nil;
    self.countDown = [[CountDown alloc] init];
    __weak __typeof(self) weakSelf= self;
    ///每分回调一次
    [self.countDown countDownWithPER_MINBlock:^{
        
        [weakSelf updateTimeInVisibleCells:courseInfo];
    }];
    
}

- (void)cancelOrderAction
{
    if (self.cancelOrderLivingCourseBlock) {
        self.cancelOrderLivingCourseBlock();
    }
}

- (void)refreshTimeFrame
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.timeLabel.text = @"正在直播";
        
        CGFloat width = [UIUtility getWidthWithText:self.timeLabel.text font:[UIFont systemFontOfSize:13] height:20];
        self.timeLabel.frame = CGRectMake(kScreenWidth - 15 - width, self.courseCoverImageView.hd_centerY - 10, width + 5, 20);
        
        self.timeImageView.frame = CGRectMake(self.timeLabel.hd_x - 5 - 12 , self.courseCoverImageView.hd_centerY - 7, 12, 13);
    });
}

- (void)updateTimeInVisibleCells:(NSDictionary *)infoDic
{
    __weak typeof(self)weakSelf = self;
    if ([[infoDic objectForKey:kLivinglastTime] length] == 0) {
        return;
    }
    
    if (weakSelf.minute <= 0) {
        if (weakSelf.hour <= 0) {
            if (weakSelf.day <= 0) {
                weakSelf.countDown = nil;
                if (weakSelf.mainCountDownFinishBlock) {
                    weakSelf.mainCountDownFinishBlock();
                }
            }else
            {
                weakSelf.day--;
                weakSelf.hour = 23;
                weakSelf.minute = 59;
            }
        }else
        {
            weakSelf.hour--;
            weakSelf.minute = 59;
        }
    }else{
        weakSelf.minute--;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString * timeString = [NSString stringWithFormat:@"%ld天%ld小时%ld分钟",(long)self.day, (long)self.hour,(long)self.minute];
        
        if (_day == 0) {
            if (_hour == 0 && _minute > 0 && _minute < 15) {
                timeString = @"即将开始";
            }else{
                timeString = [NSString stringWithFormat:@"%ld小时%ld分钟", (long)self.hour,(long)self.minute];
            }
        }
        weakSelf.timeLabel.text = timeString;
    });
}

- (void)hiddenMask
{
    self.timeImageView.hidden = YES;
    self.timeLabel.hidden = YES;
}

- (void)showMask
{
    self.timeImageView.hidden = NO;
    self.timeLabel.hidden = NO;
}

- (NSString *)getTimeWith:(NSString *)timeStr
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    
    // 截止时间字符串格式
    NSString * expireDateStr = timeStr;
    //    expireDateStr = @"2017/9/14 16:25:00";
    // 当前时间字符串格式
    NSString *nowDateStr = [dateFomatter stringFromDate:nowDate];
    // 截止时间data格式
    NSDate *expireDate = [dateFomatter dateFromString:expireDateStr];
    // 当前时间data格式
    nowDate = [dateFomatter dateFromString:nowDateStr];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:0];
    
    self.day = dateCom.month * 30  + dateCom.day;
    
    self.hour = dateCom.hour;
    
    self.minute = dateCom.minute;
    if (_day <= 0) {
        _day = 0;
    }
    if (_hour <= 0) {
        _hour = 0;
    }
    
    if (_minute <= 0) {
        _minute = 0;
    }
    
    NSString * timeString = [NSString stringWithFormat:@"%ld天%ld小时%ld分钟",(long)self.day, (long)self.hour,(long)self.minute];
    
    if (_day == 0) {
        timeString = [NSString stringWithFormat:@"%ld小时%ld分钟", (long)self.hour,(long)self.minute];
    }
    
    if (_day == 0 && _hour == 0 && _minute > 0 && _minute < 15) {
        timeString = @"即将开始";
    }
    if (_day == 0 && _hour == 0 && _minute == 0) {
        timeString = @"已结束";
    }
    
    return timeString;
}

- (NSString *)getTime1With:(NSString *)timeStr
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    // 截止时间字符串格式
    NSString * expireDateStr = timeStr;
    //    expireDateStr = @"2017/9/14 16:25:00";
    // 当前时间字符串格式
    NSString *nowDateStr = [dateFomatter stringFromDate:nowDate];
    // 截止时间data格式
    NSDate *expireDate = [dateFomatter dateFromString:expireDateStr];
    // 当前时间data格式
    nowDate = [dateFomatter dateFromString:nowDateStr];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:0];
    
    self.day = dateCom.month * 30  + dateCom.day;
    
    self.hour = dateCom.hour;
    
    self.minute = dateCom.minute;
    if (_day <= 0) {
        _day = 0;
    }
    if (_hour <= 0) {
        _hour = 0;
    }
    
    if (_minute <= 0) {
        _minute = 0;
    }
    
    NSString * timeString = [NSString stringWithFormat:@"%ld天%ld小时%ld分钟",(long)self.day, (long)self.hour,(long)self.minute];
    
    if (_day == 0) {
        timeString = [NSString stringWithFormat:@"%ld小时%ld分钟", (long)self.hour,(long)self.minute];
    }
    
    if (_day == 0 && _hour == 0 && _minute > 0 && _minute < 15) {
        timeString = @"即将开始";
    }
    if (_day == 0 && _hour == 0 && _minute == 0) {
        timeString = @"已结束";
    }
    
    return timeString;
}

- (NSAttributedString *)getTimeStrWithDay:(NSInteger)day andHoour:(NSInteger)hour andMinute:(NSInteger)minute
{
    NSString * timeString = [NSString stringWithFormat:@"%ld小时%ld分钟", (long)hour,(long)minute];
    
    NSRange hourRange = [timeString rangeOfString:[NSString stringWithFormat:@"%ld小时", (long)hour]];
    NSRange minuteRange = [timeString rangeOfString:[NSString stringWithFormat:@"%ld分钟", (long)minute]];
    
    NSMutableAttributedString * mTimeStr = [[NSMutableAttributedString alloc]initWithString:timeString];
    
//    NSDictionary * timeAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:25],NSForegroundColorAttributeName:kCommonMainColor};
//    [mTimeStr setAttributes:timeAttribute range:NSMakeRange(hourRange.location, hourRange.length - 2)];
//    [mTimeStr setAttributes:timeAttribute range:NSMakeRange(minuteRange.location, minuteRange.length - 2)];
    
    return mTimeStr;
}


@end
