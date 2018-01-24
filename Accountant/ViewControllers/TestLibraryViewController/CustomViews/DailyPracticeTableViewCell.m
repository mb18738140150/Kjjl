//
//  DailyPracticeTableViewCell.m
//  Accountant
//
//  Created by aaa on 2018/1/20.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "DailyPracticeTableViewCell.h"

@implementation DailyPracticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.startBtn.layer.cornerRadius = 3;
    self.startBtn.layer.masksToBounds = YES;
    self.startBtn.layer.borderWidth = 1;
    self.startBtn.layer.borderColor = UIColorFromRGB(0x1c7bf6).CGColor;
}

- (void)resetWithInfoDic:(NSDictionary *)infoDic
{
    self.infoDic = infoDic;
    self.titleLB.text = [infoDic objectForKey:@"name"];
    self.detailLB.text = [NSString stringWithFormat:@"今日%@人参与练习", [infoDic objectForKey:@"peopleCount"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)startClick:(id)sender {
    if (self.PracticeBlock) {
        self.PracticeBlock(self.infoDic);
    }
}

@end
