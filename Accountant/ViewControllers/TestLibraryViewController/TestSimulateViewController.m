//
//  TestSimulateViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestSimulateViewController.h"
#import "TestManager.h"
#import "MJRefresh.h"
#import "SectionListTableViewCell.h"
#import "TestChapterQuestionViewController.h"
#import "TestSimulateQuestionViewController.h"
#import "TestSimulateListTableViewCell.h"

@interface TestSimulateViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TestModule_SimulateInfoProtocol,TestModule_SimulateQuestionProtocol,UIGestureRecognizerDelegate,TestModule_AddHistoryProtocol>

@property (nonatomic,strong) UICollectionView                            *simulateTableView;
@property (nonatomic,strong) NSArray                                *testSimulateInfoArray;
@property (nonatomic,assign) int                                     selectedRow;
@property (nonatomic, strong)FailView * failView;
@property (nonatomic, assign)int logId;

@end

@implementation TestSimulateViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationViewSetup];
    [self tableViewsSetup];
    [self requestSimulateInfo];
}

- (void)requestSimulateInfo
{
    [SVProgressHUD show];
    [[TestManager sharedManager] didRequestTestSimulateInfoWithCategoryId:self.cateId andNotifiedObject:self];
}

- (void)requestSimulateQuestionWithId:(int)testId
{
    [SVProgressHUD show];
    [[TestManager sharedManager] didRequestTestSimulateQuestionWithTestId:testId andNotifiedObject:self];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer
                                      *)gestureRecognizer{
    return YES; //YES：允许右滑返回  NO：禁止右滑返回
}

- (void)addHistory
{
    NSDictionary *dic = [self.testSimulateInfoArray objectAtIndex:self.selectedRow];
    NSDictionary *d = @{kLID:@(self.lid),
                        kKID:@(self.cateId),
                        kTestSimulateId:@([[dic objectForKey:kTestSimulateId] intValue]),
                        kTestChapterId:@(0),
                        kTestSectionId:@(0),
                        kLogName:@"模拟测试"};
    [[TestManager sharedManager] didRequestAddTestHistoryWithInfo:d  andNotifiedObject:self];
}

- (void)didRequestAddHistorySuccess
{
    NSDictionary *dic = [self.testSimulateInfoArray objectAtIndex:self.selectedRow];
    self.logId = [[TestManager sharedManager] getLogId];
    [self startAnswer:dic];
}
- (void)didRequestAddHistoryFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.simulateTableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - delegate
- (void)didRequestSimulateInfoSuccess
{
    [SVProgressHUD dismiss];
    [self.simulateTableView.mj_header endRefreshing];
    self.testSimulateInfoArray = [[TestManager sharedManager] getSimulateInfoArray];
    
    
    if (self.testSimulateInfoArray.count == 0) {
        self.failView.failType = FailType_NoData;
    }
    [self.simulateTableView reloadData];
}

- (void)didRequestSimulateInfoFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.simulateTableView.mj_header endRefreshing];
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

- (void)didRequestSimulateQuestionSuccess
{
    [SVProgressHUD dismiss];
    TestSimulateQuestionViewController *vc = [[TestSimulateQuestionViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.logId = self.logId;
    NSDictionary * dic = [self.testSimulateInfoArray objectAtIndex:self.selectedRow];
    vc.infoDic = dic;
    vc.cateName = self.cateName;
    vc.cateId = self.cateId;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didRequestSimulateQuestionFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - table delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.testSimulateInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TestSimulateListTableViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"simulateCell" forIndexPath:indexPath];
    
    NSDictionary *dic = [self.testSimulateInfoArray objectAtIndex:indexPath.row];
    [cell resetContentWithInfo:dic withItem:indexPath.item];
    
    __weak TestSimulateViewController * weakSelf = self;
    cell.StartAnswer = ^{
        weakSelf.selectedRow = indexPath.item;
        [weakSelf.simulateTableView deselectItemAtIndexPath:indexPath animated:YES];
        [weakSelf addHistory];
    };
    
    return cell;
}

- (void)startAnswer:(NSDictionary *)dic
{
    
    [self requestSimulateQuestionWithId:[[dic objectForKey:kTestSimulateId] intValue]];
    
}

#pragma mark - ui

- (void)navigationViewSetup
{
    self.navigationItem.title = @"模拟练习";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50,NSFontAttributeName:[UIFont systemFontOfSize:17]};
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"public-返回"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tableViewsSetup
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(kScreenWidth / 2 - 1, kScreenWidth / 3 * 1.2 + 70);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.simulateTableView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight) collectionViewLayout:layout];
    self.simulateTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestSimulateInfo)];
    self.simulateTableView.backgroundColor = kBackgroundGrayColor;
    [self.simulateTableView registerClass:[TestSimulateListTableViewCell class] forCellWithReuseIdentifier:@"simulateCell"];
    self.simulateTableView.delegate = self;
    self.simulateTableView.dataSource = self;
    [self.view addSubview:self.simulateTableView];
    
    self.failView = [[FailView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight)];
    [self.view addSubview:self.failView];
    self.failView.hidden = YES;
    __weak TestSimulateViewController *weakSelf = self;
    self.failView.refreshBlock = ^(){
        [weakSelf requestSimulateInfo];
    };
    
}
@end
