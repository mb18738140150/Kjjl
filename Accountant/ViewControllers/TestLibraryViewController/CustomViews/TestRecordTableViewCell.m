//
//  TestRecordTableViewCell.m
//  Accountant
//
//  Created by aaa on 2018/1/19.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "TestRecordTableViewCell.h"

@implementation TestRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.noComplateLB.layer.cornerRadius = 2;
    self.noComplateLB.layer.masksToBounds = YES;
    self.noComplateLB.layer.borderWidth = 1;
    self.noComplateLB.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    
    self.clickBtn.layer.cornerRadius = 3;
    self.clickBtn.layer.masksToBounds = YES;
    self.clickBtn.layer.borderWidth = 1;
    self.clickBtn.layer.borderColor = UIColorFromRGB(0x1e7af8).CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetWithInfoDic:(NSDictionary *)infoDic
{
    self.infoDic = infoDic;
    if (self.isFirst) {
        self.lineView.hidden = YES;
    }
    if (self.isLast) {
        self.bottomLineView.hidden = YES;
    }
    if (self.isShowTime) {
        self.timeLB.hidden = NO;
        self.timeLB.text = [self getTimeStr:[infoDic objectForKey:@"time"]];
        self.pointImageView.hidden = NO;
    }else
    {
        self.timeLB.hidden = YES;
        self.pointImageView.hidden = YES;
    }
    
    switch ([[infoDic objectForKey:@"logType"] intValue]) {
        case 1:
            self.typeImageView.image = [UIImage imageNamed:@"icon_mo"];
            break;
        case 2:
            self.typeImageView.image = [UIImage imageNamed:@"icon_zhen"];
            break;
        case 10:
            self.typeImageView.image = [UIImage imageNamed:@"icon_mei"];
            break;
        case 4:
            self.typeImageView.image = [UIImage imageNamed:@"icon_zhang"];
            break;
            
        default:
            break;
    }
    
    self.titleLB.text = [infoDic objectForKey:@"name"];
    self.detailLB.text = [NSString stringWithFormat:@"完成%@/%@题 对%@题", [infoDic objectForKey:@"complateCount"],[infoDic objectForKey:@"questionCount"],[infoDic objectForKey:@"rightCount"]];
    
    if (self.isDailyPractice) {
        self.typeImageView.hidden = YES;
        self.detail_y.constant = 10;
        self.title_y.constant = -17;
        self.clickBtn_w.constant = 62;
        self.pointImageView.image = [UIImage imageNamed:@""];
        self.pointImageView.layer.cornerRadius = 3;
        self.pointImageView.layer.masksToBounds = YES;
        self.pointImageView.backgroundColor = UIColorFromRGB(0x1e7af8);
        if ([infoDic objectForKey:@"isComplate"] && [[infoDic objectForKey:@"isComplate"] intValue] == 0) {
            self.noComplateLB.hidden = NO;
            [self.clickBtn setTitle:@"开始做题" forState:UIControlStateNormal];
        }else
        {
            self.noComplateLB.hidden = YES;
            [self.clickBtn setTitle:@"重新做题" forState:UIControlStateNormal];
        }
    }
}

- (IBAction)clickBtnAction:(id)sender {
    
    if (self.lookBlock) {
        self.lookBlock(self.infoDic);
    }
}

- (NSString *)getTimeStr:(NSString *)timeStr
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate * data = [formatter dateFromString:timeStr];
    
    NSDateFormatter * nFor = [[NSDateFormatter alloc]init];
    nFor.dateFormat = @"yyyy年MM月dd日";
    
    NSString * nStr = [nFor stringFromDate:data];
    NSArray * timeArr = [nStr componentsSeparatedByString:@"年"];
    NSString * nTimeStr = [NSString stringWithFormat:@"%@\n%@年", timeArr[1],timeArr[0]];
    
    return nTimeStr;
}

@end
