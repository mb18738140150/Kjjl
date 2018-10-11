//
//  QuestionTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/3/3.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "QuestionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CommonMacro.h"
#import "UIMacro.h"
#import "UIUtility.h"
#import "DateUtility.h"
#import "QuestionMacro.h"
#import "NotificaitonMacro.h"
#import "ReplyView.h"

@interface QuestionTableViewCell ()

@property (nonatomic,strong) UIImageView            *headerImageView;
@property (nonatomic,strong) UILabel                *questionContentLabel;
@property (nonatomic,strong) UILabel                *helpLabel;
@property (nonatomic,strong) UILabel                *timeLabel;
@property (nonatomic,strong) UILabel                *quizzerUserNameLabel;
@property (nonatomic,strong) UILabel                *seePeopleCountLabel;
@property (nonatomic,strong) NSDictionary           *cellInfoDic;
@property (nonatomic,strong) UIView                 *bottomLineView;

@property (nonatomic,strong) UIImageView            *imageView1;
@property (nonatomic,strong) UIImageView            *imageView2;
@property (nonatomic,strong) UIImageView            *imageView3;

@property (nonatomic, strong)UIButton *replyBountBT;
@property (nonatomic, strong)UIButton *lookVCountBT;

@property (nonatomic, strong)ReplyView *replyView;

@property (nonatomic, strong)UIView * bottomView;
@property (nonatomic, strong)UILabel *liveLB;
@property (nonatomic, strong)UIImageView *goImageView;

@end

@implementation QuestionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)removeAllContentViews
{
    [self.headerImageView removeFromSuperview];
    [self.questionContentLabel removeFromSuperview];
    [self.timeLabel removeFromSuperview];
    [self.seePeopleCountLabel removeFromSuperview];
    [self.quizzerUserNameLabel removeFromSuperview];
    [self.timeLabel removeFromSuperview];
    [self.bottomLineView removeFromSuperview];
    [self.helpLabel removeFromSuperview];
    
    [self.replyBountBT removeFromSuperview];
    [self.lookVCountBT removeFromSuperview];
    [self.replyView removeFromSuperview];
    [self.bottomView removeFromSuperview];
    
}

- (void)resetCellWithInfo:(NSDictionary *)dic
{
    [self.contentView removeAllSubviews];
    if (dic.allKeys.count == 0) {
        return;
    }
    self.cellInfoDic = dic;
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kHeightOfCellHeaderImage, kHeightOfCellHeaderImage)];
    if ([[self.cellInfoDic objectForKey:kQuestionQuizzerHeaderImageUrl] class] == [NSNull class] || [self.cellInfoDic objectForKey:kQuestionQuizzerHeaderImageUrl] == nil || [[self.cellInfoDic objectForKey:kQuestionQuizzerHeaderImageUrl] isEqualToString:@""]) {
        self.headerImageView.image = [UIImage imageNamed:@"stuhead"];
    }else{
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[self.cellInfoDic objectForKey:kQuestionQuizzerHeaderImageUrl]] placeholderImage:[UIImage imageNamed:@"140-140"]] ;
    }
    
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width/2;
    self.headerImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.headerImageView];
    
    
    NSString *showName;
    NSString *userName = [dic objectForKey:kQuestionQuizzerUserName];
    if ([userName class] == [NSNull class] || userName.length <= 4) {
        showName = @"****";
    }else{
        showName = [NSString stringWithFormat:@"%@****",[userName substringToIndex:userName.length-4]];
    }
    float nameLBwidth = [UIUtility getWidthWithText:showName font:kMainFont height:15];
    
    self.quizzerUserNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headerImageView.frame.origin.x + self.headerImageView.frame.size.width + 5, 10, nameLBwidth, 15)];
    self.quizzerUserNameLabel.text = showName;
    self.quizzerUserNameLabel.textColor = kCommonMainTextColor_50;
    self.quizzerUserNameLabel.font = kMainFont;
    [self.contentView addSubview:self.quizzerUserNameLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.quizzerUserNameLabel.hd_x, CGRectGetMaxY(self.quizzerUserNameLabel.frame) + 5, 200, 15)];
    self.timeLabel.text = [self.cellInfoDic objectForKey:kQuestionTime];
//    if (self.isCalculatedDate) {
//    }else{
//        self.timeLabel.text = [DateUtility getDateShowString:[dic objectForKey:kQuestionTime]];
//    }
    self.timeLabel.text = [dic objectForKey:@"questionTime"];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = kCommonMainTextColor_100;
    [self.contentView addSubview:self.timeLabel];
    
    UILabel * isHaveCommentLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    isHaveCommentLB.layer.cornerRadius = 1;
    isHaveCommentLB.layer.masksToBounds = YES;
    isHaveCommentLB.layer.borderWidth = 1;
    isHaveCommentLB.layer.borderColor = UIColorFromRGB(0x008aff).CGColor;
    isHaveCommentLB.textAlignment = NSTextAlignmentCenter;
    isHaveCommentLB.font = kMainFont;
    
    CGFloat height;
    CGFloat maxHeight = 80;
    UIFont *font = kMainFont;
    
    CGFloat contentHeight = [UIUtility getSpaceLabelHeght:[self.cellInfoDic objectForKey:kQuestionContent] font:font width:kScreenWidth - 20];
    
    if (IS_PAD) {
        self.headerImageView.frame = CGRectMake(20, 25, 50, 50);
        self.quizzerUserNameLabel.frame = CGRectMake(self.headerImageView.frame.origin.x + self.headerImageView.frame.size.width + 5, 35, nameLBwidth, 15);
        contentHeight = [UIUtility getSpaceLabelHeght:[self.cellInfoDic objectForKey:kQuestionContent] font:font width:(kScreenWidth - 195)];
        
        self.quizzerUserNameLabel.textColor = UIColorFromRGB(0xffa200);
        self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.quizzerUserNameLabel.frame) + 20, self.quizzerUserNameLabel.hd_y, 130, 15);
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        isHaveCommentLB.frame = CGRectMake(CGRectGetMaxX(self.timeLabel.frame) + 20, self.quizzerUserNameLabel.hd_y - 2.5, 50, 20);
        [self.contentView addSubview:isHaveCommentLB];
        if ([[dic objectForKey:kQuestionReplyCount] intValue] == 0) {
            isHaveCommentLB.layer.borderColor = UIColorFromRGB(0x008aff).CGColor;
            isHaveCommentLB.textColor = UIColorFromRGB(0x008aff);
            isHaveCommentLB.text = @"未回答";
        }else
        {
            isHaveCommentLB.layer.borderColor = UIColorFromRGB(0xff8400).CGColor;
            isHaveCommentLB.textColor = UIColorFromRGB(0xff8400);
            isHaveCommentLB.text = @"已回答";
        }
    }
    
    
    if (self.isShowFullContent) {
        height = contentHeight;
    }else{
        if (contentHeight > maxHeight) {
            height = 80;
        }else{
            height = contentHeight;
        }
    }
    
    self.questionContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.headerImageView.frame.origin.y + self.headerImageView.frame.size.height + 10, kScreenWidth - 20, height)];
    if (IS_PAD) {
        self.questionContentLabel.frame = CGRectMake(75, 60, kScreenWidth - 195, height);
    }
    self.questionContentLabel.attributedText = [UIUtility getSpaceLabelStr:[self.cellInfoDic objectForKey:kQuestionContent] withFont:font];
    if (self.isShowFullContent == YES) {
        self.questionContentLabel.numberOfLines = 10000;
    }else{
        self.questionContentLabel.numberOfLines = 4;
    }
    self.questionContentLabel.font = kMainFont;
    self.questionContentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.questionContentLabel.textColor = kCommonMainTextColor_50;
    [self.contentView addSubview:self.questionContentLabel];
    
//    self.seePeopleCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.questionContentLabel.frame.origin.y + self.questionContentLabel.frame.size.height + 10, kWidthOfCellSeeLabel, kheightOfCellSeeLabel)];
//    self.seePeopleCountLabel.text = [NSString stringWithFormat:@"%@ 人看过 · %@ 人回复",[dic objectForKey:kQuestionSeePeopleCount],[dic objectForKey:kQuestionReplyCount]];
//    self.seePeopleCountLabel.font = [UIFont systemFontOfSize:16];
//    self.seePeopleCountLabel.textColor = UIRGBColor(136, 157, 172);
//    self.seePeopleCountLabel.textAlignment = NSTextAlignmentLeft;
//    [self addSubview:self.seePeopleCountLabel];
    
    NSArray *imgs = [dic objectForKey:kQuestionImgStr];
    self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.questionContentLabel.frame) + 5, 40, 60)];
    self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(80, CGRectGetMaxY(self.questionContentLabel.frame) + 5, 40, 60)];
    self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(140, CGRectGetMaxY(self.questionContentLabel.frame) + 5, 40, 60)];
    if (imgs.count == 1) {
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:imgs[0]]];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1)];
        [self.imageView1 addGestureRecognizer:tap1];
        self.imageView1.userInteractionEnabled = YES;
        [self.contentView addSubview:self.imageView1];
    }
    if (imgs.count == 2) {
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:imgs[0]]];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1)];
        [self.imageView1 addGestureRecognizer:tap1];
        self.imageView1.userInteractionEnabled = YES;
        
        [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:imgs[1]]];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2)];
        [self.imageView2 addGestureRecognizer:tap2];
        self.imageView2.userInteractionEnabled = YES;
        
        [self.contentView addSubview:self.imageView1];
        [self.contentView addSubview:self.imageView2];
    }
    if (imgs.count == 3) {
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:imgs[0]]];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1)];
        [self.imageView1 addGestureRecognizer:tap1];
        self.imageView1.userInteractionEnabled = YES;
        
        [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:imgs[1]]];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2)];
        [self.imageView2 addGestureRecognizer:tap2];
        self.imageView2.userInteractionEnabled = YES;
        
        [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:imgs[2]]];
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap3)];
        [self.imageView3 addGestureRecognizer:tap3];
        self.imageView3.userInteractionEnabled = YES;
        
        [self.contentView addSubview:self.imageView1];
        [self.contentView addSubview:self.imageView2];
        [self.contentView addSubview:self.imageView3];
    }
    
    self.replyBountBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.replyBountBT.frame = CGRectMake(kScreenWidth - 100, CGRectGetMaxY(self.questionContentLabel.frame) + 10, 40, 20);
    [self.replyBountBT setImage:[UIImage imageNamed:@"评论(2)"] forState:UIControlStateNormal];
    [self.replyBountBT setTitle:[NSString stringWithFormat:@"%@", [dic objectForKey:kQuestionReplyCount]] forState:UIControlStateNormal];
    self.replyBountBT.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.replyBountBT setTitleColor:kCommonMainTextColor_100 forState:UIControlStateNormal];
    self.replyBountBT.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.contentView addSubview:self.replyBountBT];
    
    self.lookVCountBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lookVCountBT.frame = CGRectMake(kScreenWidth - 50, CGRectGetMaxY(self.questionContentLabel.frame) + 10, 40, 20);
    [self.lookVCountBT setImage:[UIImage imageNamed:@"浏览(1)@3x"] forState:UIControlStateNormal];
    [self.lookVCountBT setTitle:[NSString stringWithFormat:@"%@", [dic objectForKey:kQuestionSeePeopleCount]] forState:UIControlStateNormal];
    self.lookVCountBT.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.lookVCountBT setTitleColor:kCommonMainTextColor_100 forState:UIControlStateNormal];
    self.lookVCountBT.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.contentView addSubview:self.lookVCountBT];
    
    if (imgs.count > 0) {
        self.replyBountBT.frame = CGRectMake(kScreenWidth - 100, CGRectGetMaxY(self.imageView1.frame) + 10, 40, 20);
        self.lookVCountBT.frame = CGRectMake(kScreenWidth - 50, CGRectGetMaxY(self.imageView1.frame) + 10, 40, 20);
    }
    
    self.bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.replyBountBT.frame) + 8 ,kScreenWidth,2)];
    self.bottomLineView.backgroundColor = UIRGBColor(245, 245, 245);
    [self.contentView addSubview:self.bottomLineView];
    
    /*
     // 评论数大于0
     if ([[dic objectForKey:kQuestionReplyCount] intValue] > 0) {
     NSDictionary * replyDic = [[dic objectForKey:@"replyList"] firstObject];
     self.replyView = [[ReplyView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.replyBountBT.frame), kScreenWidth - 20, 100) tipPoint:CGPointMake(self.replyBountBT.hd_x + 6, CGRectGetMaxY(self.replyBountBT.frame) + 5)];
     [self.replyView resetInfo:replyDic];
     self.replyView.hd_height = self.replyView.height;
     [self addSubview:self.replyView];
     
     if ([[dic objectForKey:kQuestionReplyCount] intValue] > 1) {
     self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.replyView.frame), kScreenWidth, 50)];
     _bottomView.backgroundColor = [UIColor whiteColor];
     [self addSubview:_bottomView];
     
     self.liveLB = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 35, 15, 70, 20)];
     self.liveLB.text = @"更多回答";
     self.liveLB.font = kMainFont;
     self.liveLB.textColor = kCommonMainTextColor_100;
     self.liveLB.textAlignment = 1;
     self.liveLB.userInteractionEnabled = YES;
     [_bottomView addSubview:self.liveLB];
     
     self.goImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.liveLB.frame), 18, 15, 14)];
     self.goImageView.image = [UIImage imageNamed:@"shouye-trankle"];
     [_bottomView addSubview:self.goImageView];
     self.goImageView.userInteractionEnabled = YES;
     
     UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goLiveStreamingClick)];
     [_bottomView addGestureRecognizer:tap];
     
     self.bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_bottomView.frame),kScreenWidth,2)];
     self.bottomLineView.backgroundColor = kTableViewCellSeparatorColor;
     [self addSubview:self.bottomLineView];
     }else
     {
     self.bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.replyView.frame) + 8 ,kScreenWidth,2)];
     self.bottomLineView.backgroundColor = kTableViewCellSeparatorColor;
     [self addSubview:self.bottomLineView];
     }
     }else
     {
     self.bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.replyBountBT.frame) + 8 ,kScreenWidth,2)];
     self.bottomLineView.backgroundColor = kTableViewCellSeparatorColor;
     [self addSubview:self.bottomLineView];
     }

     */
}

- (void)goLiveStreamingClick
{
    if (self.MoreReplyBlock) {
        self.MoreReplyBlock();
    }
}

- (void)tap1
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfQuestionImageClick object:self.imageView1.image];
}

- (void)tap2
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfQuestionImageClick object:self.imageView2.image];
}

- (void)tap3
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfQuestionImageClick object:self.imageView3.image];
}

@end
