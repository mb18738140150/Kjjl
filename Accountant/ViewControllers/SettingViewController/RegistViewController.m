//
//  RegistViewController.m
//  Accountant
//
//  Created by aaa on 2017/9/12.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "RegistViewController.h"
#import "CompleteInfoViewController.h"
#define kImageWidth 25

@interface RegistViewController ()<UITextFieldDelegate,UserModule_RegistProtocol,UserModule_VerifyCodeProtocol,UserModule_LoginProtocol>

@property (nonatomic,strong) UITextField                *account;
@property (nonatomic,strong) UITextField                *verifyTF;
@property (nonatomic,strong) UITextField                *password;
@property (nonatomic,strong) UITextField                *surePassword;
@property (nonatomic,strong) UIButton                   *loginButton;

@property (nonatomic,strong) UIButton                   *getVerifyBtn;
@property (nonatomic,strong) NSTimer                    *timer;
@property (nonatomic,assign) int                        count;
// 获取到验证码时间
@property (nonatomic, strong)NSDate * codeDate;
@end

static int a = 59;

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注 册";
    _count = a;
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
    
    _account=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accountImageView.frame) + 10, 0, accountView.hd_width - 35, 40)];
    [_account setBackgroundColor:[UIColor clearColor]];
    _account.placeholder=[NSString stringWithFormat:@"请输入账号"];
    _account.delegate = self;
    _account.font = kMainFont;
    _account.returnKeyType = UIReturnKeyDone;
    _account.textColor = kCommonMainTextColor_50;
    [accountView addSubview:_account];
    
    UIView * accountBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, accountView.hd_height - 1, accountView.hd_width, 1)];
    accountBottomView.backgroundColor = kCommonMainTextColor_200;
    [accountView addSubview:accountBottomView];
    
    // 验证码
    UIView * verifyView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(accountView.frame) + 20, kScreenWidth - 40, 40)];
    verifyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:verifyView];
    
    UIImageView * verifyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, kImageWidth, kImageWidth)];
    verifyImageView.image = [UIImage imageNamed:@"验证码"];
    [verifyView addSubview:verifyImageView];
    
    _verifyTF=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(verifyImageView.frame) + 10, 10, kScreenWidth-40 - 30 - 80 - 15, 20)];
    [_verifyTF setBackgroundColor:[UIColor clearColor]];
    _verifyTF.secureTextEntry = YES;
    _verifyTF.placeholder=[NSString stringWithFormat:@"请输入验证码"];
    _verifyTF.layer.cornerRadius=5.0;
    _verifyTF.delegate = self;
    _verifyTF.font = kMainFont;
    _verifyTF.returnKeyType = UIReturnKeyDone;
    _verifyTF.textColor = kCommonMainTextColor_50;
    [verifyView addSubview:_verifyTF];
    
    self.getVerifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getVerifyBtn.frame = CGRectMake(CGRectGetMaxX(_verifyTF.frame) - 5, _verifyTF.hd_y - 5, 85, _verifyTF.hd_height + 10);
    [self.getVerifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getVerifyBtn.layer.cornerRadius = self.getVerifyBtn.hd_height / 2;
    _getVerifyBtn.layer.masksToBounds = YES;
    _getVerifyBtn.layer.borderColor = kCommonMainTextColor_150.CGColor;
    _getVerifyBtn.layer.borderWidth = 0.5;
    [_getVerifyBtn setTitleColor:kCommonMainTextColor_150 forState:UIControlStateNormal];
    _getVerifyBtn.titleLabel.font = kMainFont;
    [verifyView addSubview:self.getVerifyBtn];
    [_getVerifyBtn addTarget:self action:@selector(getVerifyCodeAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * verifyBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, verifyView.hd_height - 1, verifyView.hd_width, 1)];
    verifyBottomView.backgroundColor = kCommonMainTextColor_200;
    [verifyView addSubview:verifyBottomView];
    
    
    // 密码
    UIView * passwordView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(verifyView.frame) + 20, kScreenWidth - 40, 40)];
    passwordView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:passwordView];
    
    UIImageView * passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, kImageWidth, kImageWidth)];
    passwordImageView.image = [UIImage imageNamed:@"密码"];
    [passwordView addSubview:passwordImageView];
    
    _password=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passwordImageView.frame) + 10, 0, kScreenWidth-40, 40)];
    [_password setBackgroundColor:[UIColor clearColor]];
    _password.secureTextEntry = YES;
    _password.placeholder=[NSString stringWithFormat:@"请输入密码"];
    _password.layer.cornerRadius=5.0;
    _password.delegate = self;
    _password.font = kMainFont;
    _password.textColor = kCommonMainTextColor_50;
    _password.returnKeyType = UIReturnKeyDone;
    [passwordView addSubview:_password];
    
    UIView * passwordBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, passwordView.hd_height - 1, passwordView.hd_width, 1)];
    passwordBottomView.backgroundColor = kCommonMainTextColor_200;
    [passwordView addSubview:passwordBottomView];
    
    
    // 确认密码
    UIView * surePasswordView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(passwordView.frame) + 20, kScreenWidth - 40, 40)];
    surePasswordView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:surePasswordView];
    
    UIImageView * surePasswordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, kImageWidth, kImageWidth)];
    surePasswordImageView.image = [UIImage imageNamed:@"密码"];
    [surePasswordView addSubview:surePasswordImageView];
    
    _surePassword=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(surePasswordImageView.frame) + 10, 0, kScreenWidth-40, 40)];
    [_surePassword setBackgroundColor:[UIColor clearColor]];
    _surePassword.secureTextEntry = YES;
    _surePassword.placeholder=[NSString stringWithFormat:@"请再次输入密码"];
    _surePassword.layer.cornerRadius=5.0;
    _surePassword.delegate = self;
    _surePassword.font = kMainFont;
    _surePassword.returnKeyType = UIReturnKeyDone;
    _surePassword.textColor = kCommonMainTextColor_50;
    [surePasswordView addSubview:_surePassword];
    
    UIView * surePasswordBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, surePasswordView.hd_height - 1, surePasswordView.hd_width, 1)];
    surePasswordBottomView.backgroundColor = kCommonMainTextColor_200;
    [surePasswordView addSubview:surePasswordBottomView];
    
    
    _loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_loginButton setFrame:CGRectMake(20, CGRectGetMaxY(surePasswordView.frame) + 70, kScreenWidth - 40, 40)];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [_loginButton setTitle:@"立即注册" forState:UIControlStateNormal];
    _loginButton.layer.cornerRadius = _loginButton.hd_height / 2;
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.borderColor = kCommonMainTextColor_150.CGColor;
    _loginButton.layer.borderWidth = 0.5;
    [_loginButton addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setBackgroundColor:[UIColor whiteColor]];
    [_loginButton setTitleColor:kCommonMainTextColor_150 forState:UIControlStateNormal];
    [self.view addSubview:_loginButton];
    
    UIButton * loginBT = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBT.frame = CGRectMake(CGRectGetMaxX(_loginButton.frame) - 130, CGRectGetMaxY(_loginButton.frame) + 10, 130, 20);
    loginBT.titleLabel.font = kMainFont;
    loginBT.titleLabel.textAlignment = NSTextAlignmentRight;
    [loginBT setTitle:@"已有账号？马上登录" forState:UIControlStateNormal];
    [loginBT setTitleColor:kCommonMainColor forState:UIControlStateNormal];
    [self.view addSubview:loginBT];
    [loginBT addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)getVerifyCodeAction
{
    
    [[UserManager sharedManager] getVerifyCodeWithPhoneNumber:self.account.text withNotifiedObject:self];
    
    _getVerifyBtn.enabled = NO;
    __weak typeof(self)weakSelf = self;
    self.timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (weakSelf.count == 0) {
            weakSelf.getVerifyBtn.enabled = YES;
            weakSelf.count = a;
            [weakSelf.timer invalidate];
            weakSelf.timer = nil;
            [weakSelf.getVerifyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
            return ;
        }
        [weakSelf.getVerifyBtn setTitle:[NSString stringWithFormat:@"%ds", weakSelf.count] forState:UIControlStateNormal];
        weakSelf.count--;
//        NSLog(@"剩余 %ds",weakSelf.count);
    }];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)registAction
{
//    CompleteInfoViewController * comVC = [[CompleteInfoViewController alloc]init];
//    [self.navigationController pushViewController:comVC animated:YES];
//    return;
    
    if (self.account.text.length == 0 || self.password.text.length == 0 || self.surePassword.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"手机号与密码均不能为空"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    if (![self.surePassword.text isEqualToString:self.password.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    
    if (![[[NSString stringWithFormat:@"%@231618", self.verifyTF.text] MD5_Cap] isEqualToString:[[UserManager sharedManager] getVerifyCode]]) {
        
        NSTimeInterval seconds = [[NSDate date]timeIntervalSinceDate:self.codeDate];
        if (seconds >120) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"时间超时,请重新获取验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"验证码不正确"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
        
        return;
    }
    [self timeInvalidate];
    [SVProgressHUD show];
    NSDictionary * infoDic = @{@"phoneNumber":self.account.text,
                               @"password":self.password.text};
    [[UserManager sharedManager] registWithDic:infoDic withNotifiedObject:self];
    
}

- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resignTextFiled
{
    [_account resignFirstResponder];
    [_verifyTF resignFirstResponder];
    [_password resignFirstResponder];
}
- (void)dealloc
{
    [self timeInvalidate];
}

- (void)timeInvalidate
{
    self.getVerifyBtn.enabled = YES;
    [self.getVerifyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)didVerifyCodeSuccessed
{
//     [self timeInvalidate];
    self.codeDate = [NSDate date];
}

- (void)didVerifyCodeFailed:(NSString *)failInfo
{
//     [self timeInvalidate];
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRegistSuccessed
{
     [self timeInvalidate];
    
    [[UserManager sharedManager]loginWithUserName:self.account.text andPassword:self.password.text withNotifiedObject:self];
}

- (void)didRegistFailed:(NSString *)failInfo
{
     [self timeInvalidate];
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didUserLoginSuccessed
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"注册成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    CompleteInfoViewController * comVC = [[CompleteInfoViewController alloc]init];
    [self.navigationController pushViewController:comVC animated:YES];
    return;
}

- (void)didUserLoginFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"注册成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
