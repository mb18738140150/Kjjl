//
//  AssistantViewController.m
//  Accountant
//
//  Created by aaa on 2018/1/9.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "AssistantViewController.h"
#import "MKPPlaceholderTextView.h"
#import "HelpCenterView.h"
#import "HYSegmentedControl.h"
#import "ProblemContentViewController.h"

@interface AssistantViewController ()<UITextViewDelegate,UIWebViewDelegate,UserModule_SubmitOperationProtocol,HYSegmentedControlDelegate,UITableViewDelegate,UITableViewDataSource,UserModule_AssistantCenterProtocol>

@property (nonatomic, strong)MKPPlaceholderTextView * opinionTextView;
@property (nonatomic, strong)UIControl * control;
@property (nonatomic, strong)HelpCenterView * helpView;
@property (nonatomic, strong)HYSegmentedControl * segmentControl;
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSArray * dataArray;

@end

@implementation AssistantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navigationViewSetup];
    [self prepareUI];
    [self getAssistantLiat];
}

- (void)navigationViewSetup
{
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, 64)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"客服中心";
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

- (void)prepareUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.control = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.control addTarget:self action:@selector(touchAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.control];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 15, 3, 13)];
    lineView.backgroundColor = UIColorFromRGB(0x1c71fa);
    [self.view addSubview:lineView];
    
    UILabel * opinionLB= [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame) + 5, 14, 100, 15)];
    opinionLB.text = @"意见反馈";
    opinionLB.textColor = UIColorFromRGB(0x333333);
    opinionLB.font = kMainFont;
    [self.view addSubview:opinionLB];
    
    MKPPlaceholderTextView *textView = [[MKPPlaceholderTextView alloc]init];
    textView.placeholder = @"想对我们说点什么？";
    textView.frame = CGRectMake(10, CGRectGetMaxY(opinionLB.frame) + 10, kScreenWidth - 20, 105);
    textView.delegate = self;
    textView.layer.cornerRadius = 1;
    textView.layer.masksToBounds = YES;
    textView.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
    textView.layer.borderWidth = 1;
    [self.view addSubview:textView];
    self.opinionTextView = textView;
    
    UIButton * opinionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    opinionBtn.frame = CGRectMake(kScreenWidth - 86, CGRectGetMaxY(textView.frame) + 10, 76, 33);
    opinionBtn.backgroundColor = UIColorFromRGB(0x1c71fa);
    opinionBtn.layer.cornerRadius = 2;
    opinionBtn.layer.masksToBounds = YES;
    [opinionBtn setTitle:@"提交" forState:UIControlStateNormal];
    [opinionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    opinionBtn.titleLabel.font = kMainFont;
    [opinionBtn addTarget:self action:@selector(submitOpinionAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:opinionBtn];
    
    UIView * seperateLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(opinionBtn.frame) + 15, kScreenWidth, 9)];
    seperateLine.backgroundColor = UIColorFromRGB(0xedf0f0);
    [self.view addSubview:seperateLine];
    
    UIView * problemLineView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(seperateLine.frame) + 15, 3, 13)];
    problemLineView.backgroundColor = UIColorFromRGB(0x1c71fa);
    [self.view addSubview:problemLineView];
    
    UILabel * peoblemLB= [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(problemLineView.frame) + 5, problemLineView.hd_y - 1, 100, 15)];
    peoblemLB.text = @"常见问题";
    peoblemLB.textColor = UIColorFromRGB(0x333333);
    peoblemLB.font = kMainFont;
    [self.view addSubview:peoblemLB];
    
    self.segmentControl = [[HYSegmentedControl alloc]initWithOriginY:CGRectGetMaxY(problemLineView.frame)  Titles:[self getProblemTitleList] delegate:self];
    [self.view addSubview:self.segmentControl];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(problemLineView.frame) + 42, kScreenWidth, kScreenHeight - CGRectGetMaxY(self.segmentControl.frame) - kStatusBarHeight - kNavigationBarHeight - 50) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:self.tableView];
    if ([[[UserManager sharedManager] getCommonProblemList] count] > 0) {
        self.dataArray = [[[[UserManager sharedManager] getCommonProblemList] firstObject] objectForKey:@"problem"];
    }else
    {
        self.dataArray  = [NSArray array];
    }
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - 50, kScreenWidth, 50)];
    bottomView.backgroundColor = UIColorFromRGB(0xedf0f0);
    [self.view addSubview:bottomView];
    
    UIButton * telephoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    telephoneBtn.frame = CGRectMake(0, 1, (kScreenWidth - 1) / 2.0, 49);
    telephoneBtn.backgroundColor = [UIColor whiteColor];
    [telephoneBtn setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    [telephoneBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [telephoneBtn setTitle:@"热线电话" forState:UIControlStateNormal];
    telephoneBtn.titleLabel.font = kMainFont;
    [bottomView addSubview:telephoneBtn];
    
    UIButton * assistantBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    assistantBtn.frame = CGRectMake(CGRectGetMaxX(telephoneBtn.frame) + 1, 1, (kScreenWidth - 1) / 2.0, 49);
    assistantBtn.backgroundColor = [UIColor whiteColor];
    [assistantBtn setImage:[UIImage imageNamed:@"icon_kefu"] forState:UIControlStateNormal];
    [assistantBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [assistantBtn setTitle:@"在线客服" forState:UIControlStateNormal];
    assistantBtn.titleLabel.font = kMainFont;
    [bottomView addSubview:assistantBtn];
    
    [telephoneBtn addTarget:self action:@selector(telephoneAction) forControlEvents:UIControlEventTouchUpInside];
    [assistantBtn addTarget:self action:@selector(assistantAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addHelpView];
    
}

- (void)getAssistantLiat
{
    [[UserManager sharedManager] didRequestAssistantWithInfo:@{} withNotifiedObject:self];
}


- (void)didRequestAssistantCenterSuccessed
{
    
}
- (void)didRequestAssistantCenterFailed:(NSString *)failedInfo
{
    
}

- (void)addHelpView
{
    __weak typeof(self)weakSelf = self;
    self.helpView = [[HelpCenterView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.helpView.dismissBlock = ^{
        [weakSelf.helpView removeFromSuperview];
    };
    
    self.helpView.telephoneBlock = ^(NSString *telStr) {
        NSLog(@"打电话");
        [weakSelf telephoneAction:telStr];
    };
    
    self.helpView.cansultBlock = ^(NSDictionary *infoDic) {
        NSLog(@"QQ");
        [weakSelf cantactTeacherAction:infoDic];
    };
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length >= 250) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 250)];
    }
}


- (void)submitOpinionAction
{
    if (self.opinionTextView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"意见不能为空"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }else
    {
        [[UserManager sharedManager] didRequestSubmitOpinionWithInfo:@{@"opinion":self.opinionTextView.text} withNotifiedObject:self];
        [SVProgressHUD show];
    }
}

- (NSMutableArray *)getProblemTitleList
{
    NSArray * dataArray = [[UserManager sharedManager] getCommonProblemList];
    NSMutableArray * mArray = [NSMutableArray array];
    for (NSDictionary * infoDic in dataArray) {
        NSString * name = [infoDic objectForKey:@"problemCategoryName"];
        [mArray addObject:name];
    }
    return mArray;
}

- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    NSArray * dataArray = [[UserManager sharedManager] getCommonProblemList];
    self.dataArray = [[dataArray objectAtIndex:index] objectForKey:@"problem"];
    [self.tableView reloadData];
}

#pragma mark - submitOpinion delegate
- (void)didRequestSubmitOperationSuccessed
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"提交成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestSubmitOperationFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
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

- (void)telephoneAction:(NSString *)telStr
{
    NSMutableString * mStr = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"tel:%@", telStr]];
    UIWebView * callWebView = [[UIWebView alloc]init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:mStr]]];
    [self.view addSubview:callWebView];
}

- (void)touchAction
{
    [self.opinionTextView resignFirstResponder];
}

- (void)telephoneAction
{
    [self.helpView resetViewWith:HelpType_tel];
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    [delegate.window addSubview:self.helpView];
}

- (void)assistantAction
{
    [self.helpView resetViewWith:HelpType_assistant];
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    [delegate.window addSubview:self.helpView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    [cell.contentView removeAllSubviews];
    UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 44)];
    titleLB.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"problemTitle"];
    titleLB.textColor = UIColorFromRGB(0x666666);
    titleLB.font = kMainFont;
    [cell.contentView addSubview:titleLB];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * infoDic = [self.dataArray objectAtIndex:indexPath.row];
    ProblemContentViewController * ProVC = [[ProblemContentViewController alloc]init];
    ProVC.title = [infoDic objectForKey:@"problemTitle"];
    ProVC.name = [infoDic objectForKey:@"problemContent"];
    
    NSLog(@"[infoDic objectForKey:@\"problemContent\"] = %@", [infoDic objectForKey:@"problemContent"]);
    
    [self.navigationController pushViewController:ProVC animated:YES];
    
    
}

@end
