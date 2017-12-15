//
//  StudyPlanDerectionViewController.m
//  Accountant
//
//  Created by aaa on 2017/12/12.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "StudyPlanDerectionViewController.h"
#import "StudyPlanDerectionTableViewCell.h"

#define DerectionCellID  @"derectionCellID"

@interface StudyPlanDerectionViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation StudyPlanDerectionViewController

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
    NSDictionary * first = @{@"jieduan":@"第一阶段",@"title":@"零基础入门",@"detail":@"建立学习体系和学习方法，知识学习脉络，突出考试重难点，快速掌握知识点分布情况。",@"color":@(0xa272ff)};
    NSDictionary * second = @{@"jieduan":@"第二阶段",@"title":@"教材精讲",@"detail":@"系统梳理知识结构及重难点分值占比，全面精讲，详细把握考点和方向，深度精讲夯实基础。",@"color":@(0xfec243)};
    NSDictionary * third = @{@"jieduan":@"第三阶段",@"title":@"习题强化",@"detail":@"高强度训练做题，快速高效掌握知识点。",@"color":@(0x429dfe)};
    NSDictionary * fourth = @{@"jieduan":@"第四阶段",@"title":@"考前冲刺",@"detail":@"精准压缩考试范围，梳理应考点脉络。",@"color":@(0xfe5f70)};
    NSDictionary * fiveth = @{@"jieduan":@"第五阶段",@"title":@"历年真题模拟考试",@"detail":@"历年真题练习，真实环境模拟，熟悉电脑操作，轻松应对考试。",@"color":@(0x1cc6a4)};
    
    [self.dataArray addObject:first];
    [self.dataArray addObject:second];
    [self.dataArray addObject:third];
    [self.dataArray addObject:fourth];
    [self.dataArray addObject:fiveth];
    
    
}

- (void)prepareUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromRGB(0xedf0f0);
    [self.tableView registerNib:[UINib nibWithNibName:@"StudyPlanDerectionTableViewCell" bundle:nil] forCellReuseIdentifier:DerectionCellID];
    
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 134;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StudyPlanDerectionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:DerectionCellID forIndexPath:indexPath];
    [cell resetWith:self.dataArray[indexPath.section]];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        return 0;
    }else
    {
        return 29;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 19)];
    view.backgroundColor = UIColorFromRGB(0xedf0f0);
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 7, 7, 14, 14)];
    imageView.image = [UIImage imageNamed:@"icon_next"];
    [view addSubview:imageView];
    
    UIButton * upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    upBtn.frame = CGRectMake(0, 0, kScreenWidth, kStatusBarHeight);
    [upBtn setTitle:@"" forState:UIControlStateNormal];
    [upBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    upBtn.layer.cornerRadius = 1;
    upBtn.layer.masksToBounds = YES;
    upBtn.layer.borderWidth = 1;
    
    upBtn.backgroundColor = UIColorFromRGBValue(0xeeeeee);
    
    return view;
}

@end
