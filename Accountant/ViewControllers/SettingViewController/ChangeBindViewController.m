//
//  ChangeBindViewController.m
//  Accountant
//
//  Created by aaa on 2017/9/18.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "ChangeBindViewController.h"
#define kImageWidth 25


@interface ChangeBindViewController ()<UITextFieldDelegate,UserModule_CompleteUserInfoProtocol,UserModule_VerifyCodeProtocol>

@property (nonatomic,strong) UITextField                *account;
@property (nonatomic,strong) UITextField                *verifyTF;
@property (nonatomic,strong) UITextField                *nPhoeNumber;
@property (nonatomic,strong) UIButton                   *loginButton;

@property (nonatomic,strong) UIButton                   *getVerifyBtn;
@property (nonatomic,strong) NSTimer                    *timer;
@property (nonatomic,assign) int                        count;

@end

static int a = 59;

@implementation ChangeBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"第二步";
    _count = a;
    [self navigationViewSetup];
    [self prepareUI];
    
}
#pragma mark - ui setup
- (void)navigationViewSetup
{
    self.navigationItem.title = @"修改绑定手机号码";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    UIControl *resignControl = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [resignControl addTarget:self action:@selector(resignTextFiled) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resignControl];
    
    // 手机
    UIView * accountView = [[UIView alloc]initWithFrame:CGRectMake(20, 16, kScreenWidth - 40, 40)];
    accountView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:accountView];
    
    UIImageView * accountImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, kImageWidth, kImageWidth)];
    accountImageView.image = [UIImage imageNamed:@"手机(1)"];
    [accountView addSubview:accountImageView];
    
    _account=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accountImageView.frame) + 10, 10, accountView.hd_width - 70, 20)];
    [_account setBackgroundColor:[UIColor clearColor]];
    _account.placeholder=[NSString stringWithFormat:@"请输入手机号"];
    _account.delegate = self;
    _account.font = kMainFont;
    _account.textColor = kCommonMainTextColor_50;
    
    _account.enabled = NO;
    [accountView addSubview:_account];
    
    UIView * accountBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, accountView.hd_height - 1, accountView.hd_width, 1)];
    accountBottomView.backgroundColor = kCommonMainTextColor_200;
    [accountView addSubview:accountBottomView];
    
    
    if (self.isBind) {
        
        _loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_loginButton setFrame:CGRectMake(20, CGRectGetMaxY(accountView.frame) + 70, kScreenWidth - 40, 40)];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [_loginButton setTitle:@"保存修改" forState:UIControlStateNormal];
        _loginButton.layer.cornerRadius = _loginButton.hd_height / 2;
        _loginButton.layer.masksToBounds = YES;
        _loginButton.layer.borderColor = kCommonMainTextColor_150.CGColor;
        _loginButton.layer.borderWidth = 0.5;
        [_loginButton addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
        [_loginButton setBackgroundColor:[UIColor whiteColor]];
        [_loginButton setTitleColor:kCommonMainTextColor_150 forState:UIControlStateNormal];
        [self.view addSubview:_loginButton];
        return;
    }
    
    _account.text = self.verifyPhoneNumber;
    
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
    passwordImageView.image = [UIImage imageNamed:@"手机(1)"];
    [passwordView addSubview:passwordImageView];
    
    _nPhoeNumber=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passwordImageView.frame) + 10, 10, kScreenWidth-40, 20)];
    [_nPhoeNumber setBackgroundColor:[UIColor clearColor]];
    _nPhoeNumber.secureTextEntry = YES;
    _nPhoeNumber.placeholder=[NSString stringWithFormat:@"请输入新的手机号"];
    _nPhoeNumber.layer.cornerRadius=5.0;
    _nPhoeNumber.delegate = self;
    _nPhoeNumber.font = kMainFont;
    _nPhoeNumber.textColor = kCommonMainTextColor_50;
    [passwordView addSubview:_nPhoeNumber];
    
    UIView * passwordBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, passwordView.hd_height - 1, passwordView.hd_width, 1)];
    passwordBottomView.backgroundColor = kCommonMainTextColor_200;
    [passwordView addSubview:passwordBottomView];
    
    
    _loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_loginButton setFrame:CGRectMake(20, CGRectGetMaxY(passwordView.frame) + 70, kScreenWidth - 40, 40)];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [_loginButton setTitle:@"保存修改" forState:UIControlStateNormal];
    _loginButton.layer.cornerRadius = _loginButton.hd_height / 2;
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.borderColor = kCommonMainTextColor_150.CGColor;
    _loginButton.layer.borderWidth = 0.5;
    [_loginButton addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setBackgroundColor:[UIColor whiteColor]];
    [_loginButton setTitleColor:kCommonMainTextColor_150 forState:UIControlStateNormal];
    [self.view addSubview:_loginButton];
    
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
    NSString * phoneNumber = @"";
    
    if (self.isBind) {
        if (self.account.text.length == 0 ) {
            [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            return;
        }
        phoneNumber = self.account.text;
        
    }else
    {
        NSLog(@"重置密码");
        if (self.nPhoeNumber.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"新手机号不能为空"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            return;
        }
        if (![[[NSString stringWithFormat:@"%@231618", self.verifyTF.text] MD5_Cap] isEqualToString:[[UserManager sharedManager] getVerifyCode]]) {
            [SVProgressHUD showErrorWithStatus:@"验证码不正确"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            return;
        }
        phoneNumber = self.nPhoeNumber.text;
    }
    
    [SVProgressHUD show];
    NSDictionary *dic = @{
                          @"iconStr":@"",
                          @"nickName":@"",
                          @"qqAccount":@"",
                          @"phoneNumber":phoneNumber
                          };
    [[UserManager sharedManager]completeUserInfoWithDic:dic withNotifiedObject:self];
}

- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resignTextFiled
{
    [_account resignFirstResponder];
    [_verifyTF resignFirstResponder];
    [_nPhoeNumber resignFirstResponder];
}
- (void)dealloc
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        
    }
}

- (void)didVerifyCodeSuccessed
{
    
}

- (void)didVerifyCodeFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didCompleteUserSuccessed:(NSString *)icon
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"绑定手机号码成功"];
    
    NSString * phoneNumber = self.isBind ? self.account.text : self.nPhoeNumber.text;
    
    NSDictionary * infoDic = @{@"icon":icon,
                               @"phoneNumber":phoneNumber,
                               @"nickName":@""
                               };
    [[UserManager sharedManager]refreshUserInfoWith:infoDic];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didCompleteUserFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

@end
