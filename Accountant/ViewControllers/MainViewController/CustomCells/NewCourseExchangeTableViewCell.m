//
//  NewCourseExchangeTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/10/10.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "NewCourseExchangeTableViewCell.h"

#import "CourseraManager.h"

@interface NewCourseExchangeTableViewCell ()

@property (nonatomic, assign)int number;
@property (nonatomic, assign)BOOL exChange;
@property (nonatomic, assign)BOOL noTopLine;

@end

@implementation NewCourseExchangeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetMoreInfoWithNotTopLine
{
    self.noTopLine = YES;
    [self resetMoreInfo];
}

- (void)resetCell
{
    self.exChange = YES;
    [self resetMoreInfo];
}

- (void)resetMoreInfo
{
    [self.contentView removeAllSubviews];
    
    UIView * newCourseSectionFoot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kCellHeightOfCourseTitle)];
    newCourseSectionFoot.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:newCourseSectionFoot];
    
    if (!self.noTopLine) {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        lineView.backgroundColor = UIRGBColor(230, 230, 230);
        [newCourseSectionFoot addSubview:lineView];
    }
    
    UILabel * exchangeLB = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 60, 0, 60, kCellHeightOfCourseTitle)];
    if (self.exChange) {
        exchangeLB.text = @"换一批";
        exchangeLB.textColor = kCommonMainColor;
    }else
    {
        exchangeLB.text = @"本月更多";
        exchangeLB.textColor = kCommonMainTextColor_100;
    }
    exchangeLB.font = kMainFont;
    exchangeLB.textAlignment = NSTextAlignmentRight;
    exchangeLB.userInteractionEnabled = YES;
    [newCourseSectionFoot addSubview:exchangeLB];
    
    UIImageView * exchangeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth / 2 + 5, kCellHeightOfCourseTitle / 2 - 7.5, 14, 15)];
    if (self.exChange) {
        exchangeImageView.image = [UIImage imageNamed:@"main_newCourse_exchange"];
    }else if ([CourseraManager sharedManager].showMore)
    {
        exchangeImageView.frame = CGRectMake(kScreenWidth / 2 + 5, kCellHeightOfCourseTitle / 2 - 3.5, 12, 7);
        exchangeImageView.image = [UIImage imageNamed:@"形状-up"];
        exchangeLB.text = @"收起";
    }else
    {
        exchangeImageView.frame = CGRectMake(kScreenWidth / 2 + 5, kCellHeightOfCourseTitle / 2 - 3.5, 12, 7);
        exchangeImageView.image = [UIImage imageNamed:@"形状-down"];
        exchangeLB.text = @"本月更多";
    }
    exchangeImageView.userInteractionEnabled = YES;
    [newCourseSectionFoot addSubview:exchangeImageView];
    
    UITapGestureRecognizer *exchangeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exchangeNeCourse)];
    [newCourseSectionFoot addGestureRecognizer:exchangeTap];
}

- (void)exchangeNeCourse
{
    if (self.exChange) {
        if (self.ExchangeBlock) {
            [CourseraManager sharedManager].exchangeNumber++;
            if ([CourseraManager sharedManager].exchangeNumber > 2) {
                [CourseraManager sharedManager].exchangeNumber = 0;
            }
            self.ExchangeBlock([CourseraManager sharedManager].exchangeNumber);
        }
    }else
    {
        if (self.MoreLivingCourseBlock) {
            [CourseraManager sharedManager].showMore = ![CourseraManager sharedManager].showMore;
            self.MoreLivingCourseBlock([CourseraManager sharedManager].showMore);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
