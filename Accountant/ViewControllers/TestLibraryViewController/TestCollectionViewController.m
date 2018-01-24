//
//  TestCollectionViewController.m
//  Accountant
//
//  Created by aaa on 2017/6/24.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestCollectionViewController.h"
#import "CategorySectionHeadView.h"
#import "CategoryView.h"
#import "TestChapterQuestionViewController.h"
#import "CategoryDetailTableViewCell.h"
#define  kCategoryDetailCellId @"CategoryDetailTableViewCellID"
#import "HYSegmentedControl.h"
#define kSegmentHeight 42
@interface TestCollectionViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,TestModule_CollectQuestionInfoProtocol,TestModule_CollectQuestionListProtocol,MFoldingSectionHeaderDelegate,HYSegmentedControlDelegate>

@property (nonatomic,strong) UITableView            *tableView;

@property (nonatomic,strong) NSArray                *collectQuestionChapterInfo;// 章节题
@property (nonatomic, strong)NSArray                *simulateArray;// 模拟题

@property (nonatomic, strong) NSMutableArray *statusArray;

@property (nonatomic, strong)FailView * failView;

@property (nonatomic,assign) int                                     selectSection;
@property (nonatomic,assign) int                                     selectRow;

@property (nonatomic, strong)NSDictionary * currentCourseInfoDic;
@property (nonatomic, strong)NSMutableDictionary *currentDBCourseInfoDic;
@property (nonatomic, strong)NSDictionary * currentSectionQuestionInfoDic;

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UITableView *simulateTableView;
@property (nonatomic, strong)HYSegmentedControl *segmentControl;
@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UILabel * progressLB;

@end

@implementation TestCollectionViewController

-(NSMutableArray *)statusArray
{
    if (!_statusArray) {
        _statusArray = [NSMutableArray array];
    }
    if (_statusArray.count) {
        if (_statusArray.count > self.tableView.numberOfSections) {
            [_statusArray removeObjectsInRange:NSMakeRange(self.tableView.numberOfSections - 1, _statusArray.count - self.tableView.numberOfSections)];
        }else if (_statusArray.count < self.tableView.numberOfSections) {
            for (NSInteger i = self.tableView.numberOfSections - _statusArray.count; i < self.tableView.numberOfSections; i++) {
                [_statusArray addObject:[NSNumber numberWithInteger:MFoldingSectionStateFlod]];
            }
        }
    }else{
        for (NSInteger i = 0; i < self.tableView.numberOfSections; i++) {
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
    self.currentCourseInfoDic = [[DBManager sharedManager]getMyWrongTestCourseInfoWith:@(self.courseCategoryId) type:kDBErrorType_Collect];
    self.currentSectionQuestionInfoDic = nil;
    [self.tableView reloadData];
    [self.simulateTableView reloadData];
}
- (void)startRequest
{
    [SVProgressHUD show];
    [[TestManager sharedManager] didRequestTestCollectionInfoWithCategoryId:self.courseCategoryId andNotifiedObject:self];
    self.currentCourseInfoDic = [[DBManager sharedManager]getMyWrongTestCourseInfoWith:@(self.courseCategoryId) type:kDBErrorType_Collect];
}

- (void)requestSectionQuestionsWithSectionId:(int)sectionId
{
    
    int cateGory = 0;
    if (self.segmentControl.selectIndex == 1) {
        cateGory = 3;
    }else
    {
        cateGory = 2;
    }
    NSDictionary * infoDic = @{kTestSectionId:@(sectionId),
                               @"category":@(cateGory)};
    [SVProgressHUD show];
    [[TestManager sharedManager] didRequestTestCollectionQuestionListWithChapterId:infoDic andNotifiedObject:self];
}

- (void)requestEnd
{
    [self.tableView.mj_header endRefreshing];
    [SVProgressHUD dismiss];
}

- (void)addHistory
{
    NSDictionary *dic = [self.collectQuestionChapterInfo objectAtIndex:self.selectSection];
    NSArray *array = [dic objectForKey:kTestChapterSectionArray];
    NSDictionary *secDic = [array objectAtIndex:self.selectRow];
    NSDictionary *d = @{kTestAddHistoryType:@(1),
                        kTestChapterId:@([[dic objectForKey:kTestChapterId] intValue]),
                        kTestSectionId:@([[secDic objectForKey:kTestSectionId] intValue]),
                        kTestSimulateId:@(0)};
//    [[TestManager sharedManager] didRequestAddTestHistoryWithInfo:d];
}


#pragma mark - test delegate
- (void)didRequestCollectQuestionInfoSuccess
{
    [SVProgressHUD dismiss];
    self.failView.hidden = YES;
    [self.tableView.mj_header endRefreshing];
    [self.simulateTableView.mj_header endRefreshing];
    self.collectQuestionChapterInfo = [[[TestManager sharedManager] getMyWrongChapterInfoArray] objectAtIndex:0];
    self.simulateArray = [[[TestManager sharedManager] getMyWrongChapterInfoArray] objectAtIndex:1];
    if (self.collectQuestionChapterInfo.count == 0) {
        self.failView.failType = FailType_NoData;
    }
    [self.tableView reloadData];
    [self.simulateTableView reloadData];
}

- (void)didRequestCollectQuestionInfoFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
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

- (void)didRequestCollectQuestionListSuccess
{
    [SVProgressHUD dismiss];
    TestChapterQuestionViewController *vc = [[TestChapterQuestionViewController alloc] init];
    vc.questionType = TestQuestionTypeCollect;
    vc.hidesBottomBarWhenPushed = YES;
    vc.currentDBourseInfoDic = self.currentDBCourseInfoDic;
    vc.currentsectionQuestionInfoDic = self.currentSectionQuestionInfoDic;
    [self addHistory];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didRequestCollectQuestionListFailed:(NSString *)failedInfo
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
    [self.tableView reloadData];
    [self.simulateTableView reloadData];
}

- (void)didBannerRequestFailed
{
    [self requestEnd];
    [SVProgressHUD showErrorWithStatus:@"网络连接失败，请稍后再试"];
}

- (void)contentViewInit
{
    self.segmentControl = [[HYSegmentedControl alloc] initWithOriginY:0 Titles:@[@"章节练习", @"模拟试题"] delegate:self];
    [self.view addSubview:self.segmentControl];
    
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, kSegmentHeight, kScreenHeight, 37)];
    [self.view addSubview:titleView];
    titleView.backgroundColor = UIColorFromRGB(0xf9f9f9);
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, titleView.hd_height)];
    self.titleLB.text = @"章节";
    self.titleLB.textColor = UIColorFromRGB(0x999999);
    self.titleLB.font = [UIFont systemFontOfSize:12];
    [titleView addSubview:self.titleLB];
    self.progressLB = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 135, 0, 100, titleView.hd_height)];
    self.progressLB.textColor = UIColorFromRGB(0x999999);
    self.progressLB.text = @"已消灭/错题总数";
    self.progressLB.font = [UIFont systemFontOfSize:12];
    self.progressLB.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:self.progressLB];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kSegmentHeight + 37, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kSegmentHeight - 37)];
    [self.view addSubview:self.scrollView];
    self.scrollView.scrollEnabled = NO;
    
    CGRect simulateTableViewRect = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kSegmentHeight - 37);
    self.simulateTableView = [[UITableView alloc] initWithFrame:simulateTableViewRect style:UITableViewStylePlain];
    self.simulateTableView.delegate = self;
    self.simulateTableView.dataSource = self;
    self.simulateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.simulateTableView registerClass:[CategoryDetailTableViewCell class] forCellReuseIdentifier:kCategoryDetailCellId];
    self.simulateTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self startRequest];
    }];
    
    [self.scrollView addSubview:self.simulateTableView];
    
    CGRect tableViewRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kSegmentHeight - 37);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CategoryDetailTableViewCell class] forCellReuseIdentifier:kCategoryDetailCellId];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self startRequest];
    }];
    
    [self.scrollView addSubview:self.tableView];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kSegmentHeight - 37);
    self.failView = [[FailView alloc]initWithFrame:CGRectMake(0, kSegmentHeight + 37, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight)];
    [self.view addSubview:self.failView];
    self.failView.hidden = YES;
    __weak TestCollectionViewController *weakSelf = self;
    self.failView.refreshBlock = ^(){
        [weakSelf startRequest];
    };
}

#pragma mark - HYsegmentDelegate
- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth * index, 0) animated:NO];
    if (index == 0) {
        self.titleLB.text = @"章节";
    }else
    {
        self.titleLB.text = @"试题";
    }
}
#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = self.cateName;
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
    if ([tableView isEqual:self.simulateTableView]) {
        return 0;
    }
    return 64;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.simulateTableView]) {
        return nil;
    }
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
    
    NSDictionary *dic = [self.collectQuestionChapterInfo objectAtIndex:section];
    view.isChapter = NO;
    [view setupWithBackgroundColor:[UIColor whiteColor] titleString:[dic objectForKey:kTestChapterName] titleColor:kMainTextColor_100 titleFont:kMainFont descriptionString:[NSString stringWithFormat:@"%d/%d", writeQuestionCount, chapterQuestionCount] descriptionColor:kMainTextColor_100 descriptionFont:[UIFont systemFontOfSize:12] peopleCountString:@"" peopleCountColor:kMainTextColor_100 peopleCountFont:[UIFont systemFontOfSize:12] arrowImage:[UIImage imageNamed:@"tiku_plus"] learnImage:[UIImage imageNamed:@"tiku_text"] arrowPosition:MFoldingSectionHeaderArrowPositionLeft sectionState:state];
    view.tapDelegate = self;
    return view;
}

- (NSInteger)getChapterQuestionCount:(NSInteger)section
{
    NSDictionary *dic = [self.collectQuestionChapterInfo objectAtIndex:section];
    NSInteger count = [[dic objectForKey:kTestChapterQuestionCount] integerValue];
    return count;
}

- (NSInteger)getChapterWriteQuestionCount:(NSInteger)section
{
    NSDictionary *dic = [self.collectQuestionChapterInfo objectAtIndex:section];
    
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
    if ([self.simulateTableView isEqual:tableView]) {
        return 1;
    }
    return self.collectQuestionChapterInfo.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.simulateTableView]) {
        return self.simulateArray.count;
    }
    if (((NSNumber *)self.statusArray[section]).integerValue == MFoldingSectionStateShow) {
        NSDictionary *dic = [self.collectQuestionChapterInfo objectAtIndex:section];
        NSArray *array = [dic objectForKey:kTestChapterSectionArray];
        return array.count;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CategoryDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCategoryDetailCellId forIndexPath:indexPath];
    if ([tableView isEqual:self.simulateTableView]) {
        cell.cellType = CellType_Simulate;
        NSDictionary * dic = [self.simulateArray objectAtIndex:indexPath.row];
        NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
        [infoDic setValue:@(0) forKey:@"currentIndex"];
        NSArray * dbArray = [[DBManager sharedManager] getSimulateTestInfoWith:kDBErrorType_Collect];
        for (NSDictionary *dbDic in dbArray) {
            if ([[dic objectForKey:kTestSimulateId] isEqual:[dbDic objectForKey:kTestSimulateId]]) {
                [infoDic setValue:[dbDic objectForKey:@"currentIndex"] forKey:@"currentIndex"];
            }
        }
        
        [cell resetisLast:NO withDicInfo:infoDic];
        return cell;
    }
    
    
    NSDictionary *dic = [self.collectQuestionChapterInfo objectAtIndex:indexPath.section];
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
    cell.cellType = CellType_collect;
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
    if ([self.simulateTableView isEqual:tableView]) {
        NSDictionary * infoDic = self.simulateArray[indexPath.row];
        self.currentDBCourseInfoDic = [[NSMutableDictionary alloc]initWithDictionary:infoDic];
        [self.currentDBCourseInfoDic setObject:kDBErrorType_Collect forKey:@"type"];
        [self requestSectionQuestionsWithSectionId:[[infoDic objectForKey:kTestSimulateId] intValue]];
        
        for (NSDictionary * simuDic in [[DBManager sharedManager] getSimulateTestInfoWith:kDBErrorType_Collect]) {
            if ([[simuDic objectForKey:kTestSimulateId] isEqual:[infoDic objectForKey:kTestSimulateId]]) {
                self.currentSectionQuestionInfoDic = simuDic;
            }
        }
        
        return;
    }
    
    self.selectSection = (int)indexPath.section;
    self.selectRow = (int)indexPath.row;
    NSDictionary *dic = [self.collectQuestionChapterInfo objectAtIndex:indexPath.section];
    NSArray *array = [dic objectForKey:kTestChapterSectionArray];
    NSDictionary *secDic = [array objectAtIndex:indexPath.row];
    
    self.currentDBCourseInfoDic = [NSMutableDictionary dictionary];
    [self.currentDBCourseInfoDic setValue:@(self.courseCategoryId) forKey:kCourseID];
    [self.currentDBCourseInfoDic setValue:self.cateName forKey:kCourseName];
    [self.currentDBCourseInfoDic setObject:[dic objectForKey:kTestChapterName] forKey:kTestChapterName];
    [self.currentDBCourseInfoDic setObject:[dic objectForKey:kTestChapterId] forKey:kTestChapterId];
    [self.currentDBCourseInfoDic setObject:[dic objectForKey:kTestChapterQuestionCount] forKey:kTestChapterQuestionCount];
    [self.currentDBCourseInfoDic setObject:[secDic objectForKey:kTestSectionName] forKey:kTestSectionName];
    [self.currentDBCourseInfoDic setObject:[secDic objectForKey:kTestSectionId] forKey:kTestSectionId];
    [self.currentDBCourseInfoDic setObject:[secDic objectForKey:kTestSectionQuestionCount] forKey:kTestSectionQuestionCount];
    [self.currentDBCourseInfoDic setObject:kDBErrorType_Collect forKey:@"type"];
    
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
    [self requestSectionQuestionsWithSectionId:[[secDic objectForKey:kTestSectionId] intValue]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - YUFoldingSectionHeaderDelegate

-(void)MFoldingSectionHeaderTappedAtIndex:(NSInteger)index
{
    BOOL currentIsOpen = ((NSNumber *)self.statusArray[index]).boolValue;
    
    [self.statusArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!currentIsOpen]];
    
    NSDictionary *dic = [self.collectQuestionChapterInfo objectAtIndex:index ];
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
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithArray:rowArray] withRowAnimation:UITableViewRowAnimationTop];
        }else{
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithArray:rowArray] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
