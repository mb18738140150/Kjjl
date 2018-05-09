//
//  LivingCourseDetailCell.m
//  Accountant
//
//  Created by aaa on 2018/5/8.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "LivingCourseDetailCell.h"
#import "CourseraManager.h"

@implementation LivingCourseDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) resetWithInfoDic:(NSDictionary *)infoDic
{
    self.infoDic = infoDic;
    self.titleLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:kCourseName]];
    self.priceLB.text = [NSString stringWithFormat:@"￥%@", [infoDic objectForKey:kPrice]];
    self.sectionCountLB.text = [NSString stringWithFormat:@"共%d节课", [[[CourseraManager sharedManager]getLivingSectionDetailArray] count]];
    self.teacherLB.text = [NSString stringWithFormat:@"主讲:%@", [infoDic objectForKey:kCourseTeacherName]];
    NSDictionary * firstInfoDic = [[[CourseraManager sharedManager]getLivingSectionDetailArray] firstObject];
    NSDictionary * lastInfoDic = [[[CourseraManager sharedManager]getLivingSectionDetailArray] lastObject];
    NSString * startTime = [[[firstInfoDic objectForKey:kLivingTime] componentsSeparatedByString:@" "] firstObject];
    NSString * endTime = [[[lastInfoDic objectForKey:kLivingTime] componentsSeparatedByString:@" "] firstObject];
    
    self.timeLB.text = [NSString stringWithFormat:@"开课时间:%@~%@", startTime, endTime];
    
    self.payBtn.layer.cornerRadius = 3;
    self.payBtn.layer.masksToBounds = YES;
    
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        self.priceLB.hidden = NO;
        self.payBtn.hidden = NO;
    }else
    {
        self.priceLB.hidden = YES;
        self.payBtn.hidden = YES;
    }
}

- (IBAction)payAction:(id)sender {
    if (self.payBlock) {
        self.payBlock(self.infoDic);
    }
}

@end
