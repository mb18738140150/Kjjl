//
//  FuliViewController.m
//  Accountant
//
//  Created by aaa on 2018/2/5.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "FuliViewController.h"
#import "HYSegmentedControl.h"
#import "FuliTableViewCell.h"

#define kFuliCellId @"fuliCellId"
@interface FuliViewController ()<UITableViewDelegate, UITableViewDataSource, HYSegmentedControlDelegate,UserModule_SubmitGiftCode, UserModule_GiftList>

@property (nonatomic, strong)HYSegmentedControl * segmentControl;
@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray * dataArray;

@property (nonatomic, strong)UITextField * codeTF;

@end

@implementation FuliViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationViewSetup];
    [self prepareUI];
    [self loadData];
}

- (void)navigationViewSetup
{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, 64)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"会员福利";
    
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

- (void)prepareUI
{
    
    self.segmentControl = [[HYSegmentedControl alloc]initWithOriginY:0  Titles:@[@"已获取福利",@"激活福利"] delegate:self];
    [self.view addSubview:self.segmentControl];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 42, kScreenWidth, kScreenHeight - 42 - kStatusBarHeight - kNavigationBarHeight)];
    [self.view addSubview:self.scrollView];
    __weak typeof(self)weakSelf = self;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.scrollView.hd_height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"FuliTableViewCell" bundle:nil] forCellReuseIdentifier:kFuliCellId];
    [self.scrollView addSubview:self.tableView];
    
    UILabel *codeLB = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth + 10, 20, kScreenWidth - 20, 15)];
    codeLB.text = @"请输入激活码，激活您的福利";
    codeLB.textColor = UIColorFromRGB(0x333333);
    [self.scrollView addSubview:codeLB];
    
    self.codeTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth + 10, CGRectGetMaxY(codeLB.frame) + 20, kScreenWidth - 20, 50)];
    self.codeTF.placeholder = @"请输入激活码";
    self.codeTF.layer.cornerRadius = 3;
    self.codeTF.layer.masksToBounds = YES;
    self.codeTF.layer.borderWidth = 1;
    self.codeTF.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
    self.codeTF.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.scrollView addSubview:self.codeTF];
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(kScreenWidth + kScreenWidth / 2 - 50, CGRectGetMaxY(self.codeTF.frame) + 35, 100, 35);
    [submitBtn setTitle:@"确认" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 3;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.backgroundColor = UIRGBColor(24, 102, 250);
    [self.scrollView addSubview:submitBtn];
    [submitBtn addTarget:self action:@selector(submitCodeAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadData
{
    [SVProgressHUD show];
    [[UserManager sharedManager] didRequestGiftListWithInfo:@{} withNotifiedObject:self];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FuliTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kFuliCellId forIndexPath:indexPath];
    
    [cell resetWith:[self.dataArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

#pragma mark - HYSegmentControl delegate
-(void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth * index, 0) animated:NO];
}

- (void)submitCodeAction
{
    if (self.codeTF.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"激活码不能为空"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    NSDictionary * infoDic = @{@"actCode":self.codeTF.text};
    [[UserManager sharedManager] didRequestSubmitGiftCodeWithInfo:infoDic withNotifiedObject:self];
}

#pragma giftlist delegate
- (void)didRequestGiftListSuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    
    self.dataArray = [[UserManager sharedManager] getGiftList];
    [self.tableView reloadData];
}

- (void)didRequestGiftListFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestSubmitGiftCodeSuccessed
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"激活成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    [self loadData];
}

- (void)didRequestSubmitGiftCodeFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

@end
