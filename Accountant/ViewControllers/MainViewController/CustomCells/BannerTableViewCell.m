//
//  BannerTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "BannerTableViewCell.h"
#import "UIMacro.h"
#import "MainViewMacro.h"
#import "SDCycleScrollView.h"

@interface BannerTableViewCell ()

@property (nonatomic,strong) SDCycleScrollView          *bannerScrollView;

@property (nonatomic, strong)UIView * backView;
@property (nonatomic, strong)UIImageView * titleImageView;
@property (nonatomic, strong)UILabel * detailsLB;

@end

@implementation BannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)resetSubviews
{
    [self.backView removeFromSuperview];
    [self.titleImageView removeFromSuperview];
    [self.detailsLB removeFromSuperview];
    [self.bannerScrollView removeFromSuperview];
    self.bannerScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 2 * kCellHeightOfCategoryView + 30 + 30) imageNamesGroup:self.bannerImgUrlArray];
    self.bannerScrollView.autoScrollTimeInterval = 10;
    [self addSubview:self.bannerScrollView];
    
    self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 50)];
//    [self addSubview:self.backView];
    self.backView.backgroundColor = [UIColor whiteColor];
    
    self.titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 100, 20)];
    self.titleImageView.image = [UIImage imageNamed:@"shouye-头条通知"];
//    [self.backView addSubview:self.titleImageView];
    self.titleImageView.userInteractionEnabled = YES;
    
    self.detailsLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.titleImageView.frame) + 20, 10, kScreenWidth - 15 - 100 - 20 - 20, 30)];
    self.detailsLB.text = @"会计教练旗下APP考必备已经上线啦";
    self.detailsLB.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    self.detailsLB.font = [UIFont systemFontOfSize:12];
//    [self.backView addSubview:self.detailsLB];
    
}

- (void)setupView
{
    self.bannerScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 2 * kCellHeightOfCategoryView + 30 + 30) imageNamesGroup:self.bannerImgUrlArray];
    self.bannerScrollView.autoScrollTimeInterval = 10;
    [self addSubview:self.bannerScrollView];
}



@end
