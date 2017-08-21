//
//  QuestionReplyTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/3/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "QuestionReplyTableViewCell.h"
#import "UIMacro.h"
#import "CommonMacro.h"
#import "QuestionMacro.h"
#import "UIImageView+WebCache.h"
#import "UIUtility.h"

@interface QuestionReplyTableViewCell ()

@property (nonatomic,strong) UIImageView            *headerImageView;
@property (nonatomic,strong) UILabel                *questionContentLabel;
@property (nonatomic,strong) UILabel                *timeLabel;
@property (nonatomic,strong) UILabel                *quizzerUserNameLabel;
@property (nonatomic, strong)UILabel                *remarkLB;
@property (nonatomic,strong) NSDictionary           *cellInfoDic;

@property (nonatomic,strong) UIView                 *bottomLineView;

@property (nonatomic, assign)BOOL isLivingDetail;

@end

@implementation QuestionReplyTableViewCell

- (void)removeAllContentViews
{
    [self.headerImageView removeFromSuperview];
    [self.questionContentLabel removeFromSuperview];
    [self.timeLabel removeFromSuperview];
    [self.quizzerUserNameLabel removeFromSuperview];
    [self.timeLabel removeFromSuperview];
    [self.remarkLB removeFromSuperview];
}

- (void)resetLivingDetailCellWithInfoDic:(NSDictionary *)infoDic
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:[infoDic objectForKey:kTeacherPortraitUrl] forKey:kReplierHeaderImage];
    [dic setObject:[infoDic objectForKey:kTeacherDetail] forKey:kReplyContent];
    [dic setObject:[infoDic objectForKey:kCourseTeacherName] forKey:kReplierUserName];
    [dic setObject:@"" forKey:kReplyTime];
    self.isLivingDetail = YES;
    [self resetCellWithInfo:dic];
}

- (void)resetCellWithInfo:(NSDictionary *)dic
{
    NSLog(@"%@", [dic description]);
    
    [self removeAllContentViews];
    if (dic.allKeys.count == 0) {
        return;
    }
    self.cellInfoDic = dic;
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, kHeightOfCellHeaderImage, kHeightOfCellHeaderImage)];
    self.headerImageView.layer.cornerRadius = self.headerImageView.hd_height / 2;
    self.headerImageView.layer.masksToBounds = YES;
    if ([[self.cellInfoDic objectForKey:kReplierHeaderImage] class] == [NSNull class] || [self.cellInfoDic objectForKey:kReplierHeaderImage] == nil || [[self.cellInfoDic objectForKey:kReplierHeaderImage] isEqualToString:@""]) {
        self.headerImageView.image = [UIImage imageNamed:@"stuhead"];
    }else{
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[self.cellInfoDic objectForKey:kReplierHeaderImage]]];
    }
    [self addSubview:self.headerImageView];
    
    self.quizzerUserNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headerImageView.frame.origin.x + self.headerImageView.frame.size.width + 10, 20, 70, 15)];
    NSString *showName;
    NSString *userName = [dic objectForKey:kReplierUserName];
    if ([userName class] == [NSNull class]) {
        showName = @"老师";
    }else{
        showName = userName;
    }
    self.quizzerUserNameLabel.text = showName;
    self.quizzerUserNameLabel.textColor = kCommonMainTextColor_50;
    self.quizzerUserNameLabel.font = kMainFont;
    [self addSubview:self.quizzerUserNameLabel];
    
    self.remarkLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.quizzerUserNameLabel.frame) + 5, self.quizzerUserNameLabel.hd_y, 35, 13)];
    self.remarkLB.textColor = kCommonMainTextColor_100;
    self.remarkLB.textAlignment = 1;
    self.remarkLB.font = [UIFont systemFontOfSize:12];
    self.remarkLB.layer.borderWidth = 1;
    self.remarkLB.layer.borderColor = kCommonMainTextColor_150.CGColor;
    self.remarkLB.text = @"老师";
    [self addSubview:self.remarkLB];
    
    CGFloat nameidth = [self.quizzerUserNameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
    self.quizzerUserNameLabel.hd_width = nameidth;
    self.remarkLB.hd_x = CGRectGetMaxX(self.quizzerUserNameLabel.frame) + 5;
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.quizzerUserNameLabel.hd_x, CGRectGetMaxY(self.quizzerUserNameLabel.frame) + 5, 200, 15)];
    self.timeLabel.text = [self.cellInfoDic objectForKey:kReplyTime];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = kCommonMainTextColor_100;
    [self addSubview:self.timeLabel];
    
    if (self.isLivingDetail) {
        self.timeLabel.hidden = YES;
        self.remarkLB.frame = CGRectMake(self.quizzerUserNameLabel.hd_x, CGRectGetMaxY(self.quizzerUserNameLabel.frame) + 5, 60, 15);
        self.remarkLB.text = @"主讲老师";
        self.remarkLB.textColor = kCommonMainColor;
        self.remarkLB.layer.borderColor = kCommonMainColor.CGColor;
        
    }
    
    CGFloat height;
    UIFont *font = kMainFont;
    CGFloat contentHeight = [UIUtility getSpaceLabelHeght:[self.cellInfoDic objectForKey:kReplyContent] font:font width:kScreenWidth - 40];
    height = contentHeight;
    
    self.questionContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.headerImageView.frame.origin.y + self.headerImageView.frame.size.height + 10, kScreenWidth - 40, height)];
    self.questionContentLabel.attributedText = [UIUtility getSpaceLabelStr:[self.cellInfoDic objectForKey:kReplyContent] withFont:font];
    self.questionContentLabel.numberOfLines = 10000;
    self.questionContentLabel.font = kMainFont;
    self.questionContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.questionContentLabel.textColor = kMainTextColor_100;
    [self addSubview:self.questionContentLabel];
    
    
    self.bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.questionContentLabel.frame.origin.y + self.questionContentLabel.frame.size.height + 9 ,kScreenWidth,1)];
    self.bottomLineView.backgroundColor = kTableViewCellSeparatorColor;
    if (!self.isLivingDetail) {
        [self addSubview:self.bottomLineView];
    }
    
}

@end
