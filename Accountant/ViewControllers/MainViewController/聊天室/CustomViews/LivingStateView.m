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
@property (nonatomic, assign)NSInteger      day;
@property (nonatomic, assign)NSInteger      hour;
@property (nonatomic, assign)NSInteger      minute;

@property (nonatomic, assign)BOOL           isLogin;

@property (nonatomic, strong)UIButton       *loginBtn;

@property (nonatomic, assign)LivingState state;


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
    self.courseNameLB.font = kMainFont;
    self.courseNameLB.textAlignment = 1;
    [self addSubview:self.courseNameLB];
    
    self.courseTeacherLB = [[UILabel alloc]initWithFrame:CGRectMake(kSpace, CGRectGetMaxY(self.courseNameLB.frame) + 2 * kSpace, kScreenWidth - kSpace * 2, 20)];
    self.courseTeacherLB.textAlignment = 1;
    self.courseTeacherLB.font = kMainFont;
    self.courseTeacherLB.textColor = [UIColor whiteColor];
    [self addSubview:self.courseTeacherLB];
    
    self.timeLB = [[UILabel alloc]initWithFrame:CGRectMake(kSpace, CGRectGetMaxY(self.courseTeacherLB.frame) + 2 * kSpace, kScreenWidth -2 * kSpace, 25)];
    self.timeLB.textColor = [UIColor whiteColor];
    self.timeLB.font = kMainFont;
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
    
    UITextField * textf = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    textf.backgroundColor = kCommonMainTextColor_200;
    textf.keyboardType = UIKeyboardTypeNumberPad;
    textf.returnKeyType = UIReturnKeyDone;
    textf.placeholder = @"";
    textf.textColor = kCommonMainColor;
    textf.layer.cornerRadius = 4;
    textf.layer.masksToBounds = YES;
    textf.adjustsFontSizeToFitWidth = YES;
    
}

- (void)resetWithInfoDic:(NSDictionary *)infoDic andIsLogin:(BOOL)isLogin
{
    self.infoDic = infoDic;
    self.isLogin = isLogin;
    [self resetWithInfoDic:infoDic];
}

- (void)resetWithInfoDic:(NSDictionary *)infoDic
{
    self.courseNameLB.text = [infoDic objectForKey:kCourseSecondName];
    self.courseTeacherLB.text = [NSString stringWithFormat:@"讲师:%@", [infoDic objectForKey:kCourseTeacherName]];
    self.timeLB.attributedText = [self getTimeWith:[[[infoDic objectForKey:kLivingTime] componentsSeparatedByString:@"~"] objectAtIndex:0]];
}

- (void)setStateWith:(LivingState)livingState
{
    self.state = livingState;
    switch ([[self.infoDic objectForKey:kLivingState] intValue]) {
        case 0:
            self.state = LivingState_noStart;
            [self.loginBtn setTitle:@"预约" forState:UIControlStateNormal];
            break;
        case 1:
            self.state = LivingState_ordered;
            [self.loginBtn setTitle:@"已预约" forState:UIControlStateNormal];
            break;
        case 2:
            self.state = LivingState_living;
            [self.loginBtn setTitle:@"播放" forState:UIControlStateNormal];
            break;
        case 3:
        {
            if (livingState == LivingState_notJurisdiction) {
                self.state = LivingState_notJurisdiction;
                [self.loginBtn setTitle:@"咨询" forState:UIControlStateNormal];
            }else if (livingState == LivingState_end){
                
                [self.loginBtn setTitle:@"回放" forState:UIControlStateNormal];
                if ([[self.infoDic objectForKey:kPlayBackUrl] length] == 0) {
                    [self.loginBtn setTitle:@"上传中" forState:UIControlStateNormal];
                }
            }
        }
            break;
        
        default:
            break;
    }
    
    
    self.isLogin = [[UserManager sharedManager] isUserLogin];
    if (!self.isLogin) {
        self.state = LivingState_notLogin;
        [self.loginBtn setTitle:@"请登录" forState:UIControlStateNormal];
        self.imageView.hidden = YES;
        if (_hour == 0 && _minute == 0) {
            self.timeLB.text = @"已结束";
        }
        
    }
    
    if (livingState == LivingState_noStart) {
        self.imageView.hidden = YES;
        self.courseTeacherLB.hidden = NO;
        self.courseNameLB.hidden = NO;
        self.timeLB.hidden = NO;
        [self startTimeCountDown];
    }else if (livingState == LivingState_end || livingState == LivingState_notJurisdiction){
        self.imageView.hidden = YES;
        self.courseTeacherLB.hidden = NO;
        self.courseNameLB.hidden = NO;
        self.timeLB.hidden = YES;
    }
}

- (void)loginClick
{
    if ([[self.infoDic objectForKey:kPlayBackUrl] length] == 0) {
        
    }
    
    if (self.loginClickBlock) {
        self.loginClickBlock(self.state,self.infoDic);
    }
}

- (void)startTimeCountDown
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer timerWithTimeInterval:60 target:self selector:@selector(timeCountDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

- (void)timeCountDown
{
    __weak typeof(self)weakSelf = self;
    
    weakSelf.minute--;
    
    if (weakSelf.minute<0) {
        weakSelf.hour--;
        if (weakSelf.hour <0) {
            weakSelf.day--;
            if (weakSelf.day < 0) {
                weakSelf.day = 0;
                weakSelf.hour = 0;
                weakSelf.minute = 0;
                [weakSelf.timer invalidate];
                weakSelf.timer = nil;
            }else
            {
                weakSelf.hour = 23;
                weakSelf.minute = 59;
            }
        }else
        {
            weakSelf.minute = 59;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.timeLB.attributedText = [weakSelf getTimeStrWithday:weakSelf.day andHour:weakSelf.hour andMinute:weakSelf.minute];
    });
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
    
    self.day = dateCom.month * 30  + dateCom.day;
    self.hour = dateCom.hour;
    
    self.minute = dateCom.minute;
    if (_day <= 0) {
        _day = 0;
    }
    
    if (_hour <= 0) {
        _hour = 0;
    }
    _minute--;
    if (_minute <= 0) {
        _minute = 0;
    }
    
    return [self getTimeStrWithday:self.day andHour:_hour andMinute:_minute];
}

- (NSAttributedString *)getTimeStrWithday:(NSInteger)day andHour:(NSInteger)hour andMinute:(NSInteger)minute
{
    NSString * timeString = [NSString stringWithFormat:@"距离开课还有:%ld天%ld小时%ld分钟",(long)day, (long)hour,(long)minute];
    
    NSRange dayRange = [timeString rangeOfString:[NSString stringWithFormat:@"%ld天", (long)day]];
    NSRange hourRange = [timeString rangeOfString:[NSString stringWithFormat:@"%ld小时", (long)hour]];
    NSRange minuteRange = [timeString rangeOfString:[NSString stringWithFormat:@"%ld分钟", (long)minute]];
    
    NSMutableAttributedString * mTimeStr = [[NSMutableAttributedString alloc]initWithString:timeString];
    
    NSDictionary * timeAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:25],NSForegroundColorAttributeName:[UIColor redColor]};
    [mTimeStr setAttributes:timeAttribute range:NSMakeRange(dayRange.location, dayRange.length - 1)];
    [mTimeStr setAttributes:timeAttribute range:NSMakeRange(hourRange.location, hourRange.length - 2)];
    [mTimeStr setAttributes:timeAttribute range:NSMakeRange(minuteRange.location, minuteRange.length - 2)];
    
    return mTimeStr;
}

@end
