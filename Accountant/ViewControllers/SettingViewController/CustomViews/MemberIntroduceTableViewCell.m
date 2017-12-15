//
//  MemberIntroduceTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/11/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MemberIntroduceTableViewCell.h"
#import "BuyMemberSort.h"

@interface MemberIntroduceTableViewCell ()

@property (nonatomic, strong)UIButton * memberBtn;

@end


@implementation MemberIntroduceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    if (!self.memberBtn) {
        
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 350)];
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
        
        UIView * backLineView = [[UIView alloc]initWithFrame:CGRectMake(14, 17, kScreenWidth - 28, 295)];
        backLineView.backgroundColor = [UIColor whiteColor];
        backLineView.layer.borderColor = UIColorFromRGB(0xedf0f2).CGColor;
        backLineView.layer.borderWidth = 1;
        backView.userInteractionEnabled = YES;
        [backView addSubview:backLineView];
        
        UIImageView * memberImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 26, 98, 34)];
        memberImageView.image = [UIImage imageNamed:@"hybq"];
        [backView addSubview:memberImageView];
        
        UIImageView * crownImageView = [[UIImageView alloc]initWithFrame:CGRectMake(9, 9, 15, 15)];
        crownImageView.image = [UIImage imageNamed:@"hg"];
        [memberImageView addSubview:crownImageView];
        
        UILabel * memberLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(crownImageView.frame) + 4, 9, 60, 15)];
        memberLB.text = @"会员特权";
        memberLB.textColor = [UIColor whiteColor];
        memberLB.font = kMainFont;
        memberLB.textAlignment = 1;
        [memberImageView addSubview:memberLB];
        
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(6, 67, backLineView.hd_width - 12, 1)];
        line.backgroundColor = UIColorFromRGB(0xedf0f2);
        [backLineView addSubview:line];
        
        UILabel * kaitongMemberLB = [[UILabel alloc]initWithFrame:CGRectMake(backLineView.hd_width / 2 - 60, 59, 120, 15)];
        kaitongMemberLB.textAlignment = 1;
        kaitongMemberLB.textColor = kMainTextColor;
        kaitongMemberLB.backgroundColor = [UIColor whiteColor];
        kaitongMemberLB.font = kMainFont;
        kaitongMemberLB.text = @"开通会员更超值";
        [backLineView addSubview:kaitongMemberLB];
        
        UILabel * memberNumberLB = [[UILabel alloc]initWithFrame:CGRectMake(0 , CGRectGetMaxY(kaitongMemberLB.frame) + 10, backLineView.hd_width, 13)];
        memberNumberLB.text = @"(90%以上学员都选择购买会员)";
        memberNumberLB.font = kMainFont;
        memberNumberLB.textColor = UIColorFromRGB(0x999999);
        memberNumberLB.textAlignment = 1;
        [backLineView addSubview:memberNumberLB];
        
        BuyMemberSort * zhiyeView = [[BuyMemberSort alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(memberNumberLB.frame) + 26, backLineView.hd_width / 5, backLineView.hd_width / 5) andImage:[UIImage imageNamed:@"zygh"] title:@"职业规划"];
        [backLineView addSubview:zhiyeView];
        
        BuyMemberSort * quanzhanView = [[BuyMemberSort alloc]initWithFrame:CGRectMake(CGRectGetMaxX(zhiyeView.frame), CGRectGetMaxY(memberNumberLB.frame) + 26, backLineView.hd_width / 5, backLineView.hd_width / 5) andImage:[UIImage imageNamed:@"qbkc"] title:@"全站课程"];
        [backLineView addSubview:quanzhanView];
        
        BuyMemberSort * shixunView = [[BuyMemberSort alloc]initWithFrame:CGRectMake(CGRectGetMaxX(quanzhanView.frame), CGRectGetMaxY(memberNumberLB.frame) + 26, backLineView.hd_width / 5, backLineView.hd_width / 5) andImage:[UIImage imageNamed:@"ldsx"] title:@"六大实训"];
        [backLineView addSubview:shixunView];
        
        BuyMemberSort * dayiView = [[BuyMemberSort alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shixunView.frame), CGRectGetMaxY(memberNumberLB.frame) + 26, backLineView.hd_width / 5, backLineView.hd_width / 5) andImage:[UIImage imageNamed:@"dy"] title:@"答疑"];
        [backLineView addSubview:dayiView];
        
        BuyMemberSort * ziliaoView = [[BuyMemberSort alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dayiView.frame), CGRectGetMaxY(memberNumberLB.frame) + 26, backLineView.hd_width / 5, backLineView.hd_width / 5) andImage:[UIImage imageNamed:@"nbzl"] title:@"内部资料"];
        [backLineView addSubview:ziliaoView];
        
        
        self.memberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.memberBtn.frame = CGRectMake(kScreenWidth / 2 - 65, CGRectGetMaxY(ziliaoView.frame) + 39, 130, 36);
        self.memberBtn.backgroundColor = UIColorFromRGB(0xfc4246);
        [self.memberBtn setTitle:@"开通会员" forState:UIControlStateNormal];
        [self.memberBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.memberBtn.layer.cornerRadius = 3;
        self.memberBtn.layer.masksToBounds = YES;
        self.memberBtn.titleLabel.font = kMainFont;
        [backLineView addSubview:self.memberBtn];
        [self.memberBtn addTarget:self action:@selector(buyMemberAction) forControlEvents:UIControlEventTouchUpInside];
        if (self.noPayBtn) {
            self.memberBtn.hidden = YES;
            
            backLineView.hd_height = backLineView.hd_height - 70;
            backView.hd_height = backView.hd_height - 70;
        }
    }
    
}

- (void)buyMemberAction
{
    if (self.buyMemberBlock) {
        self.buyMemberBlock();
    }
}
/*
 
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
