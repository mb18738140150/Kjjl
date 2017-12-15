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

@property (nonatomic, strong)UILabel                        *levelLB;

@property (nonatomic, strong)UIImageView * backImageView;

@property (nonatomic, strong)UIImageView *goImageView;

@end

@implementation UserInfoViewCell

- (void)resetCellWithInfo:(NSDictionary *)dic
{
    [self.backImageView removeFromSuperview];
    [self.headerImageView removeFromSuperview];
    [self.nickNameLabel removeFromSuperview];
    [self.userNameLabel removeFromSuperview];
    
    self.backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -40, kScreenWidth, 179)];
    self.backImageView.backgroundColor = UIRGBColor(25, 102, 249);
    [self addSubview:self.backImageView];
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 67, 60, 60)];
    [self.headerImageView setImageWithURL:[NSURL URLWithString:[dic objectForKey:kUserHeaderImageUrl]] placeholderImage:[UIImage imageNamed:@"stuhead"]];
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width/2;
    self.headerImageView.clipsToBounds = YES;
    [self addSubview:self.headerImageView];
    
    self.nickNameLabel = [[UILabel alloc] init];
    self.nickNameLabel.frame = CGRectMake(CGRectGetMaxX(self.headerImageView.frame) + 10, CGRectGetMinY(self.headerImageView.frame) + 10, kScreenWidth - 100, 20);
    self.nickNameLabel.text = [dic objectForKey:kUserNickName];
    
    self.nickNameLabel.textColor = [UIColor whiteColor];
    self.nickNameLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.nickNameLabel];
    
    
    self.levelLB = [[UILabel alloc] init];
    self.levelLB.frame = CGRectMake(CGRectGetMaxX(self.headerImageView.frame) + 10, CGRectGetMaxY(self.nickNameLabel.frame) + 10, kScreenWidth - 100, 15);
    NSString *showName;
    NSString *userName = [dic objectForKey:kUserName];
    if ([userName class] == [NSNull class] || userName.length <= 4) {
        showName = @"****";
    }else{
        showName = [NSString stringWithFormat:@"%@****",[userName substringToIndex:userName.length-4]];
    }
    self.levelLB.text = showName;
    
    self.levelLB.textColor = [UIColor whiteColor];
    self.levelLB.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.levelLB];
    
    self.goImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 27, self.headerImageView.hd_centerY - 6, 8, 12)];
    self.goImageView.image = [UIImage imageNamed:@"icon_fy1"];
    self.goImageView.userInteractionEnabled = YES;
    [self addSubview:self.goImageView];
    
//    switch ([[UserManager sharedManager] getUserLevel]) {
//        case 1:
//            self.levelLB.text = @"普通会员";
//            break;
//        case 2:
//            self.levelLB.text = @"试听会员";
//            break;
//        case 3:
//            self.levelLB.text = @"正式会员";
//            break;
//            
//        default:
//            break;
//    }
    
    self.userNameLabel = [[UILabel alloc] init];
    self.userNameLabel.frame = CGRectMake(kScreenWidth / 2 - 45, CGRectGetMaxY(self.headerImageView.frame) + 10, 90, 30);
//    self.userNameLabel.text = [dic objectForKey:kUserName];
    self.userNameLabel.text = @"修改资料";
    self.userNameLabel.font = kMainFont;
    self.userNameLabel.textColor = [UIColor whiteColor];
    self.userNameLabel.layer.cornerRadius = self.userNameLabel.hd_height / 2;
    self.userNameLabel.layer.masksToBounds = YES;
    self.userNameLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    self.userNameLabel.textAlignment = 1;
//    [self addSubview:self.userNameLabel];
    
}

@end
