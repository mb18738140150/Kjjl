//
//  CategoryDetailTableViewCell.m
//  tiku
//
//  Created by aaa on 2017/5/16.
//  Copyright © 2017年 ytx. All rights reserved.
//

#import "CategoryDetailTableViewCell.h"
#import "UIImage+Blur.h"

#define YUFoldingSepertorLineWidth       0.3f
#define YUFoldingMargin                  8.0f
#define YUFoldingIconSize                16.0f

@implementation CategoryDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
                _titleLabel.textColor = kMainTextColor_100;
                _titleLabel.font = kMainFont;
    }
    return _titleLabel;
}
-(UILabel *)questionCountLabel
{
    if (!_questionCountLabel) {
        _questionCountLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _questionCountLabel.backgroundColor = [UIColor clearColor];
        _questionCountLabel.textAlignment = NSTextAlignmentLeft;
                _questionCountLabel.textColor = kMainTextColor_100;
                _questionCountLabel.font = [UIFont systemFontOfSize:12];
    }
    return _questionCountLabel;
}

-(UILabel *)learnPepleCountLB
{
    if (!_learnPepleCountLB) {
        _learnPepleCountLB = [[UILabel alloc]initWithFrame:CGRectZero];
        _learnPepleCountLB.backgroundColor = [UIColor clearColor];
        _learnPepleCountLB.textAlignment = NSTextAlignmentCenter;
        _learnPepleCountLB.textColor = kMainTextColor_100;
        _learnPepleCountLB.font = [UIFont systemFontOfSize:12];
    }
    return _learnPepleCountLB;
}

-(UIImageView *)learnImageView
{
    if (!_learnImageView) {
        _learnImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _learnImageView.backgroundColor = [UIColor clearColor];
    }
    return _learnImageView;
}

- (UILabel *)totalCountLB
{
    if (!_totalCountLB) {
        _totalCountLB = [[UILabel alloc]initWithFrame:CGRectZero];
        _totalCountLB.backgroundColor = [UIColor clearColor];
        _totalCountLB.textAlignment = NSTextAlignmentRight;
        _totalCountLB.textColor = kMainTextColor_100;
        _totalCountLB.font = [UIFont systemFontOfSize:12];
    }
    return _totalCountLB;
}

-(UIImageView *)showStateImageView
{
    if (!_showStateImageView) {
        _showStateImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _showStateImageView.backgroundColor = [UIColor clearColor];
        _showStateImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _showStateImageView;
}

- (UIButton *)shikanBtn
{
    if (!_shikanBtn) {
        _shikanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shikanBtn.backgroundColor = [UIColor whiteColor];
        [_shikanBtn setTitle:@"试学" forState:UIControlStateNormal];
        _shikanBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_shikanBtn setTitleColor:UIColorFromRGB(0xff740e) forState:UIControlStateNormal];
        _shikanBtn.layer.cornerRadius = 2;
        _shikanBtn.layer.masksToBounds = YES;
//        _shikanBtn.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
//        _shikanBtn.layer.borderWidth = 1;
    }
    return _shikanBtn;
}

- (UIView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]initWithFrame:CGRectZero];
        _bottomLineView.backgroundColor = UIColorFromRGB(0xdddddd);
    }
    return _bottomLineView;
}

- (void)resetisLast:(BOOL)islast withDicInfo:(NSDictionary *)infoDic
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self removeAllSubviews];
    self.backgroundColor = [UIColor whiteColor];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(25, 0, 0.7, self.hd_height)];
    self.lineView.backgroundColor = [UIColor blueColor];
    [self addSubview:self.lineView];
    if (islast) {
        self.lineView.hd_height = 10;
    }
    
    CGFloat labelWidth = [UIScreen mainScreen].bounds.size.width-45;
    CGFloat labelHeight = 15;
    CGFloat labelHeight1 = 12;
    CGFloat labelWidth1 = 80;
    CGRect arrowRect = CGRectMake(20, 10, 10, 10);
    CGRect titleRect = CGRectMake(CGRectGetMaxX(arrowRect) + YUFoldingMargin, YUFoldingMargin, labelWidth, labelHeight);
    CGRect questionCountRect = CGRectMake(titleRect.origin.x,  CGRectGetMaxY(titleRect) + YUFoldingMargin, labelWidth1, labelHeight1);
    CGRect learnPeopleRect = CGRectMake(CGRectGetMaxX(questionCountRect) + 5,  CGRectGetMaxY(titleRect) + YUFoldingMargin, 100, labelHeight1);
    CGRect learnImageRect = CGRectMake([UIScreen mainScreen].bounds.size.width - 10 - 25, (self.frame.size.height - 25) / 2, 25, 25);
    CGRect shikanBtnRect = CGRectMake([UIScreen mainScreen].bounds.size.width - 10 - 40, (self.frame.size.height - 25) / 2, 40, 25);
    
    [self.showStateImageView setFrame:arrowRect];
    [self.titleLabel setFrame:titleRect];
    [self.questionCountLabel setFrame:questionCountRect];
    [self.learnPepleCountLB setFrame:learnPeopleRect];
    [self.learnImageView setFrame:learnImageRect];
    [self.totalCountLB setFrame:CGRectMake(self.learnImageView.hd_x - 100, self.learnImageView.hd_y, 90, 25)];
    [self.bottomLineView setFrame:CGRectMake(0, 63, kScreenWidth, 0.5)];
    [self.shikanBtn setFrame:shikanBtnRect];
    self.shikanBtn.hidden = YES;
    
    self.learnImageView.userInteractionEnabled = YES;
    [self addSubview:self.showStateImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.questionCountLabel];
    [self addSubview:self.learnPepleCountLB];
    [self addSubview:self.learnImageView];
    [self addSubview:self.shikanBtn];
    [self addSubview:self.totalCountLB];
    
    [self.shikanBtn addTarget:self action:@selector(shikan) forControlEvents:UIControlEventTouchUpInside];
    
    self.showStateImageView.image = [UIImage imageNamed:@"tiku_point"];
    self.learnImageView.image = [UIImage imageNamed:@"tiku_text@2x"];
    if (self.cellType == CellType_video) {
        self.lineView.frame = CGRectMake(25, 0, 0.7, 50);
        if (islast) {
            self.lineView.hd_height = 10;
        }
        [self resetVideoCellWith:infoDic];
        return;
    }
    
    if (self.cellType == CellType_Simulate) {
        [self resetSimulateInfo:infoDic];
        return;
    }
    
    self.titleLabel.text = [infoDic objectForKey:kTestSectionName];
    NSString *str = [NSString stringWithFormat:@"%@/%@", [infoDic objectForKey:@"currentIndex"], [infoDic objectForKey:kTestSectionQuestionCount]];
    self.questionCountLabel.attributedText = [self getQuestionStrWith:str and:[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"currentIndex"]]];
    self.learnPepleCountLB.text = @"";
    self.totalCountLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:kTestSectionQuestionCount]];
    self.learnProcessView = [[ProcessView alloc]initWithFrame:CGRectMake(titleRect.origin.x, self.frame.size.height - 13, 230, 3)];
    self.learnProcessView.progress = [[infoDic objectForKey:@"currentIndex"] integerValue] * 1.0 / [[infoDic objectForKey:kTestSectionQuestionCount] integerValue];
    [self addSubview:self.learnProcessView];
    
    if (self.cellType != CellType_chapterTest) {
        if (islast) {
            self.lineView.hd_height = self.hd_height / 2;
        }else
        {
            [self addSubview:self.bottomLineView];
        }
        self.lineView.backgroundColor = UIColorFromRGB(0xdddddd);
        self.showStateImageView.hd_centerY = self.learnImageView.hd_centerY;
        self.titleLabel.hd_centerY = self.learnImageView.hd_centerY;
        self.titleLabel.hd_width = kScreenWidth - 38 - 125;
        self.totalCountLB.hidden = YES;
        self.questionCountLabel.frame = CGRectMake(kScreenWidth - 35 - 10 - 80, self.learnImageView.hd_centerY - 6, 80, 12);
        self.questionCountLabel.textAlignment = NSTextAlignmentCenter;
        self.learnProcessView.hidden = YES;
        self.backgroundColor = UIColorFromRGB(0xf9f9f9);
    }

    
}


- (void)resetSimulateInfo:(NSDictionary *)infoDic
{
    self.titleLabel.text = [infoDic objectForKey:kTestSimulateName];
    NSString *str = [NSString stringWithFormat:@"%@/%@", [infoDic objectForKey:@"currentIndex"], [infoDic objectForKey:kTestSimulateQuestionCount]];
    self.questionCountLabel.attributedText = [self getQuestionStrWith:str and:[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"currentIndex"]]];
    self.learnPepleCountLB.text = @"";
    self.totalCountLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:kTestSimulateQuestionCount]];
    
    self.lineView.hidden = YES;
    self.showStateImageView.image = [UIImage imageNamed:@"icon_misj"];
    self.showStateImageView.frame = CGRectMake(10, 10, 20, 20);
    self.showStateImageView.hd_centerY = self.learnImageView.hd_centerY;
    self.titleLabel.hd_centerY = self.learnImageView.hd_centerY;
    self.titleLabel.hd_width = kScreenWidth - 38 - 125;
    self.totalCountLB.hidden = YES;
    self.questionCountLabel.frame = CGRectMake(kScreenWidth - 35 - 10 - 80, self.learnImageView.hd_centerY - 6, 80, 12);
    self.questionCountLabel.textAlignment = NSTextAlignmentCenter;
}

- (NSMutableAttributedString *)getQuestionStrWith:(NSString *)str and:(NSString *)dStr
{
    NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSDictionary * attribute = @{NSForegroundColorAttributeName:UIColorFromRGB(0xff8400)};
    [mStr setAttributes:attribute range:NSMakeRange(0, dStr.length)];
    
    return mStr;
}

// 隐藏下载按钮
- (void)hideDownloadBtn
{
    self.learnImageView.hidden = YES;
}

- (void)shikanAction
{
    if (![[UserManager sharedManager] isUserLogin]) {
        [self lockVideo];
    }else
    {
        self.shikanBtn.hidden = NO;
    }
}

- (void)shikan
{
    if (self.shikanBlock) {
        self.shikanBlock();
    }
}

- (void)lockVideo
{
    self.learnImageView.hidden = NO;
    self.showStateImageView.image = [UIImage imageNamed:@"课程50-50"];
    self.lineView.hidden = YES;
    self.learnImageView.image = [UIImage imageNamed:@"密码"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.learnImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 10 - 15, 7.5, 15, 15);
    });
}

- (void)resetVideoCellWith:(NSDictionary *)infoDic
{
    
    if ([[infoDic objectForKey:@"isDownload"] intValue] == 0) {
        self.learnImageView.image = [UIImage imageGray:[UIImage imageNamed:@"下载(6)"] andRGBValue:121];
        self.downloadState = DownloadState_unDownload;
    }else
    {
        self.learnImageView.image = [UIImage imageNamed:@"下载(7)"];
        self.downloadState = DownloadState_downloading;
    }
    self.learnImageView.hidden = YES;
    CGRect learnImageRect = CGRectMake([UIScreen mainScreen].bounds.size.width - 10 - 25, 3, 25, 25);
    
    [self.learnImageView setFrame:learnImageRect];
    
    self.lineView.hidden = YES;
    self.showStateImageView.image = [UIImage imageNamed:@"课程50-50"];
    self.titleLabel.text = [infoDic objectForKey:kVideoName];
    self.questionCountLabel.hidden = YES;
    self.learnPepleCountLB.hidden = YES;
    self.totalCountLB.hidden = YES;
    [self.bottomLineView setFrame:CGRectMake(0, 49, kScreenWidth, 1)];
    
    self.showStateImageView.frame = CGRectMake(17.5, 7.5, 15, 15);
    self.learnImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 10 - 25, (self.frame.size.height - 25) / 2, 25, 25);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downloadAction)];
    [self.learnImageView addGestureRecognizer:tap];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)downloadAction
{
    if ([self.learnImageView.image isEqual: [UIImage imageNamed:@"密码"]]) {
        return;
    }
    
    if (self.downloadBlock) {
        self.downloadBlock(self.downloadState);
    }
}

@end
