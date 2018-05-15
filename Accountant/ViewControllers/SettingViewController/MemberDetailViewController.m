//
//  MemberDetailViewController.m
//  Accountant
//
//  Created by aaa on 2017/11/8.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MemberDetailViewController.h"
#import "MSegmentControl.h"
#import "MemberDetailView.h"
#import "BuyDetailViewController.h"
#import "CansultTeachersListView.h"
#import "AppIconViewController.h"

@interface MemberDetailViewController ()<UIWebViewDelegate,UserModule_PayOrderProtocol,UIAlertViewDelegate>

@property (nonatomic, strong)MSegmentControl *memberLevelSegment;
@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)MemberDetailView *memberDetail_K1;
@property (nonatomic, strong)MemberDetailView *memberDetail_K2;
@property (nonatomic, strong)MemberDetailView *memberDetail_K3;
@property (nonatomic, strong)MemberDetailView *memberDetail_K4;
@property (nonatomic, strong)MemberDetailView *memberDetail_K5;

@property (nonatomic, strong)CansultTeachersListView            *cansultView;

@end

@implementation MemberDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationViewSetup];
    
    [self prepareUI];
    
}

- (void)navigationViewSetup
{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, 64)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"会员详情";
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareUI
{
    NSArray * memberLevelArray = [self getMemberListArray];
    
    self.memberLevelSegment = [[MSegmentControl alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 70) andItems:memberLevelArray];
    [self.view addSubview:self.memberLevelSegment];
    
    __weak typeof(self)weakSelf = self;
    self.memberLevelSegment.segmentClickBlock = ^(int index) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.scrollView setContentOffset:CGPointMake(kScreenWidth * index, 0) animated:YES];
        });
    };
    [self.memberLevelSegment selectWith:3];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.memberLevelSegment.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(self.memberLevelSegment.frame) - kStatusBarHeight - self.navigationController.navigationBar.frame.size.height)];
    [self.view addSubview:self.scrollView];
    
    NSArray * detailList = [[UserManager sharedManager] getLevelDetailList];
    
    /*
     //     K1
     //    self.memberDetail_K1 = [[MemberDetailView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.hd_width, self.scrollView.hd_height)];
     //    [self.memberDetail_K1 refreshUIWith:MemberLevel_K1 andInfoDic:(NSDictionary *)infoDic];
     //    [self.scrollView addSubview:self.memberDetail_K1];
     //
     //    // K2
     //    self.memberDetail_K2 = [[MemberDetailView alloc]initWithFrame:CGRectMake( kScreenWidth,0, self.scrollView.hd_width, self.scrollView.hd_height)];
     //    [self.memberDetail_K2 refreshUIWith:MemberLevel_K2];
     //    [self.scrollView addSubview:self.memberDetail_K2];
     //
     //    // K3
     //    self.memberDetail_K3 = [[MemberDetailView alloc]initWithFrame:CGRectMake( kScreenWidth * 2,0, self.scrollView.hd_width, self.scrollView.hd_height)];
     //    [self.memberDetail_K3 refreshUIWith:MemberLevel_K3];
     //    [self.scrollView addSubview:self.memberDetail_K3];
     //
     //    // K4
     //    self.memberDetail_K4 = [[MemberDetailView alloc]initWithFrame:CGRectMake( kScreenWidth * 3,0, self.scrollView.hd_width, self.scrollView.hd_height)];
     //    [self.memberDetail_K4 refreshUIWith:MemberLevel_K4];
     //    [self.scrollView addSubview:self.memberDetail_K4];
     //
     //    // K5
     //    self.memberDetail_K5 = [[MemberDetailView alloc]initWithFrame:CGRectMake( kScreenWidth * 4,0, self.scrollView.hd_width, self.scrollView.hd_height)];
     //    [self.memberDetail_K5 refreshUIWith:MemberLevel_K5];
     //    [self.scrollView addSubview:self.memberDetail_K5];
     */
    
 
    
    for (int i = 0; i < detailList.count; i++) {
        MemberDetailView * memberDetailView = [[MemberDetailView alloc]initWithFrame:CGRectMake( kScreenWidth * i,0, self.scrollView.hd_width, self.scrollView.hd_height)];
        [memberDetailView refreshUIWith:i andInfoDic:detailList[i]];
        [self.scrollView addSubview:memberDetailView];
        
        memberDetailView.memberCansultBlock = ^{
            [weakSelf cansultAction];
        };
        memberDetailView.memberBuyBlock = ^(NSDictionary *infoDic) {
            [weakSelf buyMemberAction:infoDic];
        };
    }
    
    self.scrollView.scrollEnabled = NO;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 5, self.scrollView.hd_height);
    
//    [self disposeAction];
    
    self.cansultView = [[CansultTeachersListView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andTeachersArr:[[UserManager sharedManager] getAssistantList]];
    self.cansultView.dismissBlock = ^{
        [weakSelf.cansultView removeFromSuperview];
    };
    self.cansultView.cansultBlock = ^(NSDictionary *infoDic) {
        [weakSelf cantactTeacherAction:infoDic];
    };
}

- (NSArray *)getMemberListArray
{
    NSMutableArray * array = [NSMutableArray array];
    for (NSDictionary * infoDic in [[UserManager sharedManager] getLevelDetailList]) {
        
        if ([[infoDic objectForKey:kMemberLevel] length] > 2) {
            NSString * string = [infoDic objectForKey:kMemberLevel];
            NSString * str1 = [string substringWithRange:NSMakeRange(0, 2)];
            NSString * str2 = [string substringWithRange:NSMakeRange(2, string.length - 2)];
            NSString * nStr = [NSString stringWithFormat:@"%@\n%@", str1, str2];
            [array addObject:nStr];
        }else
        {
            [array addObject:[infoDic objectForKey:kMemberLevel]];
        }
        
    }
    return array;
}

- (void)cansultAction
{
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    [delegate.window addSubview:self.cansultView];
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

- (void)buyMemberAction:(NSDictionary *)infoDic
{
    NSLog(@"buy %@", infoDic);
    
    if ([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled]) {
        BuyDetailViewController *buyVC = [[BuyDetailViewController alloc]init];
        buyVC.infoDic = infoDic;
        buyVC.payCourseType = PayCourseType_Member;
        [self.navigationController pushViewController:buyVC animated:YES];
        
    }else
    {
        NSLog(@"%@", infoDic);
        if ([[infoDic objectForKey:kPrice] intValue] > [[UserManager sharedManager] getMyGoldCoins]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的金币数量不足请先购买金币" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }else
        {
            [SVProgressHUD show];
            NSDictionary * infoDic1 = @{@"courseId":[infoDic objectForKey:kMemberLevelId],
                                        @"payType":@3,
                                        @"courseType":@(PayCourseType_Member),
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

@end
