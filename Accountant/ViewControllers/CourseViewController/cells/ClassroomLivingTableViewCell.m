//
//  ClassroomLivingTableViewCell.m
//  tiku
//
//  Created by aaa on 2017/5/12.
//  Copyright © 2017年 ytx. All rights reserved.
//

#import "ClassroomLivingTableViewCell.h"

@implementation ClassroomLivingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetWithDic:(NSDictionary *)infoDic
{
    self.livingIconImageView.layer.cornerRadius = self.livingIconImageView.hd_height / 2;
    self.livingIconImageView.layer.masksToBounds = YES;
    
    [self.livingIconImageView sd_setImageWithURL:[NSURL URLWithString:[infoDic objectForKey:kCourseCover]] placeholderImage:[UIImage imageNamed:@"course_pic2.png"]];
    self.livingTitleleLabel.text = [infoDic objectForKey:kCourseName];
    self.livingTeacherNameLB.text = [infoDic objectForKey:kCourseTeacherName];
    self.timeLB.text = [infoDic objectForKey:kLivingTime];
    
    self.stateBT.backgroundColor = kCommonMainColor;
    
    switch ([[infoDic objectForKey:kLivingState] intValue]) {
        case 0:
            [self.stateBT setTitle:@"未开始" forState:UIControlStateNormal] ;
            self.stateBT.backgroundColor = UIColorFromRGB(0x1017ba);
            break;
        case 1:
            [self.stateBT setTitle:@"直播中" forState:UIControlStateNormal];
            break;
        case 2:
            [self.stateBT setTitle:@"已结束" forState:UIControlStateNormal];
            self.stateBT.backgroundColor = UIRGBColor(188, 188, 188);
            break;
        case 3:
            [self.stateBT setTitle:@"未预约" forState:UIControlStateNormal];
            self.stateBT.backgroundColor = UIColorFromRGB(0x1017ba);
            break;
        case 4:
            [self.stateBT setTitle:@"已预约" forState:UIControlStateNormal];
            self.stateBT.backgroundColor = UIRGBColor(242, 62, 51);
            break;
        default:
            break;
    }
    
    
}
@end
