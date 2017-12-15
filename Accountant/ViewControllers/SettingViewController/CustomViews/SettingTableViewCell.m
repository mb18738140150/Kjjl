//
//  SettingTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/6/26.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetMemberWithInfo:(NSDictionary *)infoDic andHaveNewActivty:(BOOL)haveActivity
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!haveActivity) {
        self.tipDetailLB.hidden = YES;
        self.tipImageView.hidden = YES;
    }else
    {
        self.tipDetailLB.hidden = NO;
        self.tipImageView.hidden = NO;
    }
    
    self.iconImageView.image = [UIImage imageNamed:[infoDic objectForKey:@"imageName"]];
    self.titleLB.text = [infoDic objectForKey:@"title"];
    self.tipDetailLB.text = [infoDic objectForKey:@"tip"];
    
}

- (void)resetcellWithInfo:(NSDictionary *)infoDic andHaveNewActivty:(BOOL)haveActivity
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.memberLevelBtn.hidden = YES;
    if (!haveActivity) {
        self.tipDetailLB.hidden = YES;
        self.tipImageView.hidden = YES;
    }else
    {
        self.tipDetailLB.hidden = NO;
        self.tipImageView.hidden = NO;
    }
    
    self.iconImageView.image = [UIImage imageNamed:[infoDic objectForKey:@"imageName"]];
    self.titleLB.text = [infoDic objectForKey:@"title"];
    self.tipDetailLB.text = [infoDic objectForKey:@"tip"];
}

- (IBAction)upgradeMemberLevelAction:(id)sender {
    if (self.upgradeMemberLevelBlock) {
        self.upgradeMemberLevelBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
