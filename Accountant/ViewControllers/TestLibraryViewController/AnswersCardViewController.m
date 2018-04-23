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
@property (nonatomic, strong)NSMutableArray * singleArr;
@property (nonatomic, strong)NSMutableArray * mutipleArr;
@property (nonatomic, strong)NSMutableArray * judgeQuestionArr;
@property (nonatomic, strong)NSMutableArray * materailArr;
@property (nonatomic, strong)NSMutableArray * jiandaArr;
@property (nonatomic, strong)NSMutableArray * analisisArr;
@property (nonatomic, strong)NSMutableArray * zongheArr;

@property (nonatomic, copy)SubmitBlock myBlock;

@property (nonatomic,strong)UIButton * bottomMenuView;

@end

@implementation AnswersCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataDic = [NSDictionary dictionary];
    self.singleArr = [NSMutableArray array];
    self.mutipleArr = [NSMutableArray array];
    self.judgeQuestionArr = [NSMutableArray array];
    self.materailArr = [NSMutableArray array];
    self.jiandaArr = [NSMutableArray array];
    self.analisisArr = [NSMutableArray array];
    self.zongheArr = [NSMutableArray array];
    
    self.dataDic = [[TestManager sharedManager]getSimulateresult];
    self.singleArr = [self.dataDic objectForKey:kSinglequistionArr];
    self.mutipleArr = [self.dataDic objectForKey:kMultiplequistionArr];
    self.judgeQuestionArr = [self.dataDic objectForKey:kJudgequistionArr];
    self.materailArr = [self.dataDic objectForKey:kMaterailQuestionArray];
    self.jiandaArr = [self.dataDic objectForKey:kJiandaQuestionArray];
    self.analisisArr = [self.dataDic objectForKey:kAnalisisQuestionArray];
    self.zongheArr = [self.dataDic objectForKey:kZongheQuestionArray];
    
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
    int number = 0;
    if ([[self.dataDic objectForKey:kSinglequistionArr] count] > 0) {
        number++;
    }
    if([[self.dataDic objectForKey:kMultiplequistionArr] count] > 0)
    {
        number++;
    }
    if([[self.dataDic objectForKey:kJudgequistionArr] count] > 0)
    {
        number++;
    }
    if([self.materailArr count] > 0)
    {
        number++;
    }
    if([[self.dataDic objectForKey:kJiandaQuestionArray] count] > 0)
    {
        number++;
    }
    if([[self.dataDic objectForKey:kAnalisisQuestionArray] count] > 0)
    {
        number++;
    }
    if([[self.dataDic objectForKey:kZongheQuestionArray] count] > 0)
    {
        number++;
    }
    return number;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        if ([self.singleArr count] > 0) {
            return [[self.dataDic objectForKey:kSinglequistionArr] count];
        }else if([self.mutipleArr count] > 0)
        {
            return [[self.dataDic objectForKey:kMultiplequistionArr] count];
        }else if([self.judgeQuestionArr count] > 0)
        {
            return [[self.dataDic objectForKey:kJudgequistionArr] count];
        }else if([self.materailArr count] > 0)
        {
            return [self.materailArr count];
        }
        else if([self.jiandaArr count] > 0)
        {
            return [self.jiandaArr count];
        }
        else if([self.analisisArr count] > 0)
        {
            return [self.analisisArr count];
        }
        else if([self.zongheArr count] > 0)
        {
            return [self.zongheArr count];
        }
        else
        {
            return 0;
        }
    }else if (section == 1)
    {
        if([[self.dataDic objectForKey:kMultiplequistionArr] count] > 0)
        {
            return [[self.dataDic objectForKey:kMultiplequistionArr] count];
        }else if([[self.dataDic objectForKey:kJudgequistionArr] count] > 0)
        {
            return [[self.dataDic objectForKey:kJudgequistionArr] count];
        }
        else if([self.materailArr count] > 0)
        {
            return [self.materailArr count];
        }
        else if([self.jiandaArr count] > 0)
        {
            return [self.jiandaArr count];
        }
        else if([self.analisisArr count] > 0)
        {
            return [self.analisisArr count];
        }
        else if([self.zongheArr count] > 0)
        {
            return [self.zongheArr count];
        }
        else
        {
            return 0;
        }
    }else if (section == 2)
    {
        if([[self.dataDic objectForKey:kJudgequistionArr] count] > 0)
        {
            return [[self.dataDic objectForKey:kJudgequistionArr] count];
        }
        else if([self.materailArr count] > 0)
        {
            return [self.materailArr count];
        }
        else if([self.jiandaArr count] > 0)
        {
            return [self.jiandaArr count];
        }
        else if([self.analisisArr count] > 0)
        {
            return [self.analisisArr count];
        }
        else if([self.zongheArr count] > 0)
        {
            return [self.zongheArr count];
        }
        else
        {
            return 0;
        }
    }
    else if (section == 3)
    {
        if([self.materailArr count] > 0)
        {
            return [self.materailArr count];
        }
        else if([self.jiandaArr count] > 0)
        {
            return [self.jiandaArr count];
        }
        else if([self.analisisArr count] > 0)
        {
            return [self.analisisArr count];
        }
        else if([self.zongheArr count] > 0)
        {
            return [self.zongheArr count];
        }
        else
        {
            return 0;
        }
    }
    else if (section == 4)
    {
         if([self.jiandaArr count] > 0)
        {
            return [self.jiandaArr count];
        }
        else if([self.analisisArr count] > 0)
        {
            return [self.analisisArr count];
        }
        else if([self.zongheArr count] > 0)
        {
            return [self.zongheArr count];
        }
        else
        {
            return 0;
        }
    }
    else if (section == 5)
    {
        if([self.analisisArr count] > 0)
        {
            return [self.analisisArr count];
        }
        else if([self.zongheArr count] > 0)
        {
            return [self.zongheArr count];
        }
        else
        {
            return 0;
        }
    }
    else if (section == 6)
    {
        return [self.zongheArr count];
    }
    else
    {
        return 0;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, 20);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AnswerCardAnswerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"answerCardAnswerCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if ([[self.dataDic objectForKey:kSinglequistionArr] count] > 0) {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kSinglequistionArr] objectAtIndex:indexPath.row]];
            
        }else if([[self.dataDic objectForKey:kMultiplequistionArr] count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kMultiplequistionArr] objectAtIndex:indexPath.row]];
            
        }else if([[self.dataDic objectForKey:kJudgequistionArr] count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kJudgequistionArr] objectAtIndex:indexPath.row]];
        }else if([self.materailArr count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kMaterailQuestionArray] objectAtIndex:indexPath.row]];
        }
        else if([self.jiandaArr count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kJiandaQuestionArray] objectAtIndex:indexPath.row]];
        }
        else if([self.analisisArr count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kAnalisisQuestionArray] objectAtIndex:indexPath.row]];
        }
        else if([self.zongheArr count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kZongheQuestionArray] objectAtIndex:indexPath.row]];
        }
    }else if (indexPath.section == 1)
    {
        if([[self.dataDic objectForKey:kSinglequistionArr] count] > 0 && [[self.dataDic objectForKey:kMultiplequistionArr] count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kMultiplequistionArr] objectAtIndex:indexPath.row]];
            
        }else if([[self.dataDic objectForKey:kJudgequistionArr] count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kJudgequistionArr] objectAtIndex:indexPath.row]];
        }else if([self.materailArr count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kMaterailQuestionArray] objectAtIndex:indexPath.row]];
        }
        else if([self.jiandaArr count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kJiandaQuestionArray] objectAtIndex:indexPath.row]];
        }
        else if([self.analisisArr count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kAnalisisQuestionArray] objectAtIndex:indexPath.row]];
        }
        else if([self.zongheArr count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kZongheQuestionArray] objectAtIndex:indexPath.row]];
        }
    }else if (indexPath.section == 2)
    {
        if([[self.dataDic objectForKey:kJudgequistionArr] count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kJudgequistionArr] objectAtIndex:indexPath.row]];
            
        }else if([self.materailArr count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kMaterailQuestionArray] objectAtIndex:indexPath.row]];
        }
        else if([self.jiandaArr count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kJiandaQuestionArray] objectAtIndex:indexPath.row]];
        }
        else if([self.analisisArr count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kAnalisisQuestionArray] objectAtIndex:indexPath.row]];
        }
        else if([self.zongheArr count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kZongheQuestionArray] objectAtIndex:indexPath.row]];
        }
    }else if (indexPath.section == 3)
    {
        if([self.materailArr count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kMaterailQuestionArray] objectAtIndex:indexPath.row]];
        }
        else if([self.jiandaArr count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kJiandaQuestionArray] objectAtIndex:indexPath.row]];
        }
        else if([self.analisisArr count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kAnalisisQuestionArray] objectAtIndex:indexPath.row]];
        }
        else if([self.zongheArr count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kZongheQuestionArray] objectAtIndex:indexPath.row]];
        }
    }else if (indexPath.section == 4)
    {
         if([self.jiandaArr count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kJiandaQuestionArray] objectAtIndex:indexPath.row]];
        }
        else if([self.analisisArr count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kAnalisisQuestionArray] objectAtIndex:indexPath.row]];
        }
        else if([self.zongheArr count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kZongheQuestionArray] objectAtIndex:indexPath.row]];
        }
    }else if (indexPath.section == 5)
    {
       if([self.analisisArr count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kAnalisisQuestionArray] objectAtIndex:indexPath.row]];
        }
        else if([self.zongheArr count] > 0)
        {
            [cell resetCellWithInfo:[[self.dataDic objectForKey:kZongheQuestionArray] objectAtIndex:indexPath.row]];
        }
    }else if (indexPath.section == 6)
    {
        [cell resetCellWithInfo:[[self.dataDic objectForKey:kZongheQuestionArray] objectAtIndex:indexPath.row]];
    }
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        
        if (indexPath.section == 0) {
            if ([[self.dataDic objectForKey:kSinglequistionArr] count] > 0) {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"单选"];
                reusableview = headview;
            }else if([[self.dataDic objectForKey:kMultiplequistionArr] count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"多选"];
                reusableview = headview;
            }else if([[self.dataDic objectForKey:kJudgequistionArr] count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"判断"];
                reusableview = headview;
            }else if([self.materailArr count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"不定项"];
                reusableview = headview;
            }
            else if([self.jiandaArr count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"简答题"];
                reusableview = headview;
            }
            else if([self.analisisArr count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"计算分析题"];
                reusableview = headview;
            }
            else if([self.zongheArr count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"综合题"];
                reusableview = headview;
            }
        }else if (indexPath.section == 1)
        {
            if([[self.dataDic objectForKey:kMultiplequistionArr] count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"多选"];
                reusableview = headview;
            }else if([[self.dataDic objectForKey:kJudgequistionArr] count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"判断"];
                reusableview = headview;
            }else if([self.materailArr count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"不定项"];
                reusableview = headview;
            }
            else if([self.jiandaArr count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"简答题"];
                reusableview = headview;
            }
            else if([self.analisisArr count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"计算分析题"];
                reusableview = headview;
            }
            else if([self.zongheArr count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"综合题"];
                reusableview = headview;
            }
        }else if (indexPath.section == 2)
        {
            if([[self.dataDic objectForKey:kJudgequistionArr] count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"判断"];
                reusableview = headview;
            }else if([self.materailArr count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"不定项"];
                reusableview = headview;
            }
            else if([self.jiandaArr count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"简答题"];
                reusableview = headview;
            }
            else if([self.analisisArr count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"计算分析题"];
                reusableview = headview;
            }
            else if([self.zongheArr count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"综合题"];
                reusableview = headview;
            }
        }else if (indexPath.section == 3)
        {
            if([self.materailArr count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"不定项"];
                reusableview = headview;
            }
            else if([self.jiandaArr count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"简答题"];
                reusableview = headview;
            }
            else if([self.analisisArr count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"计算分析题"];
                reusableview = headview;
            }
            else if([self.zongheArr count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"综合题"];
                reusableview = headview;
            }
        }else if (indexPath.section == 4)
        {
           if([self.jiandaArr count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"简答题"];
                reusableview = headview;
            }
            else if([self.analisisArr count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"计算分析题"];
                reusableview = headview;
            }
            else if([self.zongheArr count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"综合题"];
                reusableview = headview;
            }
        }else if (indexPath.section == 5)
        {
             if([self.analisisArr count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"计算分析题"];
                reusableview = headview;
            }
            else if([self.zongheArr count] > 0)
            {
                SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
                [headview resetWithTitle:@"综合题"];
                reusableview = headview;
            }
        }else if (indexPath.section == 6)
        {
            SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
            [headview resetWithTitle:@"综合题"];
            reusableview = headview;
        }
    }
    return reusableview;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = kScreenWidth/6-1;
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
