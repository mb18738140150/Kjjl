//
//  TestChapterQuestionViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/22.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestChapterQuestionViewController.h"
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

#define bottomButtonwidht (kScreenWidth-3) / 3
#define bottomButtonHeight kTabBarHeight - 1

@interface TestChapterQuestionViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,TestModuleQuestionCollection,TestModule_CollectQuestionProtocol,TestModule_UncollectQuestionProtocol>

@property (nonatomic,strong) UITableView            *contentTableView;

@property (nonatomic,strong) UITableView            *nextOrPreviousTableView;

@property (nonatomic,assign) BOOL                    isShowAnswer;

@property (nonatomic,strong) NSDictionary           *questionInfoDic;

@property (nonatomic,strong) NSMutableArray         *selectedArray;

@property (nonatomic,assign) int                     currentQuestionIndex;
@property (nonatomic,assign) int                     totalCount;

@property (nonatomic,strong) UIButton               *nextQuestionButton;
@property (nonatomic,strong) UIButton               *previousQuestionButton;

@property (nonatomic,strong) UIButton               *submitButton;
@property (nonatomic,strong) UISwipeGestureRecognizer *leftGesture;
@property (nonatomic,strong) UISwipeGestureRecognizer *rightGesture;

@property (nonatomic,strong) UIView                 *bottomMenuView;

//单选判断  点击选项就显示答案
@property (nonatomic,assign) BOOL                    isClickShowAnswer;

@property (nonatomic, strong)TestQuestioncollectView * collectView;

@end

@implementation TestChapterQuestionViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundGrayColor;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self resetquestionInfo];
    
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


- (void)resetquestionInfo
{
    
    NSDictionary * infoDic = self.currentsectionQuestionInfoDic;
    
    if (infoDic) {
        
        NSArray * questionsArr = [infoDic objectForKey:@"questionsStr"];
        for (int i = 0; i < questionsArr.count; i++) {
            NSDictionary * quesrionInfoDic = [questionsArr objectAtIndex:i];
            NSMutableArray * selectArr = [quesrionInfoDic objectForKey:kTestQuestionSelectedAnswers];
            
            [[TestManager sharedManager] submitAnswers:selectArr andQuestionIndex:i];
        }
        
        self.totalCount = [[TestManager sharedManager] getTestSectionTotalCount];
        if (self.totalCount == [[infoDic objectForKey:@"currentIndex"] intValue]) {
            [[TestManager sharedManager]resetCurrentQuestionInfos];
        }else
        {
            [[TestManager sharedManager] resetCurrentQuestionInfoswith:[[infoDic objectForKey:@"currentIndex"] intValue]];
        }
    }else
    {
        [[TestManager sharedManager] resetCurrentQuestionInfos];
        self.totalCount = [[TestManager sharedManager] getTestSectionTotalCount];
    }
}

- (void)submitQuestion
{
    if (self.selectedArray.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先选择答案" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self.selectedArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSNumber *num1 = obj1;
        NSNumber *num2 = obj2;
        NSComparisonResult result = [num1 compare:num2];
        return result == NSOrderedDescending;
    }];
    
    [[TestManager sharedManager] submitAnswers:self.selectedArray andQuestionIndex:self.currentQuestionIndex];
    [self addQuestionDetailHistory];
    NSMutableString *myStr = [[NSMutableString alloc] init];
    for (NSNumber *number in self.selectedArray) {
        [myStr appendString:[NSString stringWithFormat:@"%@",number]];
    }
    
    if (![myStr isEqualToString:[self.questionInfoDic objectForKey:kTestQuestionCorrectAnswersId]]) {
        [[TestManager sharedManager] didRequestTestAddMyWrongQuestionWithQuestionId:[[self.questionInfoDic objectForKey:kTestQuestionId] intValue]];
    }
    
    [self reloadQuestionInfo];
    [self reloadCurrentTableView];
}

- (void)showQuestionAnswer
{
    [[TestManager sharedManager] showQuestionAnswerWithQuestionIndex:self.currentQuestionIndex];
    [self reloadQuestionInfo];
    [self reloadCurrentTableView];
}

- (void)reloadQuestionInfo
{
    self.questionInfoDic = [[TestManager sharedManager] getCurrentSectionQuestionInfo];
    self.currentQuestionIndex = [[TestManager sharedManager] getCurrentQuestionIndex];
    
    NSString *type = [self.questionInfoDic objectForKey:kTestQuestionType];
    if ([type isEqualToString:@"单选"] || [type isEqualToString:@"判断"]) {
        self.isClickShowAnswer = YES;
    }else{
        self.isClickShowAnswer = NO;
    }
    
    self.isShowAnswer = [[self.questionInfoDic objectForKey:kTestQuestionIsShowAnswer] boolValue];
    
    if ([[self.questionInfoDic objectForKey:kTestQuestionIsAnswered] boolValue]) {
        self.selectedArray = [[self.questionInfoDic objectForKey:kTestQuestionSelectedAnswers] mutableCopy];
    }else{
        self.selectedArray = [[NSMutableArray alloc] init];
    }
    
}

- (void)previousQuestion
{
    if (self.currentQuestionIndex != 0) {
        [[TestManager sharedManager] previousQuestion];
        [self reloadQuestionInfo];
        [self reloadNextOrPreTableView];
        self.nextOrPreviousTableView.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight);
        
        [UIView animateWithDuration:0.5 animations:^{
            self.nextOrPreviousTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight);
            self.contentTableView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight);
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
        self.nextOrPreviousTableView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight);
        
        [UIView animateWithDuration:0.5 animations:^{
            self.nextOrPreviousTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight);
            self.contentTableView.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight);
        } completion:^(BOOL finished) {
            [self reloadCurrentTableView];
            [self setrightNavigationItem:self.questionInfoDic];
        }];
    }
}


- (void)reloadCurrentTableView
{
    [self.contentTableView reloadData];
    self.contentTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight);
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
    [TestManager sharedManager].colectType = CollectTypeTest;
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
    [TestManager sharedManager].colectType = CollectTypeTest;
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
    if (self.questionType == TestQuestionTypeError) {
        self.navigationItem.title = @"易错题";
    }
    if (self.questionType == TestQuestionTypeChapter) {
        self.navigationItem.title = @"章节练习";
    }
    if (self.questionType == TestQuestionTypeMyWrong) {
        self.navigationItem.title = @"我的错题";
    }
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50,NSFontAttributeName:[UIFont systemFontOfSize:17]};
    
    //    self.collectView = [[TestQuestioncollectView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    //    self.collectView.delegate = self;
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_collectView];
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"public-返回"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
}
- (void)backAction:(UIButton *)button
{
    
    switch (self.questionType) {
        case TestQuestionTypeChapter:
            [self saveChapter];
            break;
        case TestQuestionTypeMyWrong:
            [self saveMyWrong];
            break;
        case TestQuestionTypeError:
            [self saveEasyError];
            break;
        case TestQuestionTypeCollect:
            [self saveCollect];
            break;
        default:
            break;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setrightNavigationItem:(NSDictionary *)dic
{
    [self.collectView resettitleWithInfo:dic andIsShowCollect:YES];
}

- (void)tableViewSetup
{
    self.nextOrPreviousTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight) style:UITableViewStylePlain];
    self.nextOrPreviousTableView.delegate = self;
    self.nextOrPreviousTableView.dataSource = self;
    self.nextOrPreviousTableView.bounces = NO;
    self.nextOrPreviousTableView.userInteractionEnabled = NO;
    self.nextOrPreviousTableView.backgroundColor = kBackgroundGrayColor;
    self.nextOrPreviousTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.nextOrPreviousTableView];
    
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight) style:UITableViewStylePlain];
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    self.contentTableView.bounces = NO;
    self.contentTableView.backgroundColor = kBackgroundGrayColor;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.contentTableView];
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitButton setTitleColor:kCommonMainColor forState:UIControlStateNormal];
    [self.submitButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(submitQuestion) forControlEvents:UIControlEventTouchUpInside];
    self.submitButton.frame = CGRectMake(kScreenWidth / 2 - 50, 5, 100, 40);
    //    [self.view addSubview:self.submitButton];
    self.submitButton.layer.cornerRadius = 3;
    self.submitButton.layer.masksToBounds = YES;
    self.submitButton.layer.borderColor = kTableViewCellSeparatorColor.CGColor;
    self.submitButton.layer.borderWidth = 1;
    
    
    self.bottomMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kStatusBarHeight - kNavigationBarHeight - kTabBarHeight, kScreenWidth, kTabBarHeight)];
    self.bottomMenuView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomMenuView];
    
    self.collectView = [[TestQuestioncollectView alloc]initWithFrame:CGRectMake(0, 0, bottomButtonwidht, bottomButtonHeight)];
    self.collectView.delegate = self;
    [self.bottomMenuView addSubview:self.collectView];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.collectView.frame), 10, 1, kTabBarHeight - 20)];
    lineView2.backgroundColor = [UIColor whiteColor];
    [self.bottomMenuView addSubview:lineView2];
    
    //    self.timeLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(lineView2.frame), 0, bottomButtonwidht, bottomButtonHeight);
    //    [self.timeLabel setImage:[UIImage imageNamed:@"放大镜(1)"] forState:UIControlStateNormal];
    //    [self.timeLabel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //    [self.timeLabel setTitle:@"00:00" forState:UIControlStateNormal] ;
    //    self.timeLabel.titleLabel.font = kMainFont;
    //    [self.timeLabel setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    //    [self.bottomMenuView addSubview:self.timeLabel];
    
    //    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.timeLabel.frame), 10, 1, kTabBarHeight - 20)];
    //    lineView3.backgroundColor = kCommonNavigationBarColor;
    //    [self.bottomMenuView addSubview:lineView3];
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(kScreenWidth - bottomButtonwidht, 0, bottomButtonwidht, bottomButtonHeight);
    [btn1 setImage:[UIImage imageNamed:@"放大镜(1)"] forState:UIControlStateNormal];
    [btn1 setTitle:@"解析" forState:UIControlStateNormal];
    btn1.titleLabel.font = kMainFont;
    [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btn1 addTarget:self action:@selector(didShowAnsersCard) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomMenuView addSubview:btn1];
    
}

- (void)didShowAnsersCard
{
    [self showQuestionAnswer];
}

#pragma mark - table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isShowAnswer) {
        return 5;
    }
    if (!self.isShowAnswer) {
        return 4;
    }
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (!self.isShowAnswer) {
        if (indexPath.section == 2) {
            NSArray *array = [self.questionInfoDic objectForKey:kTestQuestionAnswers];
            NSDictionary *infoDic = [array objectAtIndex:indexPath.row];
            NSString *answerId = [infoDic objectForKey:kTestAnserId];
            if ([self.selectedArray containsObject:answerId]) {
                [self.selectedArray removeObject:answerId];
            }else{
                [self.selectedArray addObject:answerId];
            }
            if (self.isClickShowAnswer) {
                [self.selectedArray removeAllObjects];
                [self.selectedArray addObject:answerId];
            }else{
                
            }
            [self submitQuestion];
            [tableView reloadData];
        }
        
    }
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
    if (!self.isShowAnswer) {
        if (indexPath.section == 3) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nextQuestionCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nextQuestionCell"];
            }
            cell.backgroundColor = kBackgroundGrayColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //            [self.submitButton removeFromSuperview];
            //            if (!self.isShowAnswer) {
            //                if (!self.isClickShowAnswer) {
            //                    [cell addSubview:self.submitButton];
            //                }
            //            }
            return cell;
        }
    }else{
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
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 10;
    }
    if (indexPath.section == 1) {
        UIFont *font = [UIFont systemFontOfSize:17];
        
        CGFloat height = [UIUtility getSpaceLabelHeght:[self.questionInfoDic objectForKey:kTestQuestionContent] font:kMainFont width:(kScreenWidth - 40)];
        return height + 30 + 10;
    }
    if (indexPath.section == 2) {
        
        NSArray *array = [self.questionInfoDic objectForKey:kTestQuestionAnswers];
        NSDictionary *infoDic = [array objectAtIndex:indexPath.row];
        CGFloat minHeight = kHeightOfTestQuestionAnswer;
        CGFloat height = [UIUtility getHeightWithText:[infoDic objectForKey:kTestAnswerContent] font:kMainFont width:kScreenWidth - 80];
        
        if (height < minHeight) {
            height = minHeight;
        }
        return height + 10;
    }
    if (indexPath.section == 3) {
        if (self.isShowAnswer) {
            return 50;
        }else{
            return kHeightOfTestNextQuestionCell;
        }
    }
    if (indexPath.section == 4) {
        NSString *str = [self.questionInfoDic objectForKey:kTestQuestionComplain];
        CGFloat height = [UIUtility getSpaceLabelHeght:str font:kMainFont width:(kScreenWidth - 40)];
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
#pragma mark - 保存已做题信息到数据库
- (void)saveChapter
{
    NSDate *date = [NSDate date];
    [self.currentDBourseInfoDic setObject:@([date timeIntervalSince1970]) forKey:@"time"];
    
    NSArray * array = [NSArray array];
    if (self.selectedArray.count > 0) {
        array = [[TestManager sharedManager]getCurrentWriteTestQuestions:YES];
        [self.currentDBourseInfoDic setObject:@(self.currentQuestionIndex + 1) forKey:@"currentIndex"];
    }else
    {
        array = [[TestManager sharedManager]getCurrentWriteTestQuestions:NO];
        [self.currentDBourseInfoDic setObject:@(self.currentQuestionIndex) forKey:@"currentIndex"];
    }
    
    if (self.currentQuestionIndex + 1 == self.totalCount && self.selectedArray.count > 0) {
        array = [NSArray array];
    }
    
    [self.currentDBourseInfoDic setObject:[array JSONString] forKey:@"questionsStr"];
    
    [[DBManager sharedManager] saveTestCourseInfo:self.currentDBourseInfoDic];
}

- (void)saveMyWrong
{
    NSDate *date = [NSDate date];
    [self.currentDBourseInfoDic setObject:@([date timeIntervalSince1970]) forKey:@"time"];
    
    NSArray * array = [NSArray array];
    if (self.selectedArray.count > 0) {
        array = [[TestManager sharedManager]getCurrentWriteTestQuestions:YES];
        [self.currentDBourseInfoDic setObject:@(self.currentQuestionIndex + 1) forKey:@"currentIndex"];
    }else
    {
        array = [[TestManager sharedManager]getCurrentWriteTestQuestions:NO];
        [self.currentDBourseInfoDic setObject:@(self.currentQuestionIndex) forKey:@"currentIndex"];
    }
    
    if (self.currentQuestionIndex + 1 == self.totalCount && self.selectedArray.count > 0) {
        array = [NSArray array];
    }
    [self.currentDBourseInfoDic setObject:[array JSONString] forKey:@"questionsStr"];
    
    [[DBManager sharedManager] saveMyWrongTestCourseInfo:self.currentDBourseInfoDic];
}

- (void)saveEasyError
{
    NSDate *date = [NSDate date];
    [self.currentDBourseInfoDic setObject:@([date timeIntervalSince1970]) forKey:@"time"];
    
    NSArray * array = [NSArray array];
    if (self.selectedArray.count > 0) {
        array = [[TestManager sharedManager]getCurrentWriteTestQuestions:YES];
        [self.currentDBourseInfoDic setObject:@(self.currentQuestionIndex + 1) forKey:@"currentIndex"];
    }else
    {
        array = [[TestManager sharedManager]getCurrentWriteTestQuestions:NO];
        [self.currentDBourseInfoDic setObject:@(self.currentQuestionIndex) forKey:@"currentIndex"];
    }
    
    if (self.currentQuestionIndex + 1 == self.totalCount && self.selectedArray.count > 0) {
        array = [NSArray array];
    }
    [self.currentDBourseInfoDic setObject:[array JSONString] forKey:@"questionsStr"];
    
    
    [[DBManager sharedManager] saveMyWrongTestCourseInfo:self.currentDBourseInfoDic];
}

- (void)saveCollect
{
    NSDate *date = [NSDate date];
    [self.currentDBourseInfoDic setObject:@([date timeIntervalSince1970]) forKey:@"time"];
    
    NSArray * array = [NSArray array];
    if (self.selectedArray.count > 0) {
        array = [[TestManager sharedManager]getCurrentWriteTestQuestions:YES];
        [self.currentDBourseInfoDic setObject:@(self.currentQuestionIndex + 1) forKey:@"currentIndex"];
    }else
    {
        array = [[TestManager sharedManager]getCurrentWriteTestQuestions:NO];
        [self.currentDBourseInfoDic setObject:@(self.currentQuestionIndex) forKey:@"currentIndex"];
    }
    
    if (self.currentQuestionIndex + 1 == self.totalCount && self.selectedArray.count > 0) {
        array = [NSArray array];
    }
    [self.currentDBourseInfoDic setObject:[array JSONString] forKey:@"questionsStr"];
    
    
    [[DBManager sharedManager] saveMyWrongTestCourseInfo:self.currentDBourseInfoDic];
}

@end
