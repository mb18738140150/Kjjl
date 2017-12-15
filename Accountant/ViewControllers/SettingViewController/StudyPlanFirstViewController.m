//
//  StudyPlanFirstViewController.m
//  Accountant
//
//  Created by aaa on 2017/12/11.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "StudyPlanFirstViewController.h"
#import "StudyPlanHeadTableViewCell.h"
#import "StudyPlanConditionTableViewCell.h"
#import "StudyPlanSecondViewController.h"

#define kHeadCellID @"headCellID"
#define kConditionCellID @"conditionCellID"


@interface StudyPlanFirstViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, copy)NSString * nameStr;
@property (nonatomic, assign)int gender;

@property (nonatomic, strong)NSDictionary *educationInfo;
@property (nonatomic, strong)NSDictionary * ageInfo;
@property (nonatomic, strong)NSDictionary * workLimitInfo;
@property (nonatomic, strong)NSDictionary * certificateInfo;
@property (nonatomic, strong)NSDictionary * statusInfo;

@end

@implementation StudyPlanFirstViewController

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
    
    self.navigationItem.title = @"学习计划";
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
    NSDictionary * nameDic = @{@"title":@"姓名:"};
    NSDictionary * gender = @{@"title":@"性别:"};
    NSDictionary * educationDic = @{@"title":@"学历:",@"dataArray":@[@"硕士",@"本科",@"专科",@"高中",@"初中",@"其他"]};
    NSDictionary * ageDic = @{@"title":@"年龄:",@"dataArray":@[@"15-20岁",@"21-25岁",@"26-30岁",@"31-35岁",@"36-40岁",@"41岁以上"]};
    NSDictionary * workLimitDic = @{@"title":@"从业年限:",@"dataArray":@[@"没从事过",@"不满一年",@"一到三年",@"三到五年",@"五到十年",@"十年以上"]};
    NSDictionary * cetificateDic = @{@"title":@"持有证书:",@"dataArray":@[@"无证书",@"会计证",@"初级证书",@"中级证书",@"注册证书",@"其他"]};
    NSDictionary * workStatus = @{@"title":@"目前状态:",@"dataArray":@[@"学生",@"找工作",@"做出纳",@"做会计",@"其他"]};
    
    [self.dataArray addObject:nameDic];
    [self.dataArray addObject:gender];
    [self.dataArray addObject:educationDic];
    [self.dataArray addObject:ageDic];
    [self.dataArray addObject:workLimitDic];
    [self.dataArray addObject:cetificateDic];
    [self.dataArray addObject:workStatus];
    
    
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
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
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
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
        case 2:
            height = 45;
            break;
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
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
        cell.progress = StudyPlanHead_infomation;
        [cell resetInfo];
        
        return cell;
    }
    
    StudyPlanConditionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kConditionCellID
                                                                             forIndexPath:indexPath];
    
    if (indexPath.section == 1) {
        cell.conditionCellType = ConditionCellType_name;
    }else if (indexPath.section == 2)
    {
        cell.conditionCellType = ConditionCellType_gender;
    }else
    {
        cell.selectInfoDic = [self resetCellSelectInfoDic:indexPath.section];
        cell.conditionType = [self resetCellConditionType:indexPath.section];
    }
    [cell resetWithInfo:self.dataArray[indexPath.section - 1]];
    
    
    __weak typeof(self)weakSelf = self;
    cell.ConditionSelecBlock = ^(NSDictionary *conditionInfo) {
        [weakSelf getSelectCondition:conditionInfo];
        [weakSelf.tableView reloadData];
        NSLog(@"%@",conditionInfo);
    };
    cell.nameBlock = ^(NSString *name) {
        weakSelf.nameStr = name;
    };
    cell.GenderSelectBlock = ^(NSString *gender) {
        NSLog(@"%@", gender);
    };
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 7) {
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
    return view;
}

- (NSDictionary *)resetCellSelectInfoDic:(NSInteger)section
{
    NSDictionary * infoDic;
    switch (section) {
        case 3:
            infoDic = self.educationInfo;
            break;
        case 4:
            infoDic = self.ageInfo;
            break;
        case 5:
            infoDic = self.workLimitInfo;
            break;
        case 6:
            infoDic = self.certificateInfo;
            break;
        case 7:
            infoDic = self.statusInfo;
            break;
            
        default:
            break;
    }
    return infoDic;
}

- (StudyPlanContition_Type)resetCellConditionType:(NSInteger)section
{
    StudyPlanContition_Type conditionType = StudyPlanContition_education;
    switch (section) {
        case 3:
            conditionType = StudyPlanContition_education;
            break;
        case 4:
            conditionType = StudyPlanContition_age;
            break;
        case 5:
            conditionType = StudyPlanContition_workLimit;
            break;
        case 6:
            conditionType = StudyPlanContition_certificate;
            break;
        case 7:
            conditionType = StudyPlanContition_workStatus;
            break;
            
        default:
            break;
    }
    return conditionType;
}

- (void)getSelectCondition:(NSDictionary *)infoDic
{
    switch ([[infoDic objectForKey:@"conditionType"] integerValue]) {
        case StudyPlanContition_education:
            self.educationInfo = infoDic;
            break;
        case StudyPlanContition_age:
            self.ageInfo = infoDic;
            break;
        case StudyPlanContition_workLimit:
            self.workLimitInfo = infoDic;
            break;
        case StudyPlanContition_certificate:
            self.certificateInfo = infoDic;
            break;
        case StudyPlanContition_workStatus:
            self.statusInfo = infoDic;
            break;
            
        default:
            break;
    }
    
}

- (void)nextAction
{
    StudyPlanSecondViewController * secondVC = [[StudyPlanSecondViewController alloc]init];
    [self.navigationController pushViewController:secondVC animated:YES];
}

@end
