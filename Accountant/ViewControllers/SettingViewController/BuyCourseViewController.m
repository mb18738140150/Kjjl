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
#import "AppIconViewController.h"
#import "MemberDetailViewController.h"
#import "BuyDetailViewController.h"

#define kCoursePriceCellID @"CoursePriceCellID"
#define kMemberCellId @"MemberCellId"

@interface BuyCourseViewController ()<UITableViewDelegate, UITableViewDataSource,UIWebViewDelegate,UIAlertViewDelegate,UserModule_PayOrderProtocol>

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
    [cansultBtn setTitleColor:UIColorFromRGB(0xff740e) forState:UIControlStateNormal];
    cansultBtn.backgroundColor = UIColorFromRGB(0xf2f2f2);
    cansultBtn.titleLabel.font = kMainFont;
    [self.view addSubview:cansultBtn];
    [cansultBtn addTarget:self action:@selector(cansultAction) forControlEvents:UIControlEventTouchUpInside];
    
    __weak typeof(self)weakSelf = self;
    self.cansultView = [[CansultTeachersListView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andTeachersArr:[[UserManager sharedManager] getAssistantList]];
    self.cansultView.dismissBlock = ^{
        [weakSelf.cansultView removeFromSuperview];
    };
    self.cansultView.cansultBlock = ^(NSDictionary *infoDic) {
        [weakSelf cantactTeacherAction:infoDic];
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
#pragma mark - cantactTeacher
- (void)cantactTeacherAction:(NSDictionary *)teacherInfo
{
    NSString  *qqNumber=[teacherInfo objectForKey:@"assistantQQ"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectZero];
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qqNumber]];
        
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        webView.delegate = self;
        [webView loadRequest:request];
        [self.view addSubview:webView];
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"对不起，您还没安装QQ"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
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
    if ([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled]) {
        BuyDetailViewController *buyVC = [[BuyDetailViewController alloc]init];
        buyVC.infoDic = infoDic;
        if (self.isLiving) {
            buyVC.payCourseType = PayCourseType_LivingCourse;
        }else
        {
            buyVC.payCourseType = PayCourseType_Course;
        }
        [self.navigationController pushViewController:buyVC animated:YES];
    }else
    {
        NSLog(@"%@", infoDic);
        if ([[infoDic objectForKey:kPrice] intValue] > [[UserManager sharedManager] getMyGoldCoins]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的金币数量不足请先购买金币" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }else
        {
            PayCourseType type1;
            if (self.isLiving) {
                type1 = PayCourseType_LivingCourse;
            }else
            {
                type1 = PayCourseType_Course;
            }
            [SVProgressHUD show];
            NSDictionary * infoDic1 = @{@"courseId":[infoDic objectForKey:kCourseID],
                                       @"payType":@3,
                                       @"courseType":@(type1),
                                       @"discountCouponId":@0};
            [[UserManager sharedManager] payOrderWith:infoDic1 withNotifiedObject:self];
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        AppIconViewController * appVC = [[AppIconViewController alloc]init];
        [self.navigationController pushViewController:appVC animated:YES];
    }
}

#pragma mark - payOrderDelegate
- (void)didRequestPayOrderSuccessed
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"购买成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didRequestPayOrderFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
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
