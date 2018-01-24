//
//  VideoStateView.m
//  Accountant
//
//  Created by aaa on 2018/1/16.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "VideoStateView.h"

@interface VideoStateView ()

@property (nonatomic, strong)UIImageView    *imageView;
@property (nonatomic, strong)UIButton       *loginBtn;
@property (nonatomic, strong)UIButton       *backBtn;
@property (nonatomic, assign)VideoState state;

@end

@implementation VideoStateView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.backgroundColor = [UIColor blackColor];
    self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.imageView.image = [UIImage imageNamed:@"已结束"];
    [self addSubview:self.imageView];
    

    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, 30, 30, 30);
    [self.backBtn setImage:[UIImage imageNamed:@"zx-video-banner-back"] forState:UIControlStateNormal];
    [self addSubview:self.backBtn];
    [self.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.frame = CGRectMake(kScreenWidth / 2 - 40, CGRectGetMidY(self.imageView.frame) + 10, 80, 30);
    self.loginBtn.layer.cornerRadius = 4;
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.backgroundColor = UIRGBColor(19, 32, 255);
    [self.loginBtn setTitle:@"请登录" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = kMainFont;
    [self.loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.loginBtn];
    
    if (![[UserManager sharedManager] isUserLogin]) {
        self.state = VideoState_notLogin;
    }else if ([[UserManager sharedManager] getUserLevel] == 1)
    {
        self.state = VideoState_noJurisdiction;
    }else
    {
        self.state = VideoState_haveJurisdiction;
    }
}

- (void)resetWithInfoDic:(NSDictionary *)infoDic
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[infoDic objectForKey:kCourseCover]] placeholderImage:[UIImage imageNamed:@"已结束"]];
}

- (void)backAction
{
    if (self.BackClickBlock) {
        self.BackClickBlock();
    }
}

- (void)loginClick
{
    
    if (self.loginClickBlock) {
        self.loginClickBlock(self.state,self.infoDic);
    }
}

@end
