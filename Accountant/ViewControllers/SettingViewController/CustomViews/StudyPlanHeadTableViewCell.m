//
//  StudyPlanHeadTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/12/8.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "StudyPlanHeadTableViewCell.h"
#define SPACE (kScreenWidth - 53 * 3) / 6

@interface StudyPlanHeadTableViewCell ()

@property (nonatomic, strong)UILabel * infomationImageView;
@property (nonatomic, strong)UILabel * derectionImageView;
@property (nonatomic, strong)UILabel * projectImageView;

@end

@implementation StudyPlanHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetInfo
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView removeAllSubviews];
    
    self.infomationImageView = [[UILabel alloc]initWithFrame:CGRectMake(SPACE, 18, 53, 53)];
    self.infomationImageView.text = @"个人\n信息";
    self.infomationImageView.textColor = UIColorFromRGB(0x666666);
    self.infomationImageView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.infomationImageView.numberOfLines = 0;
    self.infomationImageView.textAlignment = NSTextAlignmentCenter;
    self.infomationImageView.font = kMainFont;
    self.infomationImageView.layer.cornerRadius = self.infomationImageView.hd_height / 2;
    self.infomationImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.infomationImageView];

    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.infomationImageView.frame), self.infomationImageView.hd_centerY, SPACE * 2, 1)];
    lineView1.backgroundColor = UIColorFromRGB(0xcccccc);
    [self.contentView addSubview:lineView1];
    
    self.derectionImageView = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView1.frame), 18, 53, 53)];
    self.derectionImageView.text = @"发展\n方向";
    self.derectionImageView.textColor = UIColorFromRGB(0x666666);
    self.derectionImageView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.derectionImageView.numberOfLines = 0;
    self.derectionImageView.textAlignment = NSTextAlignmentCenter;
    self.derectionImageView.font = kMainFont;
    self.derectionImageView.layer.cornerRadius = self.infomationImageView.hd_height / 2;
    self.derectionImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.derectionImageView];
    
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.derectionImageView.frame), self.infomationImageView.hd_centerY, SPACE * 2, 1)];
    lineView2.backgroundColor = UIColorFromRGB(0xcccccc);
    [self.contentView addSubview:lineView2];
    
    self.projectImageView = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView2.frame), 18, 53, 53)];
    self.projectImageView.text = @"定制\n方案";
    self.projectImageView.textColor = UIColorFromRGB(0x666666);
    self.projectImageView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.projectImageView.numberOfLines = 0;
    self.projectImageView.textAlignment = NSTextAlignmentCenter;
    self.projectImageView.font = kMainFont;
    self.projectImageView.layer.cornerRadius = self.infomationImageView.hd_height / 2;
    self.projectImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.projectImageView];
    
    
    switch (self.progress) {
        case StudyPlanHead_infomation:
        {
            self.infomationImageView.backgroundColor = UIColorFromRGB(0x1c71fa);
            self.infomationImageView.textColor = [UIColor whiteColor];
        }
            break;
        case StudyPlanHead_derection:
        {
            self.derectionImageView.backgroundColor = UIColorFromRGB(0x1c71fa);
            self.derectionImageView.textColor = [UIColor whiteColor];
        }
            break;
        case StudyPlanHead_project:
        {
            self.projectImageView.backgroundColor = UIColorFromRGB(0x1c71fa);
            self.projectImageView.textColor = [UIColor whiteColor];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
