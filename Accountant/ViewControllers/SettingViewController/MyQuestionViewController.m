//
//  MyQuestionViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/18.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MyQuestionViewController.h"
#import "UIMacro.h"
#import "CommonMacro.h"
#import "QuestionManager.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "UIUtility.h"
#import "MyQuestionTableViewCell.h"
#import "QuestionDetailViewController.h"
#import "HYSegmentedControl.h"

#define kHeaderViewHeight 42
#define kSegmentHeight 42
@interface MyQuestionViewController ()<UITableViewDelegate,UITableViewDataSource,QuestionModule_MyQuestionNotReply,QuestionModule_MyQuestionAlreadyReply, HYSegmentedControlDelegate>

@property (nonatomic, strong)HYSegmentedControl * segmentC;

@property (nonatomic,strong) UIView                                 *headerView;

@property (nonatomic,strong) UIButton                               *button1;
@property (nonatomic,strong) UIButton                               *button2;

@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic,strong) UITableView                            *alreadyRelpyTableView;
@property (nonatomic,strong) UITableView                            *notReplyTableView;

@property (nonatomic,strong) NSArray                                *alreadyReplyQuestionArray;
@property (nonatomic,strong) NSArray                                *notReplyQuestionArray;


@end

@implementation MyQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self navigationViewSetup];
    [self segmentSetup];
    [self tablesSetup];
    [self alreadyReplyRequest];
    [self notReplyRequest];
}

- (void)alreadyReplyRequest
{
    [SVProgressHUD show];
    [[QuestionManager sharedManager] didRequestMyQuestionAlreadyReplyWithNotifiedObject:self];
}

- (void)notReplyRequest
{
    [SVProgressHUD show];
    [[QuestionManager sharedManager] didRequestMyQuestionNotReplyWithNotifiedObject:self];
}

#pragma mark - question delegate
- (void)didMyQuestionNotReplyRequestSuccessed
{
    [SVProgressHUD dismiss];
    [self.notReplyTableView.mj_header endRefreshing];
    self.notReplyQuestionArray = [[QuestionManager sharedManager] getNotReplyQuestionArray];
    [self.notReplyTableView reloadData];
}

- (void)didMyQuestionNotReplyRequestFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.notReplyTableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didMyQuestionAlreadyReplyRequestSuccessed
{
    [SVProgressHUD dismiss];
    [self.alreadyRelpyTableView.mj_header endRefreshing];
    self.alreadyReplyQuestionArray = [[QuestionManager sharedManager] getAlreadyReplyQuestionArray];
    [self.alreadyRelpyTableView reloadData];
}

- (void)didMyQuestionAlreadyReplyRequestFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.alreadyRelpyTableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}



#pragma mark - response func
- (void)switchAlreadyReplyTable
{
    [self.button1 setTitleColor:kCommonNavigationBarColor forState:UIControlStateNormal];
    [self.button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.notReplyTableView removeFromSuperview];
    [self.view addSubview:self.alreadyRelpyTableView];
}

- (void)switchNotReplyTable
{
    [self.button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button2 setTitleColor:kCommonNavigationBarColor forState:UIControlStateNormal];
    [self.alreadyRelpyTableView removeFromSuperview];
    [self.view addSubview:self.notReplyTableView];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, 64)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"问答";
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
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderViewHeight)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headerView];
    
    self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button1.frame = CGRectMake(0, 0, kScreenWidth/2, kHeaderViewHeight);
    [self.button1 setTitle:@"已回答" forState:UIControlStateNormal];
    [self.button1 setTitleColor:kCommonNavigationBarColor forState:UIControlStateNormal];
    self.button1.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.button1 addTarget:self action:@selector(switchAlreadyReplyTable) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button2.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, kHeaderViewHeight);
    [self.button2 setTitle:@"未回答" forState:UIControlStateNormal];
    [self.button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.button2.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.button2 addTarget:self action:@selector(switchNotReplyTable) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2, 5, 1, 30)];
    lineView.backgroundColor = kTableViewCellSeparatorColor;
    [self.headerView addSubview:lineView];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 5)];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = bottomLineView.bounds;
    layer.startPoint = CGPointMake(0.5, 0);
    layer.endPoint = CGPointMake(0.5, 1);
    layer.colors = [NSArray arrayWithObjects:(id)kTableViewCellSeparatorColor.CGColor,(id)[UIColor whiteColor].CGColor, nil];
    layer.locations = @[@(0.3f)];
    [bottomLineView.layer addSublayer:layer];
    
    [self.headerView addSubview:bottomLineView];
    [self.headerView addSubview:self.button1];
    [self.headerView addSubview:self.button2];
}
- (void)segmentSetup
{
    self.segmentC = [[HYSegmentedControl alloc] initWithOriginY:0 Titles:@[@"已回答", @"待回答"] delegate:self];
    [self.view addSubview:self.segmentC];
}
- (void)tablesSetup
{
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kSegmentHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kSegmentHeight)];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kSegmentHeight);
    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    
    self.alreadyRelpyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kHeaderViewHeight) style:UITableViewStylePlain];
    self.alreadyRelpyTableView.dataSource = self;
    self.alreadyRelpyTableView.delegate = self;
    self.alreadyRelpyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(alreadyReplyRequest)];
    [self.scrollView addSubview:self.alreadyRelpyTableView];
    
    self.notReplyTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kHeaderViewHeight) style:UITableViewStylePlain];
    self.notReplyTableView.dataSource = self;
    self.notReplyTableView.delegate = self;
    self.notReplyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(notReplyRequest)];
    
    [self.scrollView addSubview:self.notReplyTableView];
}

#pragma mark - table delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.alreadyRelpyTableView) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = item;
        QuestionDetailViewController *detailController = [[QuestionDetailViewController alloc] init];
        detailController.questionId = [[[self.alreadyReplyQuestionArray objectAtIndex:indexPath.row] objectForKey:kQuestionId] intValue];
        [self.navigationController pushViewController:detailController animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.alreadyRelpyTableView) {
        return self.alreadyReplyQuestionArray.count;
    }
    if (tableView == self.notReplyTableView) {
        return self.notReplyQuestionArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyQuestionTableViewCell *cell = (MyQuestionTableViewCell *)[UIUtility getCellWithCellName:@"myquestionCell" inTableView:tableView andCellClass:[MyQuestionTableViewCell class]];
    if (tableView == self.alreadyRelpyTableView) {
        [cell resetContentWithInfo:[self.alreadyReplyQuestionArray objectAtIndex:indexPath.row] andIsReply:YES];
    }
    if (tableView == self.notReplyTableView) {
        [cell resetContentWithInfo:[self.notReplyQuestionArray objectAtIndex:indexPath.row] andIsReply:NO];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *content = @"";
    if (tableView == self.alreadyRelpyTableView) {
        NSDictionary *dic = [self.alreadyReplyQuestionArray objectAtIndex:indexPath.row];
        content = [dic objectForKey:kQuestionContent];
    }
    if (tableView == self.notReplyTableView) {
        NSDictionary *dic = [self.notReplyQuestionArray objectAtIndex:indexPath.row];
        content = [dic objectForKey:kQuestionContent];
    }
    
    CGFloat maxHeight = 80;
    CGFloat contentHeight = [UIUtility getHeightWithText:content font:kMainFont width:kScreenWidth - 40];
    CGFloat height = 0;
    if (maxHeight > contentHeight) {
        height = contentHeight;
    }else{
        height = maxHeight;
    }
    
    if (tableView == self.alreadyRelpyTableView) {
        return 10 + height +5+ 20 + 10;
    }
    if (tableView == self.notReplyTableView) {
        return 10 + height + 10;
    }
    return 0;
}
#pragma mark - HYSegmentedControl 代理方法
- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    [self.scrollView setContentOffset:CGPointMake(index * _scrollView.hd_width, 0) animated:NO];
}
@end
