//
//  StudyPlanSecondViewController.m
//  Accountant
//
//  Created by aaa on 2017/12/12.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "StudyPlanSecondViewController.h"
#import "StudyPlanHeadTableViewCell.h"
#import "StudyPlanConditionTableViewCell.h"
#import "StudyPlanDerectionViewController.h"

#define kHeadCellID @"headCellID"
#define kConditionCellID @"conditionCellID"

@interface StudyPlanSecondViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)NSDictionary *professionalInfo;
@property (nonatomic, strong)NSDictionary * vocationInfo;
@property (nonatomic, strong)NSDictionary * interestInfo;

@end

@implementation StudyPlanSecondViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationViewSetup];
    [self loadData];
    [self prepareUI];
}

- (void)navigationViewSetup
{
    
    self.navigationItem.title = @"专属学习方案定制";
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

- (void)loadData
{
    NSDictionary * professionalDic = @{@"title":@"职称晋升:",@"dataArray":@[@"初级会计师",@"中级会计师",@"高级会计师",@"注册会计师"]};
    NSDictionary * vocationDic = @{@"title":@"行业选择:",@"dataArray":@[@"商贸业",@"工业制造业",@"服务业",@"物业管理",@"农业养殖",@"进出口",@"建筑地产",@"软件技术",@"金融行业",@"事业单位",@"非营利组织",@"行政事业"]};
    NSDictionary * interestDic = @{@"title":@"发展兴趣:",@"dataArray":@[@"零基础",@"税务",@"成本",@"出纳",@"手工帐",@"财务管理",@"Excel"]};
    
    [self.dataArray addObject:professionalDic];
    [self.dataArray addObject:vocationDic];
    [self.dataArray addObject:interestDic];
    
    
}

- (void)prepareUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromRGB(0xedf0f0);
    [self.tableView registerClass:[StudyPlanHeadTableViewCell class] forCellReuseIdentifier:kHeadCellID];
    [self.tableView registerClass:[StudyPlanConditionTableViewCell class] forCellReuseIdentifier:kConditionCellID];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [self getTableFootView];
    
}

- (UIView *)getTableFootView
{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    footView.backgroundColor = UIColorFromRGB(0xedf0f0);
    
    UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(20, 32, kScreenWidth - 40, 45);
    [nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.backgroundColor = UIColorFromRGB(0x1c71fa);
    nextBtn.layer.cornerRadius = nextBtn.hd_height / 2.0;
    nextBtn.layer.masksToBounds = YES;
    [footView addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    return footView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 4) {
        return 0;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (indexPath.section) {
        case 0:
            height = 90;
            break;
        case 1:
        case 3:
            height = 78;
            break;
        case 2:
            height = 156;
            break;
        case 4:
            height = 78;
            break;
            
        default:
            break;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        StudyPlanHeadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kHeadCellID forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.progress = StudyPlanHead_derection;
        [cell resetInfo];
        
        return cell;
    }
    
    StudyPlanConditionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kConditionCellID
                                                                             forIndexPath:indexPath];
    
    
    cell.selectInfoDic = [self resetCellSelectInfoDic:indexPath.section];
    cell.conditionType = [self resetCellConditionType:indexPath.section];
    
    [cell resetWithInfo:self.dataArray[indexPath.section - 1]];
    
    
    __weak typeof(self)weakSelf = self;
    cell.ConditionSelecBlock = ^(NSDictionary *conditionInfo) {
        [weakSelf getSelectCondition:conditionInfo];
        [weakSelf.tableView reloadData];
        NSLog(@"%@",conditionInfo);
    };
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        return 0;
    }else
    {
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = UIColorFromRGB(0xedf0f0);
    
//    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    
    return view;
}

- (NSDictionary *)resetCellSelectInfoDic:(NSInteger)section
{
    NSDictionary * infoDic;
    switch (section) {
        case 1:
            infoDic = self.professionalInfo;
            break;
        case 2:
            infoDic = self.vocationInfo;
            break;
        case 3:
            infoDic = self.interestInfo;
            break;
            
        default:
            break;
    }
    return infoDic;
}

- (StudyPlanContition_Type)resetCellConditionType:(NSInteger)section
{
    StudyPlanContition_Type conditionType = StudyPlanContition_professionalTitle;
    switch (section) {
        case 1:
            conditionType = StudyPlanContition_professionalTitle;
            break;
        case 2:
            conditionType = StudyPlanContition_vocation;
            break;
        case 3:
            conditionType = StudyPlanContition_interest;
            break;
            
        default:
            break;
    }
    return conditionType;
}

- (void)getSelectCondition:(NSDictionary *)infoDic
{
    switch ([[infoDic objectForKey:@"conditionType"] integerValue]) {
        case StudyPlanContition_professionalTitle:
            self.professionalInfo = infoDic;
            break;
        case StudyPlanContition_vocation:
            self.vocationInfo = infoDic;
            break;
        case StudyPlanContition_interest:
            self.interestInfo = infoDic;
            break;
        
        default:
            break;
    }
    
}
- (void)nextAction
{
    StudyPlanDerectionViewController * derectionVC = [[StudyPlanDerectionViewController alloc]init];
    [self.navigationController pushViewController:derectionVC animated:YES];
}

@end
