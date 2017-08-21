//
//  TestRewriteWrongViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestRewriteWrongViewController.h"
#import "UIMacro.h"
#import "TestManager.h"
#import "SVProgressHUD.h"
#import "YUFoldingTableView.h"
#import "MJRefresh.h"
#import "CommonMacro.h"
#import "SectionListTableViewCell.h"
#import "TestChapterQuestionViewController.h"
#import "TestErrorListTableViewCell.h"
#import "CategoryDetailTableViewCell.h"
#define  kCategoryDetailCellId @"CategoryDetailTableViewCellID"

@interface TestRewriteWrongViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,TestModule_MyWrongQuestionInfoProtocol,TestModule_MyWrongQuestionsListProtocol>

@property (nonatomic,strong) UITableView            *tableView;

@property (nonatomic,strong) NSArray                *rewriteQuestionChapterInfo;
@property (nonatomic,assign) int                                     selectRow;

@property (nonatomic, strong)NSDictionary * currentCourseInfoDic;
@property (nonatomic, strong)NSMutableDictionary *currentDBCourseInfoDic;
@property (nonatomic, strong)NSDictionary * currentSectionQuestionInfoDic;

@end

@implementation TestRewriteWrongViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.currentCourseInfoDic = [[DBManager sharedManager]getMyWrongTestCourseInfoWith:@(self.cateId) type:kDBErrorType_Mywrong];
    self.currentSectionQuestionInfoDic = nil;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationViewSetup];
    [self contentViewSetup];
    [self requestRewriteWrongQuestion];
    // Do any additional setup after loading the view.
}

- (void)requestRewriteWrongQuestion
{
    [SVProgressHUD show];
    [[TestManager sharedManager] didRequestTestMyWrongQuestionChapterInfoWithCategoryId:self.cateId andNotifiedObject:self];
    self.currentCourseInfoDic = [[DBManager sharedManager]getMyWrongTestCourseInfoWith:@(self.cateId) type:kDBErrorType_Mywrong];
}

- (void)reqeustMyWrongQuestionsWithChapterId:(int)chapterId
{
    [SVProgressHUD show];
    [[TestManager sharedManager] didRequestTestMyWrongQuestionListWithChapterId:chapterId andNotifiedObject:self];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer
                                      *)gestureRecognizer{
    return YES; //YES：允许右滑返回  NO：禁止右滑返回
}

- (void)showNoInfos
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavigationBarHeight)];
    label.backgroundColor = kBackgroundGrayColor;
    label.text = @"暂无错题";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.tableView removeFromSuperview];
    [self.view addSubview:label];
}

- (void)addHistory
{
    NSDictionary *dic = [self.rewriteQuestionChapterInfo objectAtIndex:self.selectRow];
    NSDictionary *d = @{kTestAddHistoryType:@(4),
                        kTestChapterId:[dic objectForKey:kTestChapterId],
                        kTestSectionId:@(0),
                        kTestSimulateId:@(0)};
    [[TestManager sharedManager] didRequestAddTestHistoryWithInfo:d];
}

#pragma mark - delegate
- (void)didRequestMyWrongQuestionSuccess
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    self.rewriteQuestionChapterInfo = [[TestManager sharedManager] getMyWrongChapterInfoArray];
    [self.tableView reloadData];
}

- (void)didRequestMyWrongQuestionFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    if ([failedInfo isEqualToString:@"暂无数据"]) {
        [self showNoInfos];
    }else{
        [SVProgressHUD showErrorWithStatus:failedInfo];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
}

- (void)didRequestMyWrongQuestionsListSuccess
{
    [SVProgressHUD dismiss];
    [self addHistory];
    TestChapterQuestionViewController *vc = [[TestChapterQuestionViewController alloc] init];
    vc.questionType = TestQuestionTypeMyWrong;
    vc.currentDBourseInfoDic = self.currentDBCourseInfoDic;
    vc.currentsectionQuestionInfoDic = self.currentSectionQuestionInfoDic;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didRequestMyWrongQuestionsListFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - table delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectRow = indexPath.row;
    
    NSDictionary *dic = [self.rewriteQuestionChapterInfo objectAtIndex:indexPath.row];
    
    self.currentDBCourseInfoDic = [NSMutableDictionary dictionary];
    [self.currentDBCourseInfoDic setValue:@(self.cateId) forKey:kCourseID];
    [self.currentDBCourseInfoDic setValue:self.cateName forKey:kCourseName];
    [self.currentDBCourseInfoDic setObject:[dic objectForKey:kTestChapterName] forKey:kTestChapterName];
    [self.currentDBCourseInfoDic setObject:[dic objectForKey:kTestChapterId] forKey:kTestChapterId];
    [self.currentDBCourseInfoDic setObject:[dic objectForKey:kTestChapterQuestionCount] forKey:kTestChapterQuestionCount];
    [self.currentDBCourseInfoDic setObject:kDBErrorType_Mywrong forKey:@"type"];
    
    NSArray * chapterArray = [self.currentCourseInfoDic objectForKey:kCourseChapterInfos];
    
    for (int i = 0; i < chapterArray.count; i++) {
        NSDictionary * chapterInfoDic = [chapterArray objectAtIndex:i];
        
        if ([[chapterInfoDic objectForKey:kTestChapterId] isEqual:[dic objectForKey:kTestChapterId]]) {
            
            self.currentSectionQuestionInfoDic = chapterInfoDic;
            
            break;
        }
        
    }
    
    [self reqeustMyWrongQuestionsWithChapterId:[[dic objectForKey:kTestChapterId] intValue]];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCategoryDetailCellId forIndexPath:indexPath];
    
    NSDictionary *dic = [self.rewriteQuestionChapterInfo objectAtIndex:indexPath.row];
    cell.cellType = CellType_myWrong;
    
    NSMutableDictionary * chapterDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [chapterDic setObject:@(0) forKey:@"currentIndex"];
    NSArray * chapterArray = [self.currentCourseInfoDic objectForKey:kCourseChapterInfos];
    
    for (int i = 0; i < chapterArray.count; i++) {
        NSDictionary * chapterInfoDic = [chapterArray objectAtIndex:i];
        
        if ([[chapterInfoDic objectForKey:kTestChapterId] isEqual:[dic objectForKey:kTestChapterId]]) {
            
            [chapterDic setValue:[chapterInfoDic objectForKey:@"currentIndex"] forKey:@"currentIndex"];
            
            break;
        }
    }
    
    
    [cell resetisLast:YES withDicInfo:chapterDic];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rewriteQuestionChapterInfo.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

#pragma mark - ui

- (void)navigationViewSetup
{
    self.navigationItem.title = @"我的错题";
    
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[CategoryDetailTableViewCell class] forCellReuseIdentifier:kCategoryDetailCellId];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestRewriteWrongQuestion)];
    [self.view addSubview:self.tableView];
}


@end
