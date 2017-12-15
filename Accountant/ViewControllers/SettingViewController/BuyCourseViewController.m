//
//  BuyCourseViewController.m
//  Accountant
//
//  Created by aaa on 2017/11/6.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "BuyCourseViewController.h"
#import "CansultTeachersListView.h"
#import "CoursePriceTableViewCell.h"
#import "MemberIntroduceTableViewCell.h"

#import "MemberDetailViewController.h"
#import "BuyDetailViewController.h"

#define kCoursePriceCellID @"CoursePriceCellID"
#define kMemberCellId @"MemberCellId"

@interface BuyCourseViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)CansultTeachersListView            *cansultView;

@end

@implementation BuyCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    NSLog(@"\n******************************************\n%@\n***********************************\n", self.infoDic);
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigationViewSetup];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 50 - self.navigationController.navigationBar.hd_height - 20) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MemberIntroduceTableViewCell class] forCellReuseIdentifier:kMemberCellId];
    [self.tableView registerClass:[CoursePriceTableViewCell class] forCellReuseIdentifier:kCoursePriceCellID];
    [self.view addSubview:self.tableView];
    
    UIButton * cansultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cansultBtn.frame = CGRectMake(0, kScreenHeight - 50 - self.navigationController.navigationBar.hd_height - 20, kScreenWidth, 50);
    [cansultBtn setTitle:@"点击咨询" forState:UIControlStateNormal];
    [cansultBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    cansultBtn.backgroundColor = UIColorFromRGB(0xf2f2f2);
    cansultBtn.titleLabel.font = kMainFont;
    [self.view addSubview:cansultBtn];
    [cansultBtn addTarget:self action:@selector(cansultAction) forControlEvents:UIControlEventTouchUpInside];
    
    __weak typeof(self)weakSelf = self;
    self.cansultView = [[CansultTeachersListView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andTeachersArr:@[@""]];
    self.cansultView.dismissBlock = ^{
        [weakSelf.cansultView removeFromSuperview];
    };
    
}

- (void)navigationViewSetup
{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, 64)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"购买详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"public-返回"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cansultAction
{
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    [delegate.window addSubview:self.cansultView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == 1) {
        MemberIntroduceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kMemberCellId forIndexPath:indexPath];
        [cell resetCell];
        cell.buyMemberBlock = ^{
            NSLog(@"kaitonghuiyuan ***");
            [weakSelf pushMemberDetailVC];
        };
        return cell;
    }else
    {
        CoursePriceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCoursePriceCellID forIndexPath:indexPath];
        [cell resetWith:self.infoDic];
        cell.buyCourseBlock = ^(NSDictionary *infoDic) {
            
            [weakSelf buyCourse:infoDic];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        return 350;
    }else
    {
        return 160;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        view.backgroundColor = UIColorFromRGB(0xedf0f2);
        return view;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }else{
        return 0;
    }
}

- (void)pushMemberDetailVC
{
    MemberDetailViewController * vc = [[MemberDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)buyCourse:(NSDictionary *)infoDic
{
    BuyDetailViewController *buyVC = [[BuyDetailViewController alloc]init];
    buyVC.infoDic = infoDic;
    [self.navigationController pushViewController:buyVC animated:YES];
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
