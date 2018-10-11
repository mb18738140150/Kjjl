//
//  AnswersCardViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/30.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "AnswersCardViewController.h"
#import "UIMacro.h"
#import "CommonMacro.h"
#import "NotificaitonMacro.h"
#import "AnswerCardAnswerCollectionViewCell.h"
#import "AnswerCardHeaderCollectionViewCell.h"
#import "AnswerCardFooterCollectionViewCell.h"
#import "TestManager.h"
#import "SVProgressHUD.h"
#import "SimulateResultViewController.h"
#import "SimulateresultCollectionReusableView.h"

@interface AnswersCardViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>

@property (nonatomic,strong) UICollectionView                   *collectView;
@property (nonatomic,strong) UICollectionViewFlowLayout         *flowLayout;

@property (nonatomic,strong) NSDictionary                            *dataDic;
@property (nonatomic, strong)NSMutableArray                          *dataArray;

@property (nonatomic, copy)SubmitBlock myBlock;

@property (nonatomic,strong)UIButton * bottomMenuView;

@end

@implementation AnswersCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataDic = [NSDictionary dictionary];

    self.dataArray = [NSMutableArray array];
    
    self.dataDic = [[TestManager sharedManager]getSimulateresult];
    self.dataArray = [self.dataDic objectForKey:kDataArray];
    
    
    [self navigationViewSetup];
    [self contentViewSetup];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(submitResult:) name:kNotificationOfsubmitSimulateResult object:nil];
    
    //    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    //    self.navigationItem.rightBarButtonItem = item;
}

- (void)submitResult:(NSNotification *)notification
{
    [SVProgressHUD dismiss];
    NSNumber *time = [notification.userInfo objectForKey:@"time"];
    SimulateResultViewController * simulateresultVC = [[SimulateResultViewController alloc]init];
    simulateresultVC.time = time;
    simulateresultVC.cateName = self.cateName;
    simulateresultVC.cateId = self.cateId;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:simulateresultVC animated:YES];
}

- (void)submiteBlock:(SubmitBlock)block
{
    self.myBlock = [block copy];
}

#pragma mark
- (void)submit
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定提交试卷？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    alert.tag = 1000;
    
}

- (void)showResult
{
    [SVProgressHUD dismiss];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            [self performSelector:@selector(showResult) withObject:nil afterDelay:1];
            if (self.myBlock) {
                self.myBlock();
            }
        }
    }
}

#pragma mark - collect view delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, 20);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AnswerCardAnswerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"answerCardAnswerCell" forIndexPath:indexPath];
    
     [cell resetCellWithInfo:self.dataArray[indexPath.section][indexPath.row]];
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        
        SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
        NSDictionary * questionInfoDic = [self.dataArray[indexPath.section] objectAtIndex:0];
        [headview resetWithTitle:[questionInfoDic objectForKey:kTestQuestionType]];
        reusableview = headview;
    }
    return reusableview;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = kScreenWidth/6-1;
    if (IS_PAD) {
        width = kScreenWidth/14-1;
    }
    return CGSizeMake(width, width);
}

- (void)dissmiss
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)contentViewSetup
{
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing= 0;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight -kTabBarHeight) collectionViewLayout:self.flowLayout];
    [self.collectView registerClass:[AnswerCardAnswerCollectionViewCell class] forCellWithReuseIdentifier:@"answerCardAnswerCell"];
    [self.collectView registerClass:[AnswerCardFooterCollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"answerCardFooterCell"];
    [self.collectView registerClass:[SimulateresultCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid"];
    
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    self.collectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectView];
    self.view.backgroundColor = UIRGBColor(240, 240, 240);
    
    self.bottomMenuView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bottomMenuView.frame = CGRectMake(0, kScreenHeight-kStatusBarHeight - kNavigationBarHeight - kTabBarHeight, kScreenWidth, kTabBarHeight);
    self.bottomMenuView.backgroundColor = kCommonMainColor;
    [self.bottomMenuView setTitle:@"交卷并查看结果" forState:UIControlStateNormal];
    [self.bottomMenuView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bottomMenuView addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomMenuView];
    
}

- (void)navigationViewSetup
{
    self.navigationItem.title = @"答题卡";
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

- (void)dealloc
{
}

@end
