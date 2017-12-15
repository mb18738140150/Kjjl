//
//  GetMoreIntegralViewController.m
//  Accountant
//
//  Created by aaa on 2017/12/6.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "GetMoreIntegralViewController.h"
#import "GetIntegralTableViewCell.h"

#define kCellId @"GetIntegralTableViewCellID"
#define kImageHeight  kScreenWidth/ 1.43

@interface GetMoreIntegralViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UIImageView * topImageView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray * dataSourceArr;

@end

@implementation GetMoreIntegralViewController

- (NSMutableArray *)dataSourceArr
{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navBarBgAlpha = @"0.0";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigationViewSetup];
    [self loadData];
    [self prepareUI];
    
}

- (void)navigationViewSetup
{
    self.navigationItem.title = @"赚积分";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"public-返回"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)prepareUI
{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -(kStatusBarHeight + kNavigationBarHeight), kScreenWidth, kStatusBarHeight + kNavigationBarHeight)];
//    topView.backgroundColor = UIRGBColor(25, 102, 249);
    topView.backgroundColor = UIColorFromRGB(0x1c70fa);
    [self.view addSubview:topView];
    
    self.topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kImageHeight)];
    self.topImageView.image = [UIImage imageNamed:@"img_top"];
    [self.view addSubview:self.topImageView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topImageView.frame), kScreenWidth, kScreenHeight - (kStatusBarHeight + kNavigationBarHeight + self.topImageView.hd_height)) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"GetIntegralTableViewCell" bundle:nil] forCellReuseIdentifier:kCellId];
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSourceArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GetIntegralTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    NSArray * dataArr = self.dataSourceArr[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell resetcellWith:dataArr[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
    view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 34)];
    label.textColor = UIColorFromRGB(0x333333);
    label.font = kMainFont;
    [view addSubview:label];
    if (section == 0) {
        label.text = @"基本任务";
    }else
    {
        label.text = @"专属任务";
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34;
}

- (void)loadData
{
    NSMutableArray * basicArray = [NSMutableArray array];
    NSMutableArray * exclusiveArray = [NSMutableArray array];
    NSDictionary * dic1 = @{@"icon":@"img_tjhy",@"title":@"推荐好友赚积分",@"detail":@"邀请好友送积分，不限完成次数"};
    NSDictionary * dic2 = @{@"icon":@"img_bdsj",@"title":@"绑定手机号",@"detail":@"绑定手机号送积分"};
    NSDictionary * dic3 = @{@"icon":@"img_yjfk",@"title":@"意见反馈",@"detail":@"说出你对会计教练产品的建议和不足之处"};
    NSDictionary * dic4 = @{@"icon":@"img_tkbj",@"title":@"听课笔记",@"detail":@"学习过程中，进行笔记的记录"};
    NSDictionary * dic5 = @{@"icon":@"img_fbwt",@"title":@"发布问题",@"detail":@"快速帮助学员解决疑难问题"};
    
    [basicArray addObject:dic1];
    [basicArray addObject:dic2];
    [basicArray addObject:dic3];
    
    [exclusiveArray addObject:dic4];
    [exclusiveArray addObject:dic5];
    
    [self.dataSourceArr addObject:basicArray];
    [self.dataSourceArr addObject:exclusiveArray];
}

@end
