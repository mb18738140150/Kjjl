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
#import <WebKit/WebKit.h>
#import "AppIconViewController.h"
#define kHeadCellID @"PackageDetailHeadCell"
#define kCourseCellID @"PackageDetailCourseCellID"
#define kPackageDetailIntroduce @"PackageDetailIntroduceCell"


@interface PackageDetailViewController ()<UITableViewDelegate, UITableViewDataSource,UIWebViewDelegate,UIScrollViewDelegate,WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,UserModule_PayOrderProtocol,UIAlertViewDelegate>

@property (nonatomic, strong)UITableView * tableview;
@property (nonatomic, strong)UISegmentedControl * topSegment;
@property (nonatomic, strong)CansultTeachersListView            *cansultView;
@property (nonatomic, strong)WKWebView * webView;
@property (nonatomic, strong)UIButton *collectBtn;
@property (nonatomic, strong)UIButton * consultBtn;
@property (nonatomic, strong)UIButton * shoppingCarBtn;
@property (nonatomic, strong)UIButton * buyBtn;
@property (nonatomic, strong)PackageDetailSelectView * packageDetailSelectView;

@property (nonatomic, strong)NSDictionary * packageDetailInfoDic;
@property (nonatomic, strong)NSArray * packageSpecificationArr;// 规格列表
@property (nonatomic, strong)NSDictionary * packageSelectSpecificationIndoDic;// 已选套餐规格

@property (nonatomic, strong)NSMutableArray * introduceImageArr;

@end

@implementation PackageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.packageDetailInfoDic = [[CourseraManager sharedManager] getPackageDetailInfo];
    self.packageSpecificationArr = [self.packageDetailInfoDic objectForKey:@"data"];
    [self navigationViewSetup];
    
//    NSString * introduceStr = [self.packageDetailInfoDic objectForKey:@"packageIntroduce"];
//    NSArray * introduceArr = [introduceStr componentsSeparatedByString:@","];
//    self.introduceImageArr = [NSMutableArray array];
//    __weak typeof(self)weakSelf = self;
//    for (NSString * imageStr in introduceArr) {
//        UIImageView * imageView = [[UIImageView alloc]init];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            [weakSelf.tableview reloadData];
//        }];
//        [self.introduceImageArr addObject:imageView];
//    }
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
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth / 14.0 * 8 + 95 + 90) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"PackageDetailHeadCell" bundle:nil] forCellReuseIdentifier:kHeadCellID];
    [self.tableview registerNib:[UINib nibWithNibName:@"PackageDetailCourseCell" bundle:nil] forCellReuseIdentifier:kCourseCellID];
    [self.tableview registerClass:[PackageDetailIntroduceCell class] forCellReuseIdentifier:kPackageDetailIntroduce];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:self.tableview];
    
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableview.frame), kScreenWidth, kScreenHeight - 45 - kNavigationBarHeight - kStatusBarHeight)];
    [self.view addSubview:_webView];
    
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.scrollView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.packageDetailInfoDic objectForKey:@"packageIntroduce"]]]];
    [_webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 50 - kNavigationBarHeight - kStatusBarHeight, kScreenWidth, 50)];
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
//    [bottomView addSubview:_collectBtn];
    
    self.consultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _consultBtn.frame = CGRectMake( 0, 1, kScreenWidth * 0.5, 49);
    _consultBtn.backgroundColor = [UIColor whiteColor];
    _consultBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_consultBtn setImage:[UIImage imageNamed:@"package_咨询"] forState:UIControlStateNormal];
    [_consultBtn setTitle:@"咨询" forState:UIControlStateNormal];
    [_consultBtn setTitleColor:kMainTextColor_100 forState:UIControlStateNormal];
    [_consultBtn addTarget:self action:@selector(consultAction) forControlEvents:UIControlEventTouchUpInside];
    [_consultBtn setImageEdgeInsets:UIEdgeInsetsMake(-12, 30, 0, 0)];
    [_consultBtn setTitleEdgeInsets:UIEdgeInsetsMake(27, -_collectBtn.imageView.hd_width, 0, 0)];
    [bottomView addSubview:_consultBtn];
    
    self.shoppingCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shoppingCarBtn.frame = CGRectMake( kScreenWidth * 0.4, 1, kScreenWidth * 0.3, 49);
    _shoppingCarBtn.backgroundColor = UIRGBColor(254, 88, 38);
    _shoppingCarBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_shoppingCarBtn setTitle:@"加入购物" forState:UIControlStateNormal];
    [_shoppingCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_shoppingCarBtn addTarget:self action:@selector(shoppingCarAction) forControlEvents:UIControlEventTouchUpInside];
//    [bottomView addSubview:_shoppingCarBtn];
    
    self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyBtn.frame = CGRectMake( kScreenWidth * 0.5, 1, kScreenWidth * 0.5, 49);
    _buyBtn.backgroundColor = UIRGBColor(254, 88, 38);
    _buyBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_buyBtn];
    
//    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
//        self.buyBtn.hidden = NO;
//    }else
//    {
//        self.buyBtn.hidden = YES;
//        _consultBtn.frame = CGRectMake( 0, 1, kScreenWidth, 49);
//    }
    
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
        
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
            BuyDetailViewController *buyVC = [[BuyDetailViewController alloc]init];
            buyVC.infoDic = infoDic;
            buyVC.payCourseType = PayCourseType_Member;
            [self.navigationController pushViewController:buyVC animated:YES];
        }else
        {
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
}

- (void)didRequestPayOrderFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
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
//    return 3 + self.introduceImageArr.count;
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
    }else if (indexPath.row == 2){
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
        
        UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        topView.backgroundColor = UIColorFromRGB(0xf5f5f5);
        [cell.contentView addSubview:topView];
        
        UIView * tipView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, 3, 13)];
        tipView.backgroundColor = UIRGBColor(241, 82, 58);
        [cell.contentView addSubview:tipView];
        
        UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(23, 19, kScreenWidth - 23, 15)];
        titleLB.text = @"课程介绍";
        titleLB.textColor = UIColorFromRGB(0x333333);
        titleLB.font = kMainFont;
        [cell.contentView addSubview:titleLB];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        __weak typeof(self)weakSelf = self;
        PackageDetailIntroduceCell * cell = [tableView dequeueReusableCellWithIdentifier:kPackageDetailIntroduce forIndexPath:indexPath];
        
        [cell resetWithInfo:self.packageDetailInfoDic];
//        [cell resetWitnInfo:@{@"packageIntroduce":@""} andImage:self.introduceImageArr[indexPath.row - 3]];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return kScreenWidth / 14.0 * 8 + 90;
    }else if (indexPath.row == 1)
    {
        if (self.packageSpecificationArr.count > 0) {
            return 50;
        }else
        {
            return 0;
        }
    }else if (indexPath.row == 2)
    {
        return 45;
    }
    else
    {
        return kScreenHeight - 45 - kNavigationBarHeight - kStatusBarHeight;
        
        UIImageView * imageView = self.introduceImageArr[indexPath.row - 3];
        UIImage * image = imageView.image;
        if (image) {
            CGFloat height =  0 ;
            if (image.size.width > 0) {
                height = image.size.height*1.0 / image.size.width * (kScreenWidth );
            }else
            {
                height = 100;
            }
            if (height >= 0) {
                return height;
            }else
            {
                return 100;
            }
        }else
        {
            return 100;
        }
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
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
//    NSLog(@" ***** %@", change);
    CGPoint point = [[change objectForKey:@"new"] CGPointValue];
    CGFloat y = point.y;
    
        if (y > 0) {
            if (self.webView.hd_y >= 0) {
                self.tableview.hd_y = -y;
                self.webView.hd_y = CGRectGetMaxY(self.tableview.frame);
                [_webView.scrollView setScrollsToTop:YES];
            }else
            {
                
            }
        }else
        {
            if (y < 0) {
                if (self.webView.hd_y < self.tableview.hd_height) {
                    self.tableview.hd_y = -y;
                    self.webView.hd_y = CGRectGetMaxY(self.tableview.frame);
                    [_webView.scrollView setScrollsToTop:YES];
                }else
                {
                    
                }
            }
        }
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
//    decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
//    decisionHandler(WKNavigationActionPolicyCancel);
}
#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}

- (void)dealloc
{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentOffset"];
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
