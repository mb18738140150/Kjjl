//
//  VerifyAccountViewController.m
//  Accountant
//
//  Created by aaa on 2017/9/15.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "VerifyAccountViewController.h"
#import "ForgetPasswordViewController.h"
#define kImageWidth 25
@interface VerifyAccountViewController ()<UITextFieldDelegate,UserModule_VerifyAccountProtocol>

@property (nonatomic, strong)UITextField * account;
@property (nonatomic, strong)UIButton *nextBtn;

@end

@implementation VerifyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"第一步";
    self.view.backgroundColor = [UIColor whiteColor];
    [self prepareUI];
}

- (void)prepareUI
{
    UIControl *resignControl = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [resignControl addTarget:self action:@selector(resignTextFiled) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resignControl];
    
    // 手机
    UIView * accountView = [[UIView alloc]initWithFrame:CGRectMake(20, 80, kScreenWidth - 40, 40)];
    accountView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:accountView];
    
    UIImageView * accountImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, kImageWidth, kImageWidth)];
    accountImageView.image = [UIImage imageNamed:@"手机(1)"];
    [accountView addSubview:accountImageView];
    
    _account=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accountImageView.frame) + 10, 10, accountView.hd_width - 70, 20)];
    [_account setBackgroundColor:[UIColor clearColor]];
    _account.placeholder=[NSString stringWithFormat:@"请输入账号"];
    _account.delegate = self;
    _account.font = kMainFont;
    _account.textColor = kCommonMainTextColor_50;
    [accountView addSubview:_account];
    
    UIView * accountBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, accountView.hd_height - 1, accountView.hd_width, 1)];
    accountBottomView.backgroundColor = kCommonMainTextColor_200;
    [accountView addSubview:accountBottomView];

    
    _nextBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_nextBtn setFrame:CGRectMake(20, CGRectGetMaxY(accountView.frame) + 70, kScreenWidth - 40, 40)];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBtn.layer.cornerRadius = _nextBtn.hd_height / 2;
    _nextBtn.layer.masksToBounds = YES;
    _nextBtn.layer.borderColor = kCommonMainTextColor_150.CGColor;
    _nextBtn.layer.borderWidth = 0.5;
    [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn setBackgroundColor:[UIColor whiteColor]];
    [_nextBtn setTitleColor:kCommonMainTextColor_150 forState:UIControlStateNormal];
    [self.view addSubview:_nextBtn];
}

- (void)nextAction
{
    if (self.account.text.length != 0) {
        [[UserManager sharedManager] getVerifyAccountWithAccountNumber:self.account.text withNotifiedObject:self];
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"账号不能为空"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
}

- (void)resignTextFiled
{
    [_account resignFirstResponder];
}

- (void)didVerifyAccountSuccessed
{
    ForgetPasswordViewController * forgrtVC = [[ForgetPasswordViewController alloc]init];
    forgrtVC.accountNumber = self.account.text;
    forgrtVC.verifyPhoneNumber = [[UserManager sharedManager] getVerifyPhoneNumber];
    [self.navigationController pushViewController:forgrtVC animated:YES];
}

- (void)didVerifyAccountFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

@end
