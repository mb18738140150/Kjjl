//
//  SimulateResultViewController.m
//  Accountant
//
//  Created by aaa on 2017/4/5.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "SimulateResultViewController.h"
#import "UIMacro.h"
#import "CommonMacro.h"
#import "TestManager.h"
#import "SimulateResultCollectionViewCell.h"
#import "SimulateresultCollectionReusableView.h"
#import "SimulateresulrHeadCell.h"
#import "SimulateQuestionAnalysisViewController.h"

@interface SimulateResultViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong)NSDictionary * dataDic;
@property (nonatomic, strong)NSMutableArray * singleArr;
@property (nonatomic, strong)NSMutableArray * mutipleArr;
@property (nonatomic, strong)NSMutableArray * judgeQuestionArr;
@property (nonatomic, strong)NSMutableArray * materailArr;

@end

@implementation SimulateResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataDic = [NSDictionary dictionary];
    self.singleArr = [NSMutableArray array];
    self.mutipleArr = [NSMutableArray array];
    self.judgeQuestionArr = [NSMutableArray array];
    self.materailArr = [NSMutableArray array];
    
    self.dataDic = [[TestManager sharedManager]getSimulateresult];
    
    self.singleArr = [self.dataDic objectForKey:kSinglequistionArr];
    self.mutipleArr = [self.dataDic objectForKey:kMultiplequistionArr];
    self.judgeQuestionArr = [self.dataDic objectForKey:kJudgequistionArr];
    self.materailArr = [self.dataDic objectForKey:kMaterailQuestionArray];
    [self saveSimulateScoreToDB];
    [self navigationViewSetup];
    [self contentViewSetup];
}
- (void)saveSimulateScoreToDB
{
    NSMutableDictionary * infoDic = [NSMutableDictionary dictionary];
    [infoDic setObject:self.cateName forKey:kCourseName];
    [infoDic setObject:@(self.cateId) forKey:kCourseID];
    [infoDic setObject:@([[self.dataDic objectForKey:kWrongquistionArr] count] + [[self.dataDic objectForKey:kRightquistionArr] count]) forKey:@"totalCount"];
    [infoDic setObject:@([[self.dataDic objectForKey:kRightquistionArr] count]) forKey:@"rightCount"];
    [infoDic setObject:@([[self.dataDic objectForKey:kWrongquistionArr] count]) forKey:@"wrongCount"];
    
    [[DBManager sharedManager]saveSimulateScoreInfo:infoDic];
    
}
- (void)navigationViewSetup
{
    self.navigationItem.title = @"答题统计";
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

- (void)contentViewSetup
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kTabBarHeight ) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = NO;
    [self.collectionView registerClass:[SimulateResultCollectionViewCell class] forCellWithReuseIdentifier:@"simulaterestltcellid"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SimulateresulrHeadCell" bundle:nil] forCellWithReuseIdentifier:@"SimulateresulrHeadCellId"];
    [self.collectionView registerClass:[SimulateresultCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];
    
    UIView * lookquestiondetailView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - kTabBarHeight - kNavigationBarHeight - kStatusBarHeight, kScreenWidth, kTabBarHeight)];
    lookquestiondetailView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lookquestiondetailView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, .8)];
    lineView.backgroundColor = [UIColor colorWithWhite:.8 alpha:1];
    [lookquestiondetailView addSubview:lineView];
    
    UIButton * lookAllQuestionBT = [UIButton buttonWithType:UIButtonTypeCustom];
    lookAllQuestionBT.frame = CGRectMake(0, (kTabBarHeight - 40) / 2, kScreenWidth / 3, 40);
    lookAllQuestionBT.backgroundColor = [UIColor whiteColor];
    lookAllQuestionBT.layer.cornerRadius = 15;
    lookAllQuestionBT.layer.masksToBounds = YES;
    lookAllQuestionBT.titleLabel.font = [UIFont systemFontOfSize:14];
    [lookAllQuestionBT setImage:[UIImage imageNamed:@"tiku_解析"] forState:UIControlStateNormal];
    [lookAllQuestionBT setTitle:@"查看全部解析" forState:UIControlStateNormal];
    [lookAllQuestionBT setTitleColor:kMainTextColor_100 forState:UIControlStateNormal];
    [lookAllQuestionBT addTarget:self action:@selector(lookAllquestion) forControlEvents:UIControlEventTouchUpInside];
    [lookAllQuestionBT setImageEdgeInsets:UIEdgeInsetsMake(-12, kScreenWidth / 9, 0, 0)];
    [lookAllQuestionBT setTitleEdgeInsets:UIEdgeInsetsMake(27, -lookAllQuestionBT.imageView.hd_width, 0, 0)];
    [lookquestiondetailView addSubview:lookAllQuestionBT];
    //    lookAllQuestionBT.imageView.backgroundColor = [UIColor redColor];
    
    UIButton * lookWrongQuestionBT = [UIButton buttonWithType:UIButtonTypeCustom];
    lookWrongQuestionBT.frame = CGRectMake(kScreenWidth / 3, (kTabBarHeight - 40) / 2, kScreenWidth / 3, 40);
    lookWrongQuestionBT.backgroundColor = [UIColor whiteColor];
    lookWrongQuestionBT.layer.cornerRadius = 15;
    lookWrongQuestionBT.layer.masksToBounds = YES;
    lookWrongQuestionBT.titleLabel.font = [UIFont systemFontOfSize:14];
    [lookWrongQuestionBT setImage:[UIImage imageNamed:@"tiku_我－我的错题"] forState:UIControlStateNormal];
    [lookWrongQuestionBT setTitle:@"查看错题解析" forState:UIControlStateNormal];
    [lookWrongQuestionBT setTitleColor:kMainTextColor_100 forState:UIControlStateNormal];
    [lookWrongQuestionBT addTarget:self action:@selector(lookWrongquestion) forControlEvents:UIControlEventTouchUpInside];
    [lookWrongQuestionBT setImageEdgeInsets:UIEdgeInsetsMake(-12, kScreenWidth / 9, 0, 0)];
    [lookWrongQuestionBT setTitleEdgeInsets:UIEdgeInsetsMake(27, -lookAllQuestionBT.imageView.hd_width, 0, 0)];
    [lookquestiondetailView addSubview:lookWrongQuestionBT];
    
    UIButton * againBT = [UIButton buttonWithType:UIButtonTypeCustom];
    againBT.frame = CGRectMake( kScreenWidth / 3 * 2, (kTabBarHeight - 40) / 2, kScreenWidth / 3, 40);
    againBT.backgroundColor = [UIColor whiteColor];
    againBT.layer.cornerRadius = 15;
    againBT.layer.masksToBounds = YES;
    againBT.titleLabel.font = [UIFont systemFontOfSize:14];
    [againBT setImage:[UIImage imageNamed:@"tiku_重做"] forState:UIControlStateNormal];
    [againBT setTitle:@"再做一遍" forState:UIControlStateNormal];
    [againBT setTitleColor:kMainTextColor_100 forState:UIControlStateNormal];
    [againBT addTarget:self action:@selector(rewritequestion) forControlEvents:UIControlEventTouchUpInside];
    [againBT setImageEdgeInsets:UIEdgeInsetsMake(-12, kScreenWidth / 9, 0, 0)];
    [againBT setTitleEdgeInsets:UIEdgeInsetsMake(27, -lookAllQuestionBT.imageView.hd_width, 0, 0)];
    [lookquestiondetailView addSubview:againBT];
    
}

- (void)lookAllquestion
{
    SimulateQuestionAnalysisViewController * simulateresultVC = [[SimulateQuestionAnalysisViewController alloc]init];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:simulateresultVC animated:YES];
}

- (void)lookWrongquestion
{
    SimulateQuestionAnalysisViewController * simulateresultVC = [[SimulateQuestionAnalysisViewController alloc]init];
    simulateresultVC.wrongQuestion = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:simulateresultVC animated:YES];
}
- (void)rewritequestion
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfReWriteSmulate object:nil];
    
    [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        SimulateresulrHeadCell * cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"SimulateresulrHeadCellId" forIndexPath:indexPath];
        cell1.time = self.time.intValue;
        [cell1 resetWithInfo:self.dataDic];
        
        return cell1;
    }
    
    SimulateResultCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"simulaterestltcellid" forIndexPath:indexPath];
    if (indexPath.section == 1) {
        if ([[self.dataDic objectForKey:kSinglequistionArr] count] > 0) {
            [cell resetCellWithinfo:[[self.dataDic objectForKey:kSinglequistionArr] objectAtIndex:indexPath.row]];
            cell.questionNumberLabel.text =
            [NSString stringWithFormat:@"%@", [[[self.dataDic objectForKey:kSinglequistionArr] objectAtIndex:indexPath.row] objectForKey:kTestQuestionNumber]];
        }else if([[self.dataDic objectForKey:kMultiplequistionArr] count] > 0)
        {
            [cell resetCellWithinfo:[[self.dataDic objectForKey:kMultiplequistionArr] objectAtIndex:indexPath.row]];
            cell.questionNumberLabel.text = [NSString stringWithFormat:@"%@", [[[self.dataDic objectForKey:kMultiplequistionArr] objectAtIndex:indexPath.row] objectForKey:kTestQuestionNumber]];
        }else if([[self.dataDic objectForKey:kJudgequistionArr] count] > 0)
        {
            [cell resetCellWithinfo:[[self.dataDic objectForKey:kJudgequistionArr] objectAtIndex:indexPath.row]];
            cell.questionNumberLabel.text = [NSString stringWithFormat:@"%@", [[[self.dataDic objectForKey:kJudgequistionArr] objectAtIndex:indexPath.row] objectForKey:kTestQuestionNumber]];
        }else if([self.materailArr count] > 0)
        {
            [cell resetCellWithinfo:[[self.dataDic objectForKey:kMaterailQuestionArray] objectAtIndex:indexPath.row]];
            cell.questionNumberLabel.text = [NSString stringWithFormat:@"%@", [[[self.dataDic objectForKey:kMaterailQuestionArray] objectAtIndex:indexPath.row] objectForKey:kTestQuestionNumber]];
        }
    }else if (indexPath.section == 2)
    {
        if([[self.dataDic objectForKey:kSinglequistionArr] count] > 0 && [[self.dataDic objectForKey:kMultiplequistionArr] count] > 0)
        {
            [cell resetCellWithinfo:[[self.dataDic objectForKey:kMultiplequistionArr] objectAtIndex:indexPath.row]];
            
            cell.questionNumberLabel.text = [NSString stringWithFormat:@"%@", [[[self.dataDic objectForKey:kMultiplequistionArr] objectAtIndex:indexPath.row] objectForKey:kTestQuestionNumber]];
        }else if([[self.dataDic objectForKey:kJudgequistionArr] count] > 0)
        {
            [cell resetCellWithinfo:[[self.dataDic objectForKey:kJudgequistionArr] objectAtIndex:indexPath.row]];
            cell.questionNumberLabel.text = [NSString stringWithFormat:@"%@", [[[self.dataDic objectForKey:kJudgequistionArr] objectAtIndex:indexPath.row] objectForKey:kTestQuestionNumber]];
        }else if([self.materailArr count] > 0)
        {
            [cell resetCellWithinfo:[[self.dataDic objectForKey:kMaterailQuestionArray] objectAtIndex:indexPath.row]];
            cell.questionNumberLabel.text = [NSString stringWithFormat:@"%@", [[[self.dataDic objectForKey:kMaterailQuestionArray] objectAtIndex:indexPath.row] objectForKey:kTestQuestionNumber]];
        }
    }else if (indexPath.section == 3)
    {
        if([[self.dataDic objectForKey:kJudgequistionArr] count] > 0)
        {
            [cell resetCellWithinfo:[[self.dataDic objectForKey:kJudgequistionArr] objectAtIndex:indexPath.row]];
            
            cell.questionNumberLabel.text = [NSString stringWithFormat:@"%@", [[[self.dataDic objectForKey:kJudgequistionArr] objectAtIndex:indexPath.row] objectForKey:kTestQuestionNumber]];
        }else if([self.materailArr count] > 0)
        {
            [cell resetCellWithinfo:[[self.dataDic objectForKey:kMaterailQuestionArray] objectAtIndex:indexPath.row]];
            cell.questionNumberLabel.text = [NSString stringWithFormat:@"%@", [[[self.dataDic objectForKey:kMaterailQuestionArray] objectAtIndex:indexPath.row] objectForKey:kTestQuestionNumber]];
        }
    }else if (indexPath.section == 4)
    {
        [cell resetCellWithinfo:[[self.dataDic objectForKey:kMaterailQuestionArray] objectAtIndex:indexPath.row]];
        //        cell.questionNumberLabel.text = [NSString stringWithFormat:@"%@", [[[self.dataDic objectForKey:kMaterailQuestionArray] objectAtIndex:indexPath.row] objectForKey:kTestQuestionNumber]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    SimulateResultCollectionViewCell * cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:indexPath.section]];
    SimulateQuestionAnalysisViewController * simulateresultVC = [[SimulateQuestionAnalysisViewController alloc]init];
    simulateresultVC.currentQuestionIndex = cell.questionNumberLabel.text.intValue - 1;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:simulateresultVC animated:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        
        if (indexPath.section == 0) {
            SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
            reusableview = headview;
        }else if (indexPath.section == 1) {
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
        }else if (indexPath.section == 2)
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
        }else if (indexPath.section == 3)
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
        }else if (indexPath.section == 4)
        {
            SimulateresultCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
            [headview resetWithTitle:@"不定项"];
            reusableview = headview;
        }
    }
    return reusableview;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 1) {
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
        else
        {
            return 0;
        }
    }else if (section == 2)
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
        }else
        {
            return 0;
        }
    }else if (section == 3)
    {
        if([[self.dataDic objectForKey:kJudgequistionArr] count] > 0)
        {
            return [[self.dataDic objectForKey:kJudgequistionArr] count];
        }
        else if([self.materailArr count] > 0)
        {
            return [self.materailArr count];
        }else
        {
            return 0;
        }
    }
    else if (section == 4)
    {
        return [self.materailArr count];
    }else
    {
        return 1;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenWidth, kCellHeightOfBanner + 25);
    }else
    {
        return CGSizeMake((int)(self.view.frame.size.width / 6), self.view.frame.size.width / 6);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(0, 0);
    }else
    {
        return CGSizeMake(kScreenWidth, 20);
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    int number = 0;
    if ([self.singleArr count] > 0) {
        number++;
    }
    if([self.mutipleArr count] > 0)
    {
        number++;
    }
    if([self.judgeQuestionArr count] > 0)
    {
        number++;
    }
    
    if([self.materailArr count] > 0)
    {
        number++;
    }
    
    return number + 1;
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
