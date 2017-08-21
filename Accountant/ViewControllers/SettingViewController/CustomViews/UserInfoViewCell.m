//
//  UserInfoViewCell.m
//  Accountant
//
//  Created by aaa on 2017/3/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "UserInfoViewCell.h"
#import "CommonMacro.h"
#import "UIImageView+AFNetworking.h"

@interface UserInfoViewCell ()

@property (nonatomic,strong) UIImageView                    *headerImageView;

@property (nonatomic,strong) UILabel                        *nickNameLabel;
@property (nonatomic,strong) UILabel                        *userNameLabel;

@property (nonatomic, strong)UIImageView * backImageView;

@end

@implementation UserInfoViewCell

- (void)resetCellWithInfo:(NSDictionary *)dic
{
    [self.backImageView removeFromSuperview];
    [self.headerImageView removeFromSuperview];
    [self.nickNameLabel removeFromSuperview];
    [self.userNameLabel removeFromSuperview];
    
    
    self.backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 240)];
    self.backImageView.image = [UIImage imageNamed:@"main-bg"];
    [self addSubview:self.backImageView];
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 35, 80, 70, 70)];
    [self.headerImageView setImageWithURL:[NSURL URLWithString:[dic objectForKey:kUserHeaderImageUrl]] placeholderImage:[UIImage imageNamed:@"stuhead"]];
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width/2;
    self.headerImageView.clipsToBounds = YES;
    [self addSubview:self.headerImageView];
    
    self.nickNameLabel = [[UILabel alloc] init];
    self.nickNameLabel.frame = CGRectMake(0, CGRectGetMaxY(self.headerImageView.frame) + 15, kScreenWidth, 25);
    self.nickNameLabel.text = [dic objectForKey:kUserNickName];
    self.nickNameLabel.textAlignment = 1;
    self.nickNameLabel.textColor = [UIColor whiteColor];
    self.nickNameLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:self.nickNameLabel];
    
    self.userNameLabel = [[UILabel alloc] init];
    self.userNameLabel.frame = CGRectMake(kScreenWidth / 2 - 45, CGRectGetMaxY(self.nickNameLabel.frame) + 10, 90, 30);
//    self.userNameLabel.text = [dic objectForKey:kUserName];
    self.userNameLabel.text = @"我的资料";
    self.userNameLabel.font = kMainFont;
    self.userNameLabel.textColor = [UIColor whiteColor];
    self.userNameLabel.layer.cornerRadius = self.userNameLabel.hd_height / 2;
    self.userNameLabel.layer.masksToBounds = YES;
    self.userNameLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    self.userNameLabel.textAlignment = 1;
    [self addSubview:self.userNameLabel];
    
}

@end
