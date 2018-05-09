//
//  PackageDetailViewController.m
//  Accountant
//
//  Created by aaa on 2018/4/20.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "PackageDetailViewController.h"
#import "PackageDetailHeadCell.h"
#import "PackageDetailCourseCell.h"
#import "CansultTeachersListView.h"
#import "CourseraManager.h"
#import "PackageDetailIntroduceCell.h"
#import "PackageDetailSelectView.h"
#import "BuyDetailViewController.h"

#define kHeadCellID @"PackageDetailHeadCell"
#define kCourseCellID @"PackageDetailCourseCellID"
#define kPackageDetailIntroduce @"PackageDetailIntroduceCell"

@interface PackageDetailViewController ()<UITableViewDelegate, UITableViewDataSource,UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong)UITableView * tableview;
@property (nonatomic, strong)UISegmentedControl * topSegment;
@property (nonatomic, strong)CansultTeachersListView            *cansultView;

@property (nonatomic, strong)UIButton *collectBtn;
@property (nonatomic, strong)UIButton * consultBtn;
@property (nonatomic, strong)UIButton * shoppingCarBtn;
@property (nonatomic, strong)UIButton * buyBtn;
@property (nonatomic, strong)PackageDetailSelectView * packageDetailSelectView;

@property (nonatomic, strong)NSDictionary * packageDetailInfoDic;
@property (nonatomic, strong)NSArray * packageSpecificationArr;// 规格列表
@property (nonatomic, strong)NSDictionary * packageSelectSpecificationIndoDic;// 已选套餐规格

@end

@implementation PackageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.packageDetailInfoDic = [[CourseraManager sharedManager] getPackageDetailInfo];
    self.packageSpecificationArr = [self.packageDetailInfoDic objectForKey:@"data"];
    [self navigationViewSetup];
    [self prepareUI];
}

- (void)navigationViewSetup
{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, 64)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"商品详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationItem.titleView = [self prepareTitleView];
    //    self.navigationController.navigationBarHidden = YES;
    
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"public-返回"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
}

- (UIView *)prepareTitleView
{
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 7, kScreenWidth - 100, 30)];
    titleView.backgroundColor = [UIColor whiteColor];
    
    self.topSegment  = [[UISegmentedControl alloc]initWithItems:@[@"商品", @"详情"]];
    self.topSegment.frame = CGRectMake(titleView.hd_centerX - 100, 1, 200, 28);
    self.topSegment.tintColor = [UIColor whiteColor];
    
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:UIColorFromRGBValue(0xff0000)};
    [self.topSegment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName: UIColorFromRGB(0x333333)};
    [self.topSegment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    self.topSegment.selectedSegmentIndex = 0;
    [self.topSegment addTarget:self action:@selector(changeSlect:) forControlEvents:UIControlEventValueChanged];
    
    [titleView addSubview:self.topSegment];
    
    return titleView;
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeSlect:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex == 1) {
        [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }else
    {
        [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

- (void)prepareUI
{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - 50) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"PackageDetailHeadCell" bundle:nil] forCellReuseIdentifier:kHeadCellID];
    [self.tableview registerNib:[UINib nibWithNibName:@"PackageDetailCourseCell" bundle:nil] forCellReuseIdentifier:kCourseCellID];
    [self.tableview registerClass:[PackageDetailIntroduceCell class] forCellReuseIdentifier:kPackageDetailIntroduce];
    [self.view addSubview:self.tableview];
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableview.frame), kScreenWidth, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xcccccc);
    [bottomView addSubview:lineView];
    
    self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectBtn.frame = CGRectMake( 0, 1, kScreenWidth * 0.2, 49);
    _collectBtn.backgroundColor = [UIColor whiteColor];
    _collectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_collectBtn setImage:[UIImage imageNamed:@"package_收藏"] forState:UIControlStateNormal];
    [_collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [_collectBtn setTitleColor:kMainTextColor_100 forState:UIControlStateNormal];
    [_collectBtn addTarget:self action:@selector(collectAction) forControlEvents:UIControlEventTouchUpInside];
    [_collectBtn setImageEdgeInsets:UIEdgeInsetsMake(-12, kScreenWidth / 9, 0, 0)];
    [_collectBtn setTitleEdgeInsets:UIEdgeInsetsMake(27, -_collectBtn.imageView.hd_width, 0, 0)];
    [bottomView addSubview:_collectBtn];
    
    self.consultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _consultBtn.frame = CGRectMake( kScreenWidth * 0.2, 1, kScreenWidth * 0.2, 49);
    _consultBtn.backgroundColor = [UIColor whiteColor];
    _consultBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_consultBtn setImage:[UIImage imageNamed:@"package_咨询"] forState:UIControlStateNormal];
    [_consultBtn setTitle:@"咨询" forState:UIControlStateNormal];
    [_consultBtn setTitleColor:kMainTextColor_100 forState:UIControlStateNormal];
    [_consultBtn addTarget:self action:@selector(consultAction) forControlEvents:UIControlEventTouchUpInside];
    [_consultBtn setImageEdgeInsets:UIEdgeInsetsMake(-12, kScreenWidth / 9, 0, 0)];
    [_consultBtn setTitleEdgeInsets:UIEdgeInsetsMake(27, -_collectBtn.imageView.hd_width, 0, 0)];
    [bottomView addSubview:_consultBtn];
    
    self.shoppingCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shoppingCarBtn.frame = CGRectMake( kScreenWidth * 0.4, 1, kScreenWidth * 0.3, 49);
    _shoppingCarBtn.backgroundColor = UIRGBColor(254, 88, 38);
    _shoppingCarBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_shoppingCarBtn setTitle:@"加入购物" forState:UIControlStateNormal];
    [_shoppingCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_shoppingCarBtn addTarget:self action:@selector(shoppingCarAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_shoppingCarBtn];
    
    self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyBtn.frame = CGRectMake( kScreenWidth * 0.7, 1, kScreenWidth * 0.3, 49);
    _buyBtn.backgroundColor = UIRGBColor(254, 88, 38);
    _buyBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_buyBtn];
    
    __weak typeof(self)weakSelf = self;
    self.cansultView = [[CansultTeachersListView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andTeachersArr:[[UserManager sharedManager] getAssistantList]];
    self.cansultView.dismissBlock = ^{
        [weakSelf.cansultView removeFromSuperview];
    };
    self.cansultView.cansultBlock = ^(NSDictionary *infoDic) {
        [weakSelf cantactTeacherAction:infoDic];
    };
    
    self.packageDetailSelectView = [[PackageDetailSelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.packageDetailSelectView.dataArray = self.packageSpecificationArr;
    self.packageDetailSelectView.imageUrl = [self.packageDetailInfoDic objectForKey:@"packageCover"];
    self.packageDetailSelectView.selectBlock = ^(NSDictionary *infoDic) {
        [weakSelf.packageDetailSelectView removeFromSuperview];
        weakSelf.packageSelectSpecificationIndoDic = infoDic;
        [weakSelf.tableview reloadData];
    };
    self.packageDetailSelectView.dismissBlock = ^{
        [weakSelf.packageDetailSelectView removeFromSuperview];
    };
}

- (void)collectAction
{
    
}

- (void)consultAction
{
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    self.cansultView.teachersArray  = [[UserManager sharedManager] getAssistantList];
    [delegate.window addSubview:self.cansultView];
}

- (void)shoppingCarAction
{
    
}

- (void)buyAction
{
    if (self.packageSpecificationArr.count > 0 && self.packageSelectSpecificationIndoDic == nil) {
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
        [delegate.window addSubview:self.packageDetailSelectView];
    }else
    {
        NSMutableDictionary * infoDic = [NSMutableDictionary dictionary];
        if (self.packageSelectSpecificationIndoDic) {
            [infoDic setObject:[self.packageSelectSpecificationIndoDic objectForKey:@"price"] forKey:kPrice];
            [infoDic setObject:[self.packageSelectSpecificationIndoDic objectForKey:@"id"] forKey:kMemberLevelId];
        }else
        {
            [infoDic setObject:[self.packageDetailInfoDic objectForKey:@"packagePrice"] forKey:kPrice];
            [infoDic setObject:self.packageId forKey:kMemberLevelId];
        }
        
        BuyDetailViewController *buyVC = [[BuyDetailViewController alloc]init];
        buyVC.infoDic = infoDic;
        buyVC.payCourseType = PayCourseType_Member;
        [self.navigationController pushViewController:buyVC animated:YES];
    }
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

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        PackageDetailHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:kHeadCellID forIndexPath:indexPath];
        
        [cell resetUIWithInfo:self.packageDetailInfoDic];
        
        return cell;
    }else if (indexPath.row == 1){
        PackageDetailCourseCell * cell = [tableView dequeueReusableCellWithIdentifier:kCourseCellID forIndexPath:indexPath];
        NSString * specificationStr = @"";
        if (self.packageSelectSpecificationIndoDic) {
            specificationStr = [NSString stringWithFormat:@"已选择\"%@\"", [self.packageSelectSpecificationIndoDic objectForKey:@"name"]];
        }else
        {
            specificationStr = @"请选择套餐规格";
        }
        cell.selectCourseLB.text = specificationStr;
        return cell;
    }else
    {
        PackageDetailIntroduceCell * cell = [tableView dequeueReusableCellWithIdentifier:kPackageDetailIntroduce forIndexPath:indexPath];
        [cell resetWitnInfo:self.packageDetailInfoDic];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 230;
    }else if (indexPath.row == 1)
    {
        if (self.packageSpecificationArr.count > 0) {
            return 50;
        }else
        {
            return 0;
        }
    }else
    {
        return 145;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
        [delegate.window addSubview:self.packageDetailSelectView];
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
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
