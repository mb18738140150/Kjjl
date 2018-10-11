//
//  ClassroomLivingTableViewCell_IPAD.m
//  Accountant
//
//  Created by aaa on 2018/10/11.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "ClassroomLivingTableViewCell_IPAD.h"

@interface ClassroomLivingTableViewCell_IPAD ()

@property (nonatomic, assign)NSInteger      day;
@property (nonatomic, assign)NSInteger      hour;
@property (nonatomic, assign)NSInteger      minute;

@property (strong, nonatomic)  CountDown *countDown;

@end

@implementation ClassroomLivingTableViewCell_IPAD


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetWithDic:(NSDictionary *)infoDic
{
    [self.contentView removeAllSubviews];
    
    float cellWidth = self.hd_width;
    float cellHeight = self.hd_height;
    
    
    self.livingIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(cellHeight * 0.12, 20, cellWidth * 0.25, cellHeight * 0.76)];
    [self.contentView addSubview:self.livingIconImageView];
    
    self.livingTitleleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.livingIconImageView.frame) + 25, self.livingIconImageView.hd_y + self.livingIconImageView.hd_height / 12, cellWidth - CGRectGetMaxX(self.livingIconImageView.frame) - 25 - 100, self.livingIconImageView.hd_height / 6)];
    self.livingTitleleLabel.textColor = UIColorFromRGB(0x333333);
    [self.contentView addSubview:self.livingTitleleLabel];
    
    // 讲师
    self.teacherIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.livingIconImageView.frame) + 25, self.livingIconImageView.hd_y +self.livingIconImageView.hd_height * 0.458 , 12, 13)];
    self.teacherIconImageView.image = [UIImage imageNamed:@"mainLiving_teacher"];
    [self.contentView addSubview:self.teacherIconImageView];
    
    self.teachernameLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.teacherIconImageView.frame) + 5, self.livingIconImageView.hd_y +self.livingIconImageView.hd_height * 0.458 - 3, 65, self.livingIconImageView.hd_height / 6)];
    self.teachernameLB.font = kMainFont;
    self.teachernameLB.textColor = UIColorFromRGB(0x999999);
    [self.contentView addSubview:self.teachernameLB];
    
    self.livingStartTimeLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.teachernameLB.frame) + 10, self.teachernameLB.hd_y, 120, self.livingIconImageView.hd_height / 6)];
    self.livingStartTimeLB.font = kMainFont;
    self.livingStartTimeLB.textColor = UIColorFromRGB(0x999999);
    [self.contentView addSubview:self.livingStartTimeLB];
    
    // 时间
    self.livingStateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.teacherIconImageView.hd_x , self.livingIconImageView.hd_y +self.livingIconImageView.hd_height / 6 * 5 - 2, 12, 13)];
    [self.contentView addSubview:self.livingStateImageView];
    
    self.timeLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.livingStateImageView.frame) + 5, self.livingIconImageView.hd_y +self.livingIconImageView.hd_height / 6 * 5 - 5, 200, self.livingIconImageView.hd_height / 6)];
    self.timeLB.font = kMainFont;
    self.timeLB.textColor = [UIColor redColor];
    [self.contentView addSubview:self.timeLB];
    
    self.stateBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.stateBT.frame = CGRectMake(cellWidth - 100, cellHeight / 2 - 17, 80, 35);
    [self.contentView addSubview:self.stateBT];
    [self.stateBT addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(20, cellHeight - 1, cellWidth - 40, 1)];
    bottomView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.contentView addSubview:bottomView];
    
    self.countDown = nil;
    self.livingIconImageView.layer.cornerRadius = 1;
    self.livingIconImageView.layer.masksToBounds = YES;
    self.markView.layer.cornerRadius = self.markView.hd_height / 2;
    self.markView.layer.masksToBounds = YES;
    
    self.payTypeLB.layer.cornerRadius = 2;
    self.payTypeLB.layer.masksToBounds = YES;
    
    if (self.livingDetailVC) {
        
        self.bofangImageView.hidden = NO;
        self.bofangImageView.image = [UIImage imageNamed:@"icon_bofang"];
        self.teacherIconImageView.hidden = YES;
        self.teachernameLB.hidden = YES;
        
    }else
    {
        self.teacherIconImageView.hidden = NO;
        self.teachernameLB.hidden = NO;
        self.bofangImageView.hidden = YES;
    }
    
    [self.livingIconImageView sd_setImageWithURL:[NSURL URLWithString:[infoDic objectForKey:kCourseCover]] placeholderImage:[UIImage imageNamed:@"course_pic2.png"]];
    
    self.livingTitleleLabel.text = [infoDic objectForKey:kCourseSecondName];
    
    CGFloat width = [UIUtility getWidthWithText:[infoDic objectForKey:kCourseSecondName] font:kMainFont height:15];
    
    NSString * timeStr = [[[infoDic objectForKey:kLivingTime] componentsSeparatedByString:@"~"] objectAtIndex:0];
    
    self.livingStartTimeLB.text = [self getLivingTime:timeStr];
    
    self.timeLB.text = [self getTimeWith:timeStr];
    
    self.teachernameLB.text = [infoDic objectForKey:kCourseTeacherName];
    
    switch ([[infoDic objectForKey:kIsLivingCourseFree] intValue]) {
        case 0:
            self.payTypeLB.text = @"收费";
            self.payTypeLB.backgroundColor = UIRGBColor(249, 29, 29);
            break;
        case 1:
            self.payTypeLB.text = @"免费";
            self.payTypeLB.backgroundColor = UIRGBColor(42, 193, 74);
            break;
        default:
            break;
    }
    [self.shakeView removeFromSuperview];
    self.shakeView = [[ShakeView alloc]initWithFrame:self.livingStateImageView.frame];
    [self.contentView addSubview:self.shakeView];
    [self.contentView insertSubview:self.shakeView aboveSubview:self.livingStateImageView];
    self.shakeView.hidden = YES;
    
    
    switch ([[infoDic objectForKey:kLivingState] intValue]) {
        case 0:
            self.bofangImageView.image = [UIImage imageNamed:@"icon_suo"];
            self.livingStateImageView.image = [UIImage imageNamed:@"livingCourse_time"];
            [self.stateBT setTitle:@"预约" forState:UIControlStateNormal] ;
            self.stateBT.backgroundColor = UIColorFromRGB(0xff1d1c);
            self.stateBT.tag = 1000 + LivingPlayType_order;
            if (self.livingDetailVC) {
                self.livingStateImageView.image = [UIImage imageNamed:@"icon_time2"];
                self.timeLB.textColor = UIColorFromRGB(0xff1c1c);
            }
            
            break;
        case 1:
            self.bofangImageView.image = [UIImage imageNamed:@"icon_suo"];
            self.livingStateImageView.image = [UIImage imageNamed:@"livingCourse_time"];
            [self.stateBT setTitle:@"已预约" forState:UIControlStateNormal];
            self.stateBT.backgroundColor = UIColorFromRGB(0xff1d1c);
            self.stateBT.tag = 1000 + LivingPlayType_ordered;
            self.livingStateImageView.image = [UIImage imageNamed:@"livingCourse_time"];
            if (self.livingDetailVC) {
                self.livingStateImageView.image = [UIImage imageNamed:@"icon_time2"];
                self.timeLB.textColor = UIColorFromRGB(0xff1c1c);
            }
            break;
        case 2:
            [self.stateBT setTitle:@"听课" forState:UIControlStateNormal];
            self.markView.hidden = NO;
            self.livingLabel.hidden = NO;
            self.shakeView.hidden = NO;
            [self.shakeView prepareUIWithColor:UIColorFromRGB(0x00c754)];
            self.livingStateImageView.hidden = YES;
            self.timeLB.text = @"直播中";
            //            self.livingStateImageView.image = [UIImage imageNamed:@"livingCourse_组"];
            self.stateBT.tag = 1000 + LivingPlayType_living;
            if (self.livingDetailVC) {
                //                self.livingStateImageView.image = [UIImage imageNamed:@"icon_zbz"];
                self.timeLB.textColor = UIColorFromRGB(0x00c754);
            }
            break;
        case 3:
            [self.stateBT setTitle:@"回放" forState:UIControlStateNormal];
            self.stateBT.backgroundColor = UIColorFromRGB(0xff7f00);
            if ([[infoDic objectForKey:kPlayBackUrl] length] == 0) {
                [self.stateBT setTitle:@"上传中" forState:UIControlStateNormal];
            }
            self.timeLB.text = @"已结束";
            self.livingStateImageView.image = [UIImage imageNamed:@"livingCourse_back"];
            self.stateBT.tag = 1000 + LivingPlayType_videoBack;
            if (self.livingDetailVC) {
                self.livingStateImageView.image = [UIImage imageNamed:@"icon_yjs"];
                self.timeLB.textColor = UIColorFromRGB(0xff7e00);
            }
            break;
            
        default:
            break;
    }
    
    if ([[infoDic objectForKey:kLivingState] intValue] == 2 || [[infoDic objectForKey:kLivingState] intValue] == 3) {
        return;
    }
    
    self.countDown = nil;
    self.countDown = [[CountDown alloc] init];
    __weak __typeof(self) weakSelf= self;
    ///每分回调一次
    
    [self.countDown countDownWithPER_MINBlock:^{
        
        [weakSelf updateTimeInVisibleCells:infoDic];
    }];
}

- (void)updateTimeInVisibleCells:(NSDictionary *)infoDic
{
    
    if ([[infoDic objectForKey:kLivingState] intValue] == 2 || [[infoDic objectForKey:kLivingState] intValue] == 3) {
        return;
    }
    
    if (self.minute <= 0) {
        if (self.hour <= 0) {
            if (self.day <= 0) {
                self.countDown = nil;
                if (self.countDownFinishBlock) {
                    self.countDownFinishBlock();
                }
            }else
            {
                self.day--;
                self.hour = 23;
                self.minute = 59;
            }
        }else
        {
            self.hour--;
            self.minute = 59;
        }
    }else{
        self.minute--;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_day == 0 && _hour == 0 && _minute > 0 && _minute < 15) {
            self.timeLB.text = @"即将开始";
        }else
        {
            self.timeLB.text = [NSString stringWithFormat:@"%ld天%ld小时%ld分钟", (long)self.day, (long)self.hour,(long)self.minute];
        }
    });
}

- (void)playAction:(id)sender {
    
    UIButton * btn = (UIButton *)sender;
    if (self.LivingPlayBlock) {
        self.LivingPlayBlock(btn.tag - 1000);
    }
}

- (NSString *)getLivingTime:(NSString *)livingTime
{
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSDate *livingDate = [dateFomatter dateFromString:livingTime];
    
    NSDateFormatter *dateFomatter1 = [[NSDateFormatter alloc] init];
    dateFomatter1.dateFormat = @"MM-dd HH:mm";
    
    
    NSString * timeStr = [dateFomatter1 stringFromDate:livingDate];
    
    return timeStr;
}
- (NSString *)getTimeWith:(NSString *)timeStr
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
    
    NSString * timeString = [NSString stringWithFormat:@"%ld天%ld小时%ld分钟", (long)self.day, (long)self.hour,(long)self.minute];
    if (_day == 0 && _hour == 0 && _minute > 0 && _minute < 15) {
        timeString = @"即将开始";
    }
    return timeString;
}
@end
