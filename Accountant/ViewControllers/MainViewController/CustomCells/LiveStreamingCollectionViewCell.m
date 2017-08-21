//
//  LiveStreamingCollectionViewCell.m
//  Accountant
//
//  Created by aaa on 2017/6/15.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "LiveStreamingCollectionViewCell.h"

@implementation LiveStreamingCollectionViewCell

- (void)resetInfoWith:(NSDictionary *)infoDic
{
    self.backgroundColor = [UIColor whiteColor];
    if (!self.pointLabel) {
        self.pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 8, 8)];
        self.pointLabel.backgroundColor = [UIColor blueColor];
        self.pointLabel.layer.cornerRadius = self.pointLabel.hd_height / 2;
        self.pointLabel.layer.masksToBounds = YES;
        [self addSubview:self.pointLabel];
        
//        NSString *str = [[infoDic objectForKey:kLivingTime] substringWithRange:NSMakeRange(5, [[infoDic objectForKey:kLivingTime] length] - 3 - 5)];
        
        NSString *str = [self getTimeStr:[infoDic objectForKey:kLivingTime]];
        
        CGSize timeSize = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        
        self.timeLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.pointLabel.frame) + 3, 0, timeSize.width, 12)];
        self.timeLB.textColor = [UIColor blueColor];
        self.timeLB.text = str;
        self.timeLB.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.timeLB];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.timeLB.frame) + 5, 6, self.frame.size.width - 8 - 2 - self.timeLB.hd_width - 5 * 2, 1)];
        self.lineView.backgroundColor = [UIColor blueColor];
        [self addSubview:self.lineView];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, self.frame.size.width - 15, 75)];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[infoDic objectForKey:kCourseCover]] placeholderImage:[UIImage imageNamed:@"shouye-考证1"]] ;
        [self addSubview:self.imageView];
        
        self.stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(self.imageView.frame) + 5, 40, 15)];
        self.stateLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        switch ([[infoDic objectForKey:kLivingState] intValue]) {
            case 0:
                self.stateLabel.text = @"未开始";
                break;
            case 1:
                self.stateLabel.text = @"直播中";
                break;
            case 2:
                self.stateLabel.text = @"已结束";
                break;
            case 3:
                self.stateLabel.text = @"未预约";
                break;
            case 4:
                self.stateLabel.text = @"已预约";
                break;
            default:
                break;
        }
        
        self.stateLabel.textColor = [UIColor whiteColor];
        self.stateLabel.textAlignment = 1;
        self.stateLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.stateLabel];
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.stateLabel.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(7.5, 7.5)];
        CAShapeLayer * layer = [[CAShapeLayer alloc] init];
        layer.frame = self.stateLabel.bounds;
        layer.path = bezierPath.CGPath;
        self.stateLabel.layer.mask = layer;
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame) - 20, self.imageView.hd_width, 20)];
        self.timeLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.font = kMainFont;
        self.timeLabel.textAlignment = 1;
        self.timeLabel.text = [self getTimeStr1:[infoDic objectForKey:kLivingTime]];
//        [self addSubview:self.timeLabel];
        
        self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 5, self.imageView.frame.size.width, 33)];
        self.titleLB.text = [infoDic objectForKey:kCourseName];
        self.titleLB.textColor = kCommonMainTextColor_100;
        self.titleLB.font = [UIFont systemFontOfSize:12];
        self.titleLB.numberOfLines = 0;
        [self addSubview:self.titleLB];
        
        self.countLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLB.frame) + 5, self.imageView.frame.size.width, 12)];
        self.countLB.textColor = kCommonMainTextColor_150;
        self.countLB.text = [DateUtility getLivingDateShowString:[infoDic objectForKey:kLivingTime]];
        self.countLB.font = [UIFont systemFontOfSize:11];
        [self addSubview:self.countLB];
    }
}

- (NSString *)getTimeStr:(NSString *)str
{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    
    NSDate *date = [formatter dateFromString:str];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateCom = [calendar components:unit fromDate:date ];
    
    NSInteger month = dateCom.month;
    NSInteger day = dateCom.day;
    
    return [NSString stringWithFormat:@"%ld.%ld",(long)month,(long)day];
}
- (NSString *)getTimeStr1:(NSString *)str
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    
    NSDate * date = [NSDate date];
    date = [formatter dateFromString:str];
    
    NSDateFormatter * formatter1 = [[NSDateFormatter alloc]init];
    formatter1.dateFormat = @"HH:mm";
    
    NSString * dateStr = [formatter1 stringFromDate:date];
    
    return dateStr;
}
@end
