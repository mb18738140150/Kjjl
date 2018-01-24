//
//  SimulateQuestionAnalysisViewController.m
//  Accountant
//
//  Created by aaa on 2017/4/6.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "SimulateQuestionAnalysisViewController.h"
#import "UIMacro.h"
#import "CommonMacro.h"
#import "TestManager.h"
#import "TestQuestionHeaderTableViewCell.h"
#import "TestQuestionContentTableViewCell.h"
#import "TestQuestionAnswerTableViewCell.h"
#import "TestQuestionResultTableViewCell.h"
#import "TestQuestionComplainTableViewCell.h"
#import "UIUtility.h"
#import "TestMacro.h"
#import "SVProgressHUD.h"
#import "TestQuestioncollectView.h"

@interface SimulateQuestionAnalysisViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,TestModuleQuestionCollection,TestModule_CollectQuestionProtocol,TestModule_UncollectQuestionProtocol>

@property (nonatomic,strong) UITableView            *contentTableView;

@property (nonatomic,strong) UITableView            *nextOrPreviousTableView;

@property (nonatomic,strong) NSDictionary           *questionInfoDic;
@property (nonatomic,strong) NSMutableArray         *selectedArray;

@property (nonatomic,assign) int                     totalCount;

@property (nonatomic,strong) UIButton               *nextQuestionButton;
@property (nonatomic,strong) UIButton               *previousQuestionButton;

@property (nonatomic,strong) UISwipeGestureRecognizer *leftGesture;
@property (nonatomic,strong) UISwipeGestureRecognizer *rightGesture;

@property (nonatomic, strong)TestQuestioncollectView * collectView;
@end

@implementation SimulateQuestionAnalysisViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundGrayColor;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    if (self.currentQuestionIndex && self.currentQuestionIndex > 0) {
        [[TestManager sharedManager] resetCurrentQuestionInfoswith:self.currentQuestionIndex];
    }else
    {
        [[TestManager sharedManager] resetCurrentQuestionInfos];
    }
    
    if (self.wrongQuestion) {
        self.totalCount = [[TestManager sharedManager] getTestSimulateWrongTotalCount];
    }else
    {
        self.totalCount = [[TestManager sharedManager] getTestSimulateTotalCount];
    }
    
    [self navigationViewSetup];
    [self tableViewSetup];
    [self reloadQuestionInfo];
    [self reloadCurrentTableView];
    [self setrightNavigationItem:self.questionInfoDic];
    [self addGesture];
}

- (void)addGesture
{
    _leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextQuestion)];
    _leftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.contentTableView addGestureRecognizer:_leftGesture];
    _rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousQuestion)];
    _rightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.contentTableView addGestureRecognizer:_rightGesture];
}

- (void)removeGesture
{
    [self.contentTableView removeGestureRecognizer:_leftGesture];
    [self.contentTableView removeGestureRecognizer:_rightGesture];
}

- (void)reloadQuestionInfo
{
    if (self.wrongQuestion) {
        self.questionInfoDic = [[TestManager sharedManager]getCurrentSimulateWrongQuestionInfo];
    }else
    {
        self.questionInfoDic = [[TestManager sharedManager] getCurrentSimulateQuestionInfo];
    }
    self.currentQuestionIndex = [[TestManager sharedManager] getCurrentQuestionIndex];
    
    self.selectedArray = [self.questionInfoDic objectForKey:kTestQuestionSelectedAnswers];
}

- (void)previousQuestion
{
    if (self.currentQuestionIndex != 0) {
        [[TestManager sharedManager] previousQuestion];
        [self reloadQuestionInfo];
        [self reloadNextOrPreTableView];
        self.nextOrPreviousTableView.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight);
        
        [UIView animateWithDuration:0.5 animations:^{
            self.nextOrPreviousTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight);
            self.contentTableView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight );
        } completion:^(BOOL finished) {
            [self reloadCurrentTableView];
            [self setrightNavigationItem:self.questionInfoDic];
        }];
    }
}

- (void)nextQuestion
{
    if (self.currentQuestionIndex < self.totalCount-1) {
        [[TestManager sharedManager] nextQuestion];
        [self reloadQuestionInfo];
        [self reloadNextOrPreTableView];
        self.nextOrPreviousTableView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight);
        
        [UIView animateWithDuration:0.5 animations:^{
            self.nextOrPreviousTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight);
            self.contentTableView.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight );
        } completion:^(BOOL finished) {
            [self reloadCurrentTableView];
            [self setrightNavigationItem:self.questionInfoDic];
        }];
    }
}

- (void)reloadCurrentTableView
{
    [self.contentTableView reloadData];
    self.contentTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight );
}

- (void)reloadNextOrPreTableView
{
    [self.nextOrPreviousTableView reloadData];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

- (NSString *)getSelectedAnswersIdString
{
    NSMutableString *myStr = [[NSMutableString alloc] init];
    for (NSNumber *number in self.selectedArray) {
        [myStr appendString:[NSString stringWithFormat:@"%@",number]];
    }
    return myStr;
}

- (void)addQuestionDetailHistory
{
    BOOL isCorrect;
    if ([[self.questionInfoDic objectForKey:kTestQuestionCorrectAnswersId] isEqualToString:[self getSelectedAnswersIdString]]) {
        isCorrect = YES;
    }else{
        isCorrect = NO;
    }
    NSDictionary *dic = @{kTestAddDetailHistoryLogId:@([[TestManager sharedManager] getLogId]),
                          kTestQuestionId:[self.questionInfoDic objectForKey:kTestQuestionId],
                          kTestAnserId:[self getSelectedAnswersIdString],
                          kTestQuestionResult:@(isCorrect)};
    [[TestManager sharedManager] didRequestAddTestHistoryDetailWithInfo:dic];
}

#pragma mark - delegate
- (void)didQuestionCollect
{
    [SVProgressHUD show];
    [self removeGesture];
    [[TestManager sharedManager] didRequestTestCollectQuestionWithQuestionId:[[self.questionInfoDic objectForKey:kTestQuestionId] intValue] andNotifiedObject:self];
}

- (void)didQustionUncollect
{
    [SVProgressHUD show];
    [self removeGesture];
    [[TestManager sharedManager] didRequestTestUncollectQuestionWithQuestionId:[[self.questionInfoDic objectForKey:kTestQuestionId] intValue] andNotifiedObject:self];
}

- (void)didRequestCollectQuestionSuccess
{
    [SVProgressHUD dismiss];
    [self addGesture];
    if (self.wrongQuestion) {
        [TestManager sharedManager].colectType = CollectTypeSimulateWrong;
    }else
    {
        [TestManager sharedManager].colectType = CollectTypeSimulate;
    }
    [[TestManager sharedManager] collectCurrentQuestion];
    [self reloadQuestionInfo];
    [self reloadCurrentTableView];
    [self setrightNavigationItem:self.questionInfoDic];
}

- (void)didRequestCollectQuestionFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self addGesture];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestUncollectQuestionSuccess
{
    [SVProgressHUD dismiss];
    [self addGesture];
    if (self.wrongQuestion) {
        [TestManager sharedManager].colectType = CollectTypeSimulateWrong;
    }else
    {
        [TestManager sharedManager].colectType = CollectTypeSimulate;
    }
    [[TestManager sharedManager] uncollectCurrentQuestion];
    [self reloadQuestionInfo];
    [self reloadCurrentTableView];
    [self setrightNavigationItem:self.questionInfoDic];
}

- (void)didRequestUncollectQuestionFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self addGesture];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"模拟题答案解析";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50,NSFontAttributeName:[UIFont systemFontOfSize:17]};
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"public-返回"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    
    self.collectView = [[TestQuestioncollectView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    self.collectView.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_collectView];
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setrightNavigationItem:(NSDictionary *)dic
{
    [self.collectView resetWithInfo:dic andIsShowCollect:YES];
}
- (void)tableViewSetup
{
    self.nextOrPreviousTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight ) style:UITableViewStylePlain];
    self.nextOrPreviousTableView.delegate = self;
    self.nextOrPreviousTableView.dataSource = self;
    self.nextOrPreviousTableView.bounces = NO;
    self.nextOrPreviousTableView.userInteractionEnabled = NO;
    self.nextOrPreviousTableView.backgroundColor = kBackgroundGrayColor;
    self.nextOrPreviousTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.nextOrPreviousTableView];
    
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight ) style:UITableViewStylePlain];
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    self.contentTableView.bounces = NO;
    self.contentTableView.backgroundColor = kBackgroundGrayColor;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.contentTableView];
    
    
    
}

#pragma mark - table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        TestQuestionHeaderTableViewCell *cell = (TestQuestionHeaderTableViewCell *)[UIUtility getCellWithCellName:@"testQuestionHeaderCell" inTableView:tableView andCellClass:[TestQuestionHeaderTableViewCell class]];
        cell.delegate = self;
        cell.questionCurrentIndex = self.currentQuestionIndex;
        cell.questionTotalCount = self.totalCount;
        [cell resetWithInfo:self.questionInfoDic andIsShowCollect:NO];
        return cell;
    }
    if (indexPath.section == 1) {
        TestQuestionContentTableViewCell *cell = (TestQuestionContentTableViewCell *)[UIUtility getCellWithCellName:@"testContentCell" inTableView:tableView andCellClass:[TestQuestionContentTableViewCell class]];
        cell.questionCurrentIndex = self.currentQuestionIndex;
        cell.questionTotalCount = self.totalCount;
        [cell resetWithInfo:self.questionInfoDic];
        return cell;
    }
    if (indexPath.section == 2) {
        TestQuestionAnswerTableViewCell *cell = (TestQuestionAnswerTableViewCell *)[UIUtility getCellWithCellName:@"testAnswerCell" inTableView:tableView andCellClass:[TestQuestionAnswerTableViewCell class]];
        NSArray *array = [self.questionInfoDic objectForKey:kTestQuestionAnswers];
        NSDictionary *infoDic = [array objectAtIndex:indexPath.row];
        BOOL isSelect = NO;
        NSString *answerId = [infoDic objectForKey:kTestAnserId];
        if ([self.selectedArray containsObject:answerId]) {
            isSelect = YES;
        }
        
        [cell resetWithInfo:infoDic andIsSelect:isSelect];
        return cell;
    }
    if (indexPath.section == 3) {
        TestQuestionResultTableViewCell *cell = (TestQuestionResultTableViewCell *)[UIUtility getCellWithCellName:@"testResultCell" inTableView:tableView andCellClass:[TestQuestionResultTableViewCell class]];
        cell.backgroundColor = kBackgroundGrayColor;
        [cell resetWithInfo:self.questionInfoDic];
        return cell;
    }
    if (indexPath.section == 4){
        TestQuestionComplainTableViewCell *cell = (TestQuestionComplainTableViewCell *)[UIUtility getCellWithCellName:@"testComplainCell" inTableView:tableView andCellClass:[TestQuestionComplainTableViewCell class]];
        [cell resetWithInfo:self.questionInfoDic];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 10;
    }
    if (indexPath.section == 1) {
        UIFont *font = kMainFont;
        
        CGFloat height = [UIUtility getSpaceLabelHeght:[self.questionInfoDic objectForKey:kTestQuestionContent] font:font width:(kScreenWidth - 40)];
        return height + 30 + 10;
    }
    if (indexPath.section == 2) {
        
        NSArray *array = [self.questionInfoDic objectForKey:kTestQuestionAnswers];
        NSDictionary *infoDic = [array objectAtIndex:indexPath.row];
        CGFloat minHeight = kHeightOfTestQuestionAnswer;
        UIFont *font = kMainFont;
        CGFloat height = [UIUtility getHeightWithText:[infoDic objectForKey:kTestAnswerContent] font:font width:kScreenWidth - 80];
        
        if (height < minHeight) {
            height = minHeight;
        }
        return height + 10;
    }
    if (indexPath.section == 3) {
        //        return kHeightOfTestMyAnswer;
        return 50;
        
    }
    if (indexPath.section == 4) {
        NSString *str = [self.questionInfoDic objectForKey:kTestQuestionComplain];
        UIFont *font = kMainFont;
        CGFloat height = [UIUtility getSpaceLabelHeght:str font:font width:(kScreenWidth - 40)];
        return height + 30 + 20;
    }
    if (indexPath.section == 5) {
        return kHeightOfTestNextQuestionCell;
    }
    
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        NSArray *answers = [self.questionInfoDic objectForKey:kTestQuestionAnswers];
        return answers.count;
    }
    if (section == 3) {
        return 1;
    }
    if (section == 4) {
        return 1;
    }
    if (section == 5) {
        return 1;
    }
    return 0;
    
}



@end
