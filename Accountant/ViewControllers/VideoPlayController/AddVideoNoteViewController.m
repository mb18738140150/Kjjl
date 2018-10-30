//
//  AddVideoNoteViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "AddVideoNoteViewController.h"
#import "UIMacro.h"
#import "NoteManager.h"
#import "CourseraManager.h"
#import "CommonMacro.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"

@interface AddVideoNoteViewController ()<NoteModule_AddVideoNoteProtocol>

@property (nonatomic,strong) UITextView                 *contentTextView;
@property (nonatomic,strong) UILabel                *courseLabel;
@property (nonatomic,strong) UILabel                *chapterLabel;
@property (nonatomic,strong) UILabel                *videoLabel;
@end

@implementation AddVideoNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigationViewSetup];
    [self contentViewSetup];
}

- (void)dissmiss
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)writeNote
{
    if (self.contentTextView.text == nil || [self.contentTextView.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"内容不能为空" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
    NSMutableDictionary *dic = [[CourseraManager sharedManager] getPlayingInfoDic];
    [dic setObject:self.contentTextView.text forKey:kNoteVideoNoteContent];
    [SVProgressHUD show];
    [[NoteManager sharedManager] didRequestAddVideoNoteWithInfo:dic andNotifiedObject:self];
}

#pragma mark - add note delegate
- (void)didRequestAddVideoNoteSuccess
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"记录成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self dissmiss];
    });
}

- (void)didRequestAddVideoNoteFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"记笔记";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
    
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(writeNote)];
    item1.tintColor = kCommonMainTextColor_50;
    self.navigationItem.rightBarButtonItem = item1;
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"public-返回"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
}
- (void)backAction:(UIButton *)button
{
    [self.contentTextView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)contentViewSetup
{
    self.courseLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, kScreenWidth, 20)];
    self.chapterLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.courseLabel.frame), kScreenWidth, 20)];
    self.videoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.chapterLabel.frame), kScreenWidth, 20)];
    self.courseLabel.text = [NSString stringWithFormat:@"课程：%@",self.courseName];
    self.chapterLabel.text = [NSString stringWithFormat:@"章   ：%@",self.chapterName];
    self.videoLabel.text = [NSString stringWithFormat:@"节   ：%@",self.videoName];
    
    self.courseLabel.textColor = kMainTextColor;
    self.courseLabel.font = kMainFont;
    self.chapterLabel.textColor = kMainTextColor;
    self.chapterLabel.font = kMainFont;
    self.videoLabel.textColor = kMainTextColor;
    self.videoLabel.font = kMainFont;
    
    [self.view addSubview:self.courseLabel];
    [self.view addSubview:self.chapterLabel];
    [self.view addSubview:self.videoLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.videoLabel.frame) + 10, kScreenWidth - 20, 1)];
    lineView.backgroundColor = kTableViewCellSeparatorColor;
    [self.view addSubview:lineView];
    
    self.contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame) + 10, kScreenWidth-20, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight - 80) textContainer:nil];
    self.contentTextView.font = kMainFont;
    [self.view addSubview:self.contentTextView];
    [self.contentTextView becomeFirstResponder];
}

@end
