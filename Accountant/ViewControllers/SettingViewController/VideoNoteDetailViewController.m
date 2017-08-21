//
//  VideoNoteDetailViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "VideoNoteDetailViewController.h"
#import "UIMacro.h"
#import "CommonMacro.h"
#import "UIUtility.h"

@interface VideoNoteDetailViewController ()

@property (nonatomic,strong) UIScrollView           *contentScrollView;

@property (nonatomic,strong) UILabel                *courseLabel;
@property (nonatomic,strong) UILabel                *chapterLabel;
@property (nonatomic,strong) UILabel                *videoLabel;

@property (nonatomic,strong) UILabel                *contentLabel;

@end

@implementation VideoNoteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationViewSetup];
    [self contentViewSetup];
}

- (void)navigationViewSetup
{
    
    self.navigationItem.title = @"笔记详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //    self.navigationController.navigationBarHidden = YES;
    
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"public-返回"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)contentViewSetup
{
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth - 20, kScreenHeight - kStatusBarHeight - kNavigationBarHeight)];
    [self.view addSubview:self.contentScrollView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.courseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    self.chapterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 20)];
    self.videoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 20)];
    self.courseLabel.text = [NSString stringWithFormat:@"课程：%@",[self.noteDetailInfo objectForKey:kCourseName]];
    self.chapterLabel.text = [NSString stringWithFormat:@"章   ：%@",[self.noteDetailInfo objectForKey:kChapterName]];
    self.videoLabel.text = [NSString stringWithFormat:@"节   ：%@",[self.noteDetailInfo objectForKey:kVideoName]];
    
    self.courseLabel.textColor = kMainTextColor;
    self.courseLabel.font = kMainFont;
    self.chapterLabel.textColor = kMainTextColor;
    self.chapterLabel.font = kMainFont;
    self.videoLabel.textColor = kMainTextColor;
    self.videoLabel.font = kMainFont;
    
    [self.contentScrollView addSubview:self.courseLabel];
    [self.contentScrollView addSubview:self.chapterLabel];
    [self.contentScrollView addSubview:self.videoLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth - 20, 1)];
    lineView.backgroundColor = kTableViewCellSeparatorColor;
    [self.contentScrollView addSubview:lineView];
    
    NSString *content = [self.noteDetailInfo objectForKey:kNoteVideoNoteContent];
    CGFloat contentHeight = [UIUtility getHeightWithText:content font:kMainFont width:kScreenWidth - 20];
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, kScreenWidth-20, contentHeight)];
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.numberOfLines = 100000;
    self.contentLabel.text = content;
    self.contentLabel.font = kMainFont;
    self.contentLabel.textColor = kMainTextColor;
    [self.contentScrollView addSubview:self.contentLabel];
    
    self.contentScrollView.contentSize = CGSizeMake(kScreenWidth-20, contentHeight + 80);
    
}

@end
