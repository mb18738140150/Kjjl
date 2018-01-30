//
//  QuestionViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "QuestionViewController.h"
#import "UIMacro.h"
#import "QuestionViewTableDataSource.h"
#import "QuestionManager.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "UIUtility.h"
#import "CommonMacro.h"
#import "QuestionMacro.h"
#import "QuestionDetailViewController.h"
#import "PublishQuestionViewController.h"


@interface QuestionViewController ()<UITableViewDelegate,QuestionModule_QuestionProtocol>

@property (nonatomic,assign) BOOL                            isLoadingMore;

@property (nonatomic,strong) UITableView                    *contentTableView;

@property (nonatomic,strong) QuestionViewTableDataSource    *tableDataSource;

@property (nonatomic,strong) NSArray                        *questionsInfos;

@property (nonatomic,strong) UIImageView                    *publishImageView;

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationViewSetup];
    
    [self contentViewSetup];
    
    [self doStartQuestionRequest];
    
    self.isLoadingMore = NO;
}

#pragma mark - request func

- (void)doStartQuestionRequest
{
    [SVProgressHUD show];
    [[QuestionManager sharedManager] didCurrentPageQuestionRequestWithNotifiedObject:self];
}

- (void)doResetQuestionRequest
{
    [[QuestionManager sharedManager] resetQuestionRequestConfig];
    [[QuestionManager sharedManager] didCurrentPageQuestionRequestWithNotifiedObject:self];
}

- (void)doNextPageQuestionRequest
{
    if (!self.isLoadingMore) {
        [[QuestionManager sharedManager] didNextPageQuestionRequestWithNotifiedObject:self];
    }
}

- (void)pushQuestionDetailWithQuestionId:(int)questionId
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    QuestionDetailViewController *detailController = [[QuestionDetailViewController alloc] init];
    detailController.hidesBottomBarWhenPushed = YES;
    detailController.questionId = questionId;
    [self.navigationController pushViewController:detailController animated:YES];
}

- (void)publishQuestion
{
    if (![[UserManager sharedManager] isUserLogin]) {
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    
    PublishQuestionViewController *vc = [[PublishQuestionViewController alloc] init];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    vc.hidesBottomBarWhenPushed = YES;
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ui setup

- (void)navigationViewSetup
{
    self.navigationItem.title = @"答疑中心";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
    
}

- (void)contentViewSetup
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableDataSource = [[QuestionViewTableDataSource alloc] init];
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight) style:UITableViewStylePlain];
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self.tableDataSource;
    self.contentTableView.separatorStyle= UITableViewCellSelectionStyleNone;
    
    self.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(doResetQuestionRequest)];
    self.contentTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(doNextPageQuestionRequest)];
    
    __weak typeof(self)weakSelf = self;
    self.tableDataSource.MoreReplyBlock = ^(int questionId){
        [weakSelf pushQuestionDetailWithQuestionId:questionId];
    };
    
    [self.view addSubview:self.contentTableView];
    
    self.publishImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 70, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight - 70, 50, 50)];
    self.publishImageView.backgroundColor = [UIColor whiteColor];
    self.publishImageView.layer.cornerRadius = 30;
    self.publishImageView.image = [UIImage imageNamed:@"community_btn"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(publishQuestion)];
    self.publishImageView.userInteractionEnabled = YES;
    [self.publishImageView addGestureRecognizer:tap];
    [self.view addSubview:self.publishImageView];
}

#pragma mark - question delegate
- (void)didQuestionRequestSuccessed
{
    self.isLoadingMore = NO;
    self.questionsInfos = [[QuestionManager sharedManager] getQuestionsInfos];
    self.tableDataSource.questionsInfoArray = self.questionsInfos;
    [SVProgressHUD dismiss];
    [self.contentTableView reloadData];
    [self.contentTableView.mj_header endRefreshing];
    [self.contentTableView.mj_footer endRefreshing];
    if ([[QuestionManager sharedManager] isLoadMax]) {
        [self.contentTableView.mj_footer endRefreshingWithNoMoreData];
    }
    
}

- (void)didQuestionRequestFailed:(NSString *)failedInfo
{
    self.isLoadingMore = NO;
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    });
    [self.contentTableView.mj_header endRefreshing];
    [self.contentTableView.mj_footer endRefreshing];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSLog(@"***** %.2f", cell.frame.size.height);
}

#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    CGFloat maxHeight = 80;
    UIFont *font = kMainFont;
    CGFloat contentHeight = [UIUtility getSpaceLabelHeght:[[self.questionsInfos objectAtIndex:indexPath.row] objectForKey:kQuestionContent] font:font width:kScreenWidth - 20];
    height = contentHeight;
    if (contentHeight > 80) {
        height = 80;
    }else
    {
        height = contentHeight;
    }
    
    NSDictionary * replyDic = [[[self.questionsInfos objectAtIndex:indexPath.row] objectForKey:@"replyList"] firstObject];
    
    CGFloat replyHeight = [UIUtility getHeightWithText:[replyDic objectForKey:@"replyCon"] font:font width:kScreenWidth - 30];
    
    CGFloat cellHeight = 10 + kHeightOfCellHeaderImage + 10 + height;
    
    if ([[[self.questionsInfos objectAtIndex:indexPath.row] objectForKey:kQuestionImgStr] count] > 0) {
        cellHeight += 5 + 60 + 10 + 30 ;
    }else
    {
        cellHeight += 10 + 30;
    }
    
    return cellHeight;
    
    /*
     
     if ([[[self.questionsInfos objectAtIndex:indexPath.row] objectForKey:kQuestionReplyCount] intValue] > 0) {
     cellHeight += replyHeight + 80;
     }else
     {
     cellHeight += 10;
     return cellHeight;
     }
     
     if ([[[self.questionsInfos objectAtIndex:indexPath.row] objectForKey:kQuestionReplyCount] intValue] > 1) {
     cellHeight += 50 + 2;
     }else
     {
     cellHeight += 10;
     }
     
     return cellHeight + 5;
     */
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int questionId = [[[self.questionsInfos objectAtIndex:indexPath.row] objectForKey:kQuestionId] intValue];
    [self pushQuestionDetailWithQuestionId:questionId];
    
}

@end
