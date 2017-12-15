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
        _learnPepleCountLB.textAlignment = NSTextAlignmentLeft;
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

- (UIView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]initWithFrame:CGRectZero];
        _bottomLineView.backgroundColor = kBackgroundGrayColor;
    }
    return _bottomLineView;
}

- (void)resetisLast:(BOOL)islast withDicInfo:(NSDictionary *)infoDic
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self removeAllSubviews];
    
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
    
    [self.showStateImageView setFrame:arrowRect];
    [self.titleLabel setFrame:titleRect];
    [self.questionCountLabel setFrame:questionCountRect];
    [self.learnPepleCountLB setFrame:learnPeopleRect];
    [self.learnImageView setFrame:learnImageRect];
    [self.totalCountLB setFrame:CGRectMake(self.learnImageView.hd_x - 100, self.learnImageView.hd_y, 90, 25)];
    [self.bottomLineView setFrame:CGRectMake(0, 63, kScreenWidth, 1)];
    
    self.learnImageView.userInteractionEnabled = YES;
    [self addSubview:self.showStateImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.questionCountLabel];
    [self addSubview:self.learnPepleCountLB];
    [self addSubview:self.learnImageView];
    [self addSubview:self.totalCountLB];
    
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
    
    self.titleLabel.text = [infoDic objectForKey:kTestSectionName];
    self.questionCountLabel.text = [NSString stringWithFormat:@"%@/%@", [infoDic objectForKey:@"currentIndex"], [infoDic objectForKey:kTestSectionQuestionCount]];
    self.learnPepleCountLB.text = @"";
    self.totalCountLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:kTestSectionQuestionCount]];
    self.learnProcessView = [[ProcessView alloc]initWithFrame:CGRectMake(titleRect.origin.x, self.frame.size.height - 13, 230, 5)];
    self.learnProcessView.progress = [[infoDic objectForKey:@"currentIndex"] integerValue] * 1.0 / [[infoDic objectForKey:kTestSectionQuestionCount] integerValue];
    [self addSubview:self.learnProcessView];
    
    if (self.cellType == CellType_myWrong) {
        [self addSubview:self.bottomLineView];
        [self resetWith:infoDic];
    }
}

// 隐藏下载按钮
- (void)hideDownloadBtn
{
    self.learnImageView.hidden = YES;
}

- (void)lockVideo
{
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
    
    CGRect learnImageRect = CGRectMake([UIScreen mainScreen].bounds.size.width - 10 - 25, 3, 25, 25);
    
    [self.learnImageView setFrame:learnImageRect];
    
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

- (void)resetWith:(NSDictionary *)infoDic
{
    self.lineView.hidden = YES;
    self.showStateImageView.frame = CGRectMake(15, 10, 20, 20);
    self.showStateImageView.image = [UIImage imageNamed:@"tiku_plus"];
    self.titleLabel.text = [infoDic objectForKey:kTestChapterName];
    self.questionCountLabel.text = [NSString stringWithFormat:@"%@/%@", [infoDic objectForKey:@"currentIndex"], [infoDic objectForKey:kTestChapterQuestionCount]];
    self.learnPepleCountLB.text = @"";
    self.learnImageView.image = [UIImage imageNamed:@"tiku_text@2x"];
    self.totalCountLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:kTestChapterQuestionCount]];
    
    self.learnProcessView.progress = [[infoDic objectForKey:@"currentIndex"] integerValue] * 1.0 / [[infoDic objectForKey:kTestChapterQuestionCount] integerValue];
    [self addSubview:self.learnProcessView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)downloadAction
{
    if (self.downloadBlock) {
        self.downloadBlock(self.downloadState);
    }
}

@end
