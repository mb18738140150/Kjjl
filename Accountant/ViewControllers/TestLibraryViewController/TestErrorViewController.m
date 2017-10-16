//
//  TestErrorViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestErrorViewController.h"
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
@interface TestErrorViewController ()<UITableViewDelegate,UITableViewDataSource,TestModule_ErrorInfoProtocol,TestModule_ErrorQuestionProtocol,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UITableView        *tableView;
@property (nonatomic,strong) NSArray            *array;

@property (nonatomic,assign) int                                     selectSection;
@property (nonatomic,assign) int                                     selectRow;

@property (nonatomic, strong)FailView * failView;

@property (nonatomic, strong)NSDictionary * currentCourseInfoDic;
@property (nonatomic, strong)NSMutableDictionary *currentDBCourseInfoDic;
@property (nonatomic, strong)NSDictionary * currentSectionQuestionInfoDic;

@end

@implementation TestErrorViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.currentCourseInfoDic = [[DBManager sharedManager]getMyWrongTestCourseInfoWith:@(self.cateId) type:kDBErrorType_Easywrong];
    self.currentSectionQuestionInfoDic = nil;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationViewSetup];
    [self contentViewSetup];
    // Do any additional setup after loading the view.
    [self requestErrorList];
}

- (void)requestErrorList
{
    [SVProgressHUD show];
    [[TestManager sharedManager] didRequestTestErrorInfoWithCategoryId:self.cateId andNotifiedObject:self];
    self.currentCourseInfoDic = [[DBManager sharedManager]getMyWrongTestCourseInfoWith:@(self.cateId) type:kDBErrorType_Easywrong];
}

- (void)requestErrorQuestionsWithId:(int)chapterId
{
    [SVProgressHUD show];
    [[TestManager sharedManager] didRequestTestErrorQuestionWithSectionId:chapterId andNotifiedObject:self];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer
                                      *)gestureRecognizer{
    return YES; //YES：允许右滑返回  NO：禁止右滑返回
}

- (void)addHistory
{
    NSDictionary *dic = [self.array objectAtIndex:self.selectRow];
    NSDictionary *d = @{kTestAddHistoryType:@(5),
                        kTestChapterId:[dic objectForKey:kTestChapterId],
                        kTestSectionId:@(0),
                        kTestSimulateId:@(0)};
    [[TestManager sharedManager] didRequestAddTestHistoryWithInfo:d];
}

#pragma mark - delegate func

- (void)didReqeustErrorInfoSuccess
{
    [SVProgressHUD dismiss];
    self.failView.hidden = YES;
    [self.tableView.mj_header endRefreshing];
    self.array = [[TestManager sharedManager] getErrorInfoArray];
    if (self.array.count == 0) {
        self.failView.failType = FailType_NoData;
    }
    [self.tableView reloadData];
}

- (void)didReqeustErrorInfoFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        self.failView.hidden = NO;
        if ([failedInfo isEqualToString:kNetError]) {
            self.failView.failType = FailType_NoNetWork;
        }else
        {
            self.failView.failType = FailType_NoData;
        }
    });
}

- (void)didRequestErrorQuestionSuccess
{
    [SVProgressHUD dismiss];
    [self addHistory];
    TestChapterQuestionViewController *vc = [[TestChapterQuestionViewController alloc] init];
    vc.questionType = TestQuestionTypeError;
    vc.currentDBourseInfoDic = self.currentDBCourseInfoDic;
    vc.currentsectionQuestionInfoDic = self.currentSectionQuestionInfoDic;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didRequestErrorQuestionFailed:(NSString *)failedInfo
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
    self.navigationItem.title = @"易错题";
    
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
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestErrorList)];
    [self.tableView registerClass:[CategoryDetailTableViewCell class] forCellReuseIdentifier:kCategoryDetailCellId];
    [self.view addSubview:self.tableView];
    
    self.failView = [[FailView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight)];
    [self.view addSubview:self.failView];
    self.failView.hidden = YES;
    __weak TestErrorViewController *weakSelf = self;
    self.failView.refreshBlock = ^(){
        [weakSelf requestErrorList];
    };
    
}

#pragma mark - table delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectRow = (int)indexPath.row;
    NSDictionary *dic = [self.array objectAtIndex:indexPath.row];
    
    self.currentDBCourseInfoDic = [NSMutableDictionary dictionary];
    [self.currentDBCourseInfoDic setValue:@(self.cateId) forKey:kCourseID];
    [self.currentDBCourseInfoDic setValue:self.cateName forKey:kCourseName];
    [self.currentDBCourseInfoDic setObject:[dic objectForKey:kTestChapterName] forKey:kTestChapterName];
    [self.currentDBCourseInfoDic setObject:[dic objectForKey:kTestChapterId] forKey:kTestChapterId];
    [self.currentDBCourseInfoDic setObject:[dic objectForKey:kTestChapterQuestionCount] forKey:kTestChapterQuestionCount];
    [self.currentDBCourseInfoDic setObject:kDBErrorType_Easywrong forKey:@"type"];
    
    NSArray * chapterArray = [self.currentCourseInfoDic objectForKey:kCourseChapterInfos];
    
    for (int i = 0; i < chapterArray.count; i++) {
        NSDictionary * chapterInfoDic = [chapterArray objectAtIndex:i];
        
        if ([[chapterInfoDic objectForKey:kTestChapterId] isEqual:[dic objectForKey:kTestChapterId]]) {
            
            self.currentSectionQuestionInfoDic = chapterInfoDic;
            
            break;
        }
        
    }
    
    [self requestErrorQuestionsWithId:[[dic objectForKey:kTestChapterId] intValue]];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCategoryDetailCellId forIndexPath:indexPath];
    
    NSDictionary *dic = [self.array objectAtIndex:indexPath.row];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

@end
