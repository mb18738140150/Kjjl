//
//  CategoryExerciseViewController.m
//  tiku
//
//  Created by aaa on 2017/5/17.
//  Copyright © 2017年 ytx. All rights reserved.
//

#import "TestListViewController.h"
#import "CategorySectionHeadView.h"
#import "CategoryView.h"
#import "TestManager.h"
#import "TestChapterQuestionViewController.h"
#import "CategoryDetailTableViewCell.h"
#define  kCategoryDetailCellId @"CategoryDetailTableViewCellID"
@interface TestListViewController ()<UITableViewDelegate,UITableViewDataSource, MFoldingSectionHeaderDelegate,UIGestureRecognizerDelegate,TestModule_SectionQuestionProtocol,TestModule_ChapterInfoProtocol,TestModule_AddHistoryProtocol>

@property (nonatomic, strong)UITableView *contentTableView;
@property (nonatomic, strong) NSMutableArray *statusArray;

@property (nonatomic,strong) NSArray                                *testChapterInfoArray;

@property (nonatomic,assign) int                                     selectSection;
@property (nonatomic,assign) int                                     selectRow;
@property (nonatomic, strong)FailView * failView;
@property (nonatomic, assign)int logId;

@property (nonatomic, strong)NSDictionary * currentCourseInfoDic;
@property (nonatomic, strong)NSMutableDictionary *currentDBCourseInfoDic;
@property (nonatomic, strong)NSDictionary * currentSectionQuestionInfoDic;

@end

@implementation TestListViewController

-(NSMutableArray *)statusArray
{
    if (!_statusArray) {
        _statusArray = [NSMutableArray array];
    }
    if (_statusArray.count) {
        if (_statusArray.count > self.contentTableView.numberOfSections) {
            [_statusArray removeObjectsInRange:NSMakeRange(self.contentTableView.numberOfSections - 1, _statusArray.count - self.contentTableView.numberOfSections)];
        }else if (_statusArray.count < self.contentTableView.numberOfSections) {
            for (NSInteger i = self.contentTableView.numberOfSections - _statusArray.count; i < self.contentTableView.numberOfSections; i++) {
                [_statusArray addObject:[NSNumber numberWithInteger:MFoldingSectionStateFlod]];
            }
        }
    }else{
        for (NSInteger i = 0; i < self.contentTableView.numberOfSections; i++) {
            [_statusArray addObject:[NSNumber numberWithInteger:MFoldingSectionStateFlod]];
        }
    }
    return _statusArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kCommonNavigationBarColor;
    
    [self navigationViewSetup];
    [self contentViewInit];
    
    [self startRequest];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.currentCourseInfoDic = [[DBManager sharedManager]getTestCourseInfoWith:@(self.courseCategoryId)];
    self.currentSectionQuestionInfoDic = nil;
    [self.contentTableView reloadData];
}
- (void)startRequest
{
    [SVProgressHUD show];
    [[TestManager sharedManager] didRequesTestChapterInfoWithCategoryId:self.courseCategoryId andNotifiedObject:self];
    self.currentCourseInfoDic = [[DBManager sharedManager]getTestCourseInfoWith:@(self.courseCategoryId)];
}

- (void)requestSectionQuestionsWithSectionId:(int)sectionId
{
    [SVProgressHUD show];
    [[TestManager sharedManager] didRequestTestSectionQuestionWithSection:sectionId andNotifiedObject:self];
}

- (void)requestEnd
{
    [self.contentTableView.mj_header endRefreshing];
    [SVProgressHUD dismiss];
}

- (void)addHistory
{
    NSDictionary *dic = [self.testChapterInfoArray objectAtIndex:self.selectSection];
    NSArray *array = [dic objectForKey:kTestChapterSectionArray];
    NSDictionary *secDic = [array objectAtIndex:self.selectRow];
    NSDictionary *d = @{kLID:@(self.lid),
                        kKID:@(self.courseCategoryId),
                        kTestSimulateId:@(0),
                        kTestChapterId:@([[dic objectForKey:kTestChapterId] intValue]),
                        kTestSectionId:@([[secDic objectForKey:kTestSectionId] intValue]),
                        kLogName:@"章节练习"};
    [[TestManager sharedManager] didRequestAddTestHistoryWithInfo:d andNotifiedObject:self];
}
- (void)didRequestAddHistorySuccess
{
    NSDictionary *dic = [self.testChapterInfoArray objectAtIndex:self.selectSection];
    NSArray *array = [dic objectForKey:kTestChapterSectionArray];
    NSDictionary *secDic = [array objectAtIndex:self.selectRow];
    self.logId = [[TestManager sharedManager] getLogId];
    [self requestSectionQuestionsWithSectionId:[[secDic objectForKey:kTestSectionId] intValue]];
}
- (void)didRequestAddHistoryFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.contentTableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - test delegate
- (void)didRequestChapterInfoSuccess
{
    [SVProgressHUD dismiss];
    self.failView.hidden = YES;
    [self.contentTableView.mj_header endRefreshing];
    self.testChapterInfoArray = [[TestManager sharedManager] getChapterInfoArray];
    if (self.testChapterInfoArray.count == 0) {
        self.failView.failType = FailType_NoData;
    }
    [self.contentTableView reloadData];
}

- (void)didRequestChapterInfoFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.contentTableView.mj_header endRefreshing];
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

- (void)didRequestSectionQuestionSuccess
{
    [SVProgressHUD dismiss];
    TestChapterQuestionViewController *vc = [[TestChapterQuestionViewController alloc] init];
    vc.questionType = TestQuestionTypeChapter;
    vc.hidesBottomBarWhenPushed = YES;
    vc.logId = self.logId;
    vc.currentDBourseInfoDic = self.currentDBCourseInfoDic;
    vc.currentsectionQuestionInfoDic = self.currentSectionQuestionInfoDic;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didRequestSectionQuestionFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - banner delegate
- (void)didBannerRequestSuccess
{
    [self requestEnd];
    [self.contentTableView reloadData];
}

- (void)didBannerRequestFailed
{
    [self requestEnd];
    [SVProgressHUD showErrorWithStatus:@"网络连接失败，请稍后再试"];
}

- (void)contentViewInit
{
    CGRect tableViewRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight);
    self.contentTableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentTableView registerClass:[CategoryDetailTableViewCell class] forCellReuseIdentifier:kCategoryDetailCellId];
    self.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self startRequest];
    }];
    
    [self.view addSubview:self.contentTableView];
    
    self.failView = [[FailView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight)];
    [self.view addSubview:self.failView];
    self.failView.hidden = YES;
    __weak TestListViewController *weakSelf = self;
    self.failView.refreshBlock = ^(){
        [weakSelf startRequest];
    };
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = self.categoryName;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50,NSFontAttributeName:[UIFont systemFontOfSize:17]};
    
    CategoryView *cateView = [[CategoryView alloc] initWithFrame:CGRectMake(0,0,25,25)];
    cateView.pageType = PageMessage;
    cateView.categoryCoverUrl = @"tiku_new";
    cateView.backgroundColor = [UIColor clearColor];
    [cateView setupNaviContents];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:cateView];
    self.navigationItem.rightBarButtonItem = item;
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"public-返回"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer
                                      *)gestureRecognizer{
    return YES; //YES：允许右滑返回  NO：禁止右滑返回
}



#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0;
    
    cellHeight = 64;
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 64;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CategorySectionHeadView * view = [[CategorySectionHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64) withTag:section];
    
    BOOL currentIsOpen = ((NSNumber *)self.statusArray[section]).boolValue;
    
    MFoldingSectionState state = 0;
    if (currentIsOpen) {
        state = MFoldingSectionStateShow;
    }else
    {
        state = MFoldingSectionStateFlod;
    }
    
    NSInteger chapterQuestionCount = [self getChapterQuestionCount:section];
    NSInteger writeQuestionCount = [self getChapterWriteQuestionCount:section];
    
    NSDictionary *dic = [self.testChapterInfoArray objectAtIndex:section];
    view.isChapter = YES;
    [view setupWithBackgroundColor:[UIColor whiteColor] titleString:[dic objectForKey:kTestChapterName] titleColor:kMainTextColor_100 titleFont:kMainFont descriptionString:[NSString stringWithFormat:@"%d/%d", writeQuestionCount, chapterQuestionCount] descriptionColor:kMainTextColor_100 descriptionFont:[UIFont systemFontOfSize:12] peopleCountString:@"" peopleCountColor:kMainTextColor_100 peopleCountFont:[UIFont systemFontOfSize:12] arrowImage:[UIImage imageNamed:@"tiku_plus"] learnImage:[UIImage imageNamed:@"tiku_text"] arrowPosition:MFoldingSectionHeaderArrowPositionLeft sectionState:state];
    view.tapDelegate = self;
    return view;
}

- (NSInteger)getChapterQuestionCount:(NSInteger)section
{
    NSDictionary *dic = [self.testChapterInfoArray objectAtIndex:section];
    NSInteger count = [[dic objectForKey:kTestChapterQuestionCount] integerValue];
    return count;
}

- (NSInteger)getChapterWriteQuestionCount:(NSInteger)section
{
    NSDictionary *dic = [self.testChapterInfoArray objectAtIndex:section];
    
    NSArray * chapterArray = [self.currentCourseInfoDic objectForKey:kCourseChapterInfos];
    
    NSInteger count = 0;
    for (int i = 0; i < chapterArray.count; i++) {
        NSDictionary * chapterInfoDic = [chapterArray objectAtIndex:i];
        
        if ([[chapterInfoDic objectForKey:kTestChapterId] isEqual:[dic objectForKey:kTestChapterId]]) {
            NSArray * sectionArry = [chapterInfoDic objectForKey:kTestChapterSectionArray];
            
            for (int j = 0; j < sectionArry.count; j++) {
                NSDictionary * sectionInfoDic = sectionArry[j];
                count += [[sectionInfoDic objectForKey:@"currentIndex"] integerValue];
            }
            
            break;
        }
    }
    
    return count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.testChapterInfoArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (((NSNumber *)self.statusArray[section]).integerValue == MFoldingSectionStateShow) {
        NSDictionary *dic = [self.testChapterInfoArray objectAtIndex:section];
        NSArray *array = [dic objectForKey:kTestChapterSectionArray];
        return array.count;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CategoryDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCategoryDetailCellId forIndexPath:indexPath];
    //    NSDictionary *dic = [self.testChapterInfoArray objectAtIndex:indexPath.section];
    //    NSArray *array = [dic objectForKey:kTestChapterSectionArray];
    //    NSDictionary *secDic = [array objectAtIndex:indexPath.row];
    //        if (indexPath.row == array.count - 1) {
    //            [cell resetisLast:YES withDicInfo:secDic];
    //        }else
    //        {
    //            [cell resetisLast:NO withDicInfo:secDic];
    //        }
    
    
    NSDictionary *dic = [self.testChapterInfoArray objectAtIndex:indexPath.section];
    NSArray *array = [dic objectForKey:kTestChapterSectionArray];
    NSMutableDictionary *secDic = [[array objectAtIndex:indexPath.row] mutableCopy];
    
    [secDic setValue:@(0) forKey:@"currentIndex"];
    
    NSArray * chapterArray = [self.currentCourseInfoDic objectForKey:kCourseChapterInfos];
    
    for (int i = 0; i < chapterArray.count; i++) {
        NSDictionary * chapterInfoDic = [chapterArray objectAtIndex:i];
        
        if ([[chapterInfoDic objectForKey:kTestChapterId] isEqual:[dic objectForKey:kTestChapterId]]) {
            NSArray * sectionArry = [chapterInfoDic objectForKey:kTestChapterSectionArray];
            
            for (NSDictionary * infoDic in sectionArry) {
                if ([[infoDic objectForKey:kTestSectionId] isEqual:[secDic objectForKey:kTestSectionId]]) {
                    [secDic setValue:[infoDic objectForKey:@"currentIndex"] forKey:@"currentIndex"];
                }
                
            }
            
            break;
        }
    }
    cell.cellType = CellType_chapterTest;
    if (indexPath.row == array.count - 1) {
        [cell resetisLast:YES withDicInfo:secDic];
    }else
    {
        [cell resetisLast:NO withDicInfo:secDic];
    }
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectSection = (int)indexPath.section;
    self.selectRow = (int)indexPath.row;
    NSDictionary *dic = [self.testChapterInfoArray objectAtIndex:indexPath.section];
    NSArray *array = [dic objectForKey:kTestChapterSectionArray];
    NSDictionary *secDic = [array objectAtIndex:indexPath.row];
    
    self.currentDBCourseInfoDic = [NSMutableDictionary dictionary];
    [self.currentDBCourseInfoDic setValue:@(self.courseCategoryId) forKey:kCourseID];
    [self.currentDBCourseInfoDic setValue:self.categoryName forKey:kCourseName];
    [self.currentDBCourseInfoDic setObject:[dic objectForKey:kTestChapterName] forKey:kTestChapterName];
    [self.currentDBCourseInfoDic setObject:[dic objectForKey:kTestChapterId] forKey:kTestChapterId];
    [self.currentDBCourseInfoDic setObject:[dic objectForKey:kTestChapterQuestionCount] forKey:kTestChapterQuestionCount];
    [self.currentDBCourseInfoDic setObject:[secDic objectForKey:kTestSectionName] forKey:kTestSectionName];
    [self.currentDBCourseInfoDic setObject:[secDic objectForKey:kTestSectionId] forKey:kTestSectionId];
    [self.currentDBCourseInfoDic setObject:[secDic objectForKey:kTestSectionQuestionCount] forKey:kTestSectionQuestionCount];
    
    NSArray * chapterArray = [self.currentCourseInfoDic objectForKey:kCourseChapterInfos];
    
    for (int i = 0; i < chapterArray.count; i++) {
        NSDictionary * chapterInfoDic = [chapterArray objectAtIndex:i];
        
        if ([[chapterInfoDic objectForKey:kTestChapterId] isEqual:[dic objectForKey:kTestChapterId]]) {
            NSArray * sectionArry = [chapterInfoDic objectForKey:kTestChapterSectionArray];
            
            for (NSDictionary * infoDic in sectionArry) {
                if ([[infoDic objectForKey:kTestSectionId] isEqual:[secDic objectForKey:kTestSectionId]]) {
                    
                    self.currentSectionQuestionInfoDic = infoDic;
                    break;
                }
                
            }
            
            break;
        }
        
    }
    [SVProgressHUD show];
    [self addHistory];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - YUFoldingSectionHeaderDelegate

-(void)MFoldingSectionHeaderTappedAtIndex:(NSInteger)index
{
    BOOL currentIsOpen = ((NSNumber *)self.statusArray[index]).boolValue;
    
    [self.statusArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!currentIsOpen]];
    
    NSDictionary *dic = [self.testChapterInfoArray objectAtIndex:index ];
    NSArray *array = [dic objectForKey:kTestChapterSectionArray];
    NSInteger numberOfRow = array.count;
    NSMutableArray *rowArray = [NSMutableArray array];
    if (numberOfRow) {
        for (NSInteger i = 0; i < numberOfRow; i++) {
            [rowArray addObject:[NSIndexPath indexPathForRow:i inSection:index]];
        }
    }
    if (rowArray.count) {
        if (currentIsOpen) {
            [self.contentTableView deleteRowsAtIndexPaths:[NSArray arrayWithArray:rowArray] withRowAnimation:UITableViewRowAnimationTop];
        }else{
            [self.contentTableView insertRowsAtIndexPaths:[NSArray arrayWithArray:rowArray] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
