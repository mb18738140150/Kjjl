//
//  LivingSectionDetailTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/9/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "LivingSectionDetailTableViewCell.h"
#import "ShakeView.h"

@interface LivingSectionDetailTableViewCell ()

@property (nonatomic, strong)ShakeView * shakeView;
@property (nonatomic, strong)UIImageView * stateImageView;

@end

@implementation LivingSectionDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetInfoWithDic:(NSDictionary *)dicInfo
{
    [self.stateView removeAllSubviews];
    self.playBtn.tag = 1000;
    
    self.courseSectionNameLB.text = [self getDayTime:[dicInfo objectForKey:kLivingTime]];
    self.playTimeLB.text = [[[dicInfo objectForKey:kLivingTime] componentsSeparatedByString:@" "] objectAtIndex:1];
    self.courseSectionTime.text = [dicInfo objectForKey:kCourseSecondName];
    self.playBtn.enabled = YES;
    
    int state = [[dicInfo objectForKey:kLivingState] intValue];
    switch (state) {
        case 0:
        {
            self.stateImageView = [[UIImageView alloc]initWithFrame:self.stateView.bounds];
            [self.stateView addSubview:self.stateImageView];
            self.stateImageView.image = [UIImage imageNamed:@"livingState_order"];
            [self.playBtn setTitle:@"立即预约" forState:UIControlStateNormal];
            self.playBtn.tag = 1000 + PlayType_order;
            [self changeStateColorWith:kCommonMainColor];
        }
            break;
        case 1:
        {
            self.stateImageView = [[UIImageView alloc]initWithFrame:self.stateView.bounds];
            self.stateImageView.backgroundColor = kCommonMainTextColor_200;
            [self.stateView addSubview:self.stateImageView];
            self.stateImageView.image = [UIImage imageNamed:@"livingState_orderComplate"];
            [self.playBtn setTitle:@"已预约" forState:UIControlStateNormal];
            self.playBtn.enabled = NO;
            [self changeStateColorWith:kCommonMainTextColor_200];
        }
            break;
        case 2:
        {
            self.shakeView = [[ShakeView alloc]initWithFrame:self.stateView.bounds];
            [self.shakeView prepareUIWithColor:[UIColor whiteColor]];
            [self.stateView addSubview:self.shakeView];
            [self.playBtn setTitle:@"正在直播" forState:UIControlStateNormal];
            self.playBtn.tag = 1000 + PlayType_living;
            [self changeStateColorWith:kCommonMainColor];
        }
            break;
        case 3:
        {
            self.stateImageView = [[UIImageView alloc]initWithFrame:self.stateView.bounds];
            [self.stateView addSubview:self.stateImageView];
            self.stateImageView.image = [UIImage imageNamed:@"livingState_back"];
            [self.playBtn setTitle:@"查看回放" forState:UIControlStateNormal];
            self.playBtn.tag = 1000 + PlayType_videoBack;
            [self changeStateColorWith:UIRGBColor(250, 150, 25)];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)changeStateColorWith:(UIColor *)color
{
    self.stateBackView.backgroundColor = color;
    self.playBtn.backgroundColor = color;
    self.stateView.backgroundColor = color;
}

- (IBAction)playAction:(id)sender {
    
    UIButton * btn = (UIButton *)sender;
    if (self.PlayBlock) {
        self.PlayBlock(btn.tag - 1000);
    }
    
}

- (NSString *)getDayTime:(NSString *)time
{
    NSString * timeStr = [[time componentsSeparatedByString:@" "] objectAtIndex:0];
    timeStr = [timeStr substringFromIndex:5];
    return timeStr;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
