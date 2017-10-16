//
//  LivingStateView.m
//  Accountant
//
//  Created by aaa on 2017/9/14.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "LivingStateView.h"

#define kSpace 5

@interface LivingStateView ()

@property (nonatomic, strong)UILabel        *courseNameLB;
@property (nonatomic, strong)UIImageView    *imageView;
@property (nonatomic, strong)UILabel        *courseTeacherLB;
@property (nonatomic, strong)UILabel        *timeLB;

@property (nonatomic, strong)NSTimer        *timer;
@property (nonatomic, assign)NSInteger      hour;
@property (nonatomic, assign)NSInteger      minute;

@property (nonatomic, assign)BOOL           isLogin;

@property (nonatomic, strong)UIButton       *loginBtn;

@end

@implementation LivingStateView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    
    self.backgroundColor = [UIColor blackColor];
    self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.imageView.image = [UIImage imageNamed:@"已结束"];
    [self addSubview:self.imageView];
    
    self.courseNameLB = [[UILabel alloc]initWithFrame:CGRectMake(kSpace, 60, kScreenWidth - kSpace * 2, 20)];
    self.courseNameLB.textColor = [UIColor whiteColor];
    self.courseNameLB.textAlignment = 1;
    [self addSubview:self.courseNameLB];
    
    self.courseTeacherLB = [[UILabel alloc]initWithFrame:CGRectMake(kSpace, CGRectGetMaxY(self.courseNameLB.frame) + 2 * kSpace, kScreenWidth - kSpace * 2, 20)];
    self.courseTeacherLB.textAlignment = 1;
    self.courseTeacherLB.textColor = [UIColor whiteColor];
    [self addSubview:self.courseTeacherLB];
    
    
    self.timeLB = [[UILabel alloc]initWithFrame:CGRectMake(kSpace, CGRectGetMaxY(self.courseTeacherLB.frame) + 2 * kSpace, kScreenWidth -2 * kSpace, 25)];
    self.timeLB.textColor = [UIColor whiteColor];
    self.timeLB.textAlignment = 1;
    [self addSubview:self.timeLB];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.frame = CGRectMake(kScreenWidth / 2 - 40, CGRectGetMaxY(self.timeLB.frame) + 10, 80, 30);
    self.loginBtn.layer.cornerRadius = 4;
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.backgroundColor = UIRGBColor(19, 32, 255);
    [self.loginBtn setTitle:@"请登录" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = kMainFont;
    [self.loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.loginBtn];
    
}

- (void)resetWithInfoDic:(NSDictionary *)infoDic andIsLogin:(BOOL)isLogin
{
    self.isLogin = isLogin;
    [self resetWithInfoDic:infoDic];
}

- (void)resetWithInfoDic:(NSDictionary *)infoDic
{
    self.courseNameLB.text = [infoDic objectForKey:kCourseSecondName];
    self.courseTeacherLB.text = [infoDic objectForKey:kCourseTeacherName];
    self.timeLB.attributedText = [self getTimeWith:[[[infoDic objectForKey:kLivingTime] componentsSeparatedByString:@"~"] objectAtIndex:0]];
}

- (void)setStateWith:(LivingState)livingState
{
    self.isLogin = [[UserManager sharedManager] isUserLogin];
    if (!self.isLogin) {
        self.loginBtn.hidden = NO;
    }else
    {
        self.loginBtn.hidden = YES;
    }
    
    if (livingState == LivingState_noStart) {
        self.imageView.hidden = YES;
        self.courseTeacherLB.hidden = NO;
        self.courseNameLB.hidden = NO;
        self.timeLB.hidden = NO;
        [self startTimeCountDown];
    }else if (livingState == LivingState_end){
        self.imageView.hidden = YES;
        self.courseTeacherLB.hidden = NO;
        self.courseNameLB.hidden = NO;
        self.timeLB.hidden = YES;
    }
}

- (void)loginClick
{
    if (self.loginClickBlock) {
        self.loginClickBlock();
    }
}

- (void)startTimeCountDown
{
    __weak typeof(self)weakSelf = self;
    self.timer = [NSTimer timerWithTimeInterval:60 repeats:YES block:^(NSTimer * _Nonnull timer) {
        weakSelf.minute--;
        if (weakSelf.minute<0) {
            weakSelf.hour--;
            if (weakSelf.hour <0) {
                weakSelf.hour = 0;
                weakSelf.minute = 0;
                [weakSelf.timer invalidate];
                weakSelf.timer = nil;
            }else
            {
                weakSelf.minute = 59;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.timeLB.attributedText = [weakSelf getTimeStrWithHoour:weakSelf.hour andMinute:weakSelf.minute];
        });
        
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerInvalidate
{
    [self.timer invalidate];
    self.timer = nil;
}

- (NSAttributedString *)getTimeWith:(NSString *)timeStr
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
    
    self.hour = dateCom.month * 30 * 24  + dateCom.day * 24  + dateCom.hour;
    
    self.minute = dateCom.minute;
    
    if (_hour <= 0) {
        _hour = 0;
    }
    _minute--;
    if (_minute <= 0) {
        _minute = 0;
    }
    
    return [self getTimeStrWithHoour:_hour andMinute:_minute];
}

- (NSAttributedString *)getTimeStrWithHoour:(NSInteger)hour andMinute:(NSInteger)minute
{
    NSString * timeString = [NSString stringWithFormat:@"距离开课还有:%ld小时%ld分钟", (long)hour,(long)minute];
    
    NSRange hourRange = [timeString rangeOfString:[NSString stringWithFormat:@"%ld小时", (long)hour]];
    NSRange minuteRange = [timeString rangeOfString:[NSString stringWithFormat:@"%ld分钟", (long)minute]];
    
    NSMutableAttributedString * mTimeStr = [[NSMutableAttributedString alloc]initWithString:timeString];
    
    NSDictionary * timeAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:25],NSForegroundColorAttributeName:[UIColor redColor]};
    [mTimeStr setAttributes:timeAttribute range:NSMakeRange(hourRange.location, hourRange.length - 2)];
    [mTimeStr setAttributes:timeAttribute range:NSMakeRange(minuteRange.location, minuteRange.length - 2)];
    
    return mTimeStr;
}

@end
