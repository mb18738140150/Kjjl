//
//  LoginViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "LoginViewController.h"
#import "UIMacro.h"
#import "LoginBackgroundView.h"
#import "UserManager.h"
#import "SVProgressHUD.h"

@interface LoginViewController ()<UITextFieldDelegate,UserModule_LoginProtocol,UserModule_BindJPushProtocol>

@property (nonatomic,strong) UITextField                *account;
@property (nonatomic,strong) UITextField                *password;
@property (nonatomic,strong) UIButton                   *loginButton;
@property (nonatomic,strong) UIImageView                *closeImageView;
@property (nonatomic,strong) UILabel                    *titleLabel;
@property (nonatomic,strong) UIImageView                *logoImageView;
@property (nonatomic,strong) LoginBackgroundView        *background;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self viewInit];
    
}

- (void)viewInit
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIControl *resignControl = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [resignControl addTarget:self action:@selector(resignTextFiled) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resignControl];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTopGradientLayer];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight / 2 - 120 - 90, kScreenWidth, 30)];
    self.titleLabel.text = @"WELCOME";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:25];
    self.titleLabel.textColor = [UIColor whiteColor];
//    [self.view addSubview:self.titleLabel];
    
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 40, 60, 80, 80)];
    self.logoImageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:self.logoImageView];
    
    _background=[[LoginBackgroundView alloc] initWithFrame:CGRectMake(20, kScreenHeight/2 - 120, kScreenWidth-40, 300)];
    [_background setBackgroundColor:[UIColor whiteColor]];
    [[_background layer] setCornerRadius:10];
    
    _background.layer.shadowColor = kCommonMainTextColor_200.CGColor;
    _background.layer.shadowOffset = CGSizeMake(5, 5);
    _background.layer.shadowOpacity = 0.5;
    _background.layer.shadowRadius = 10;
    
    _background.clipsToBounds = NO;
    _background.userInteractionEnabled = YES;
    [self.view addSubview:_background];
    
    UIView * accountView = [[UIView alloc]initWithFrame:CGRectMake(20, 40, kScreenWidth - 80, 40)];
    accountView.layer.cornerRadius = accountView.hd_height / 2;
    accountView.layer.masksToBounds = YES;
    accountView.backgroundColor = kBackgroundGrayColor;
    [_background addSubview:accountView];
    
    UIImageView * accountImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 30, 30)];
    accountImageView.image = [UIImage imageNamed:@"手机(1)"];
    [accountView addSubview:accountImageView];
    
    _account=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accountImageView.frame) + 10, 10, accountView.hd_width - 70, 20)];
    [_account setBackgroundColor:[UIColor clearColor]];
    _account.placeholder=[NSString stringWithFormat:@"输入手机号"];
    _account.delegate = self;
    _account.font = kMainFont;
    _account.textColor = kCommonMainTextColor_50;
    [accountView addSubview:_account];
    
    UIView * passwordView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(accountView.frame) + 20, kScreenWidth - 80, 40)];
    passwordView.layer.cornerRadius = passwordView.hd_height / 2;
    passwordView.layer.masksToBounds = YES;
    passwordView.backgroundColor = kBackgroundGrayColor;
    [_background addSubview:passwordView];
    
    UIImageView * passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 30, 30)];
    passwordImageView.image = [UIImage imageNamed:@"密码"];
    [passwordView addSubview:passwordImageView];
    
    _password=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passwordImageView.frame) + 10, 10, kScreenWidth-40, 20)];
    [_password setBackgroundColor:[UIColor clearColor]];
    _password.secureTextEntry = YES;
    _password.placeholder=[NSString stringWithFormat:@"密码"];
    _password.layer.cornerRadius=5.0;
    _password.delegate = self;
    _password.font = kMainFont;
    _password.textColor = kCommonMainTextColor_50;
    [passwordView addSubview:_password];
    
    self.closeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 50, 30, 30)];
    self.closeImageView.image = [UIImage imageNamed:@"close.png"];
    self.closeImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    
    [self.closeImageView addGestureRecognizer:tap];
    [self.view addSubview:self.closeImageView];
    
    _loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_loginButton setFrame:CGRectMake(20, CGRectGetMaxY(passwordView.frame) + 60, kScreenWidth - 80, 40)];
    CAGradientLayer *paylayer = [[CAGradientLayer alloc]init];
    paylayer.frame = self.loginButton.bounds;
    paylayer.colors = [NSArray arrayWithObjects:(id)[UIRGBColor(28, 144, 247) CGColor],(id)[UIRGBColor(9, 68, 255) CGColor], nil];
    paylayer.startPoint = CGPointMake(0, 0.5);
    paylayer.endPoint = CGPointMake(1, 0.5);
    [self.loginButton.layer addSublayer:paylayer];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [_loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
    _loginButton.layer.cornerRadius = _loginButton.hd_height / 2;
    _loginButton.layer.masksToBounds = YES;
    [_loginButton addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setBackgroundColor:[UIColor colorWithRed:51/255.0 green:102/255.0 blue:255/255.0 alpha:1]];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_background addSubview:_loginButton];
    
    UIImageView * bottomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 70, kScreenWidth, 70)];
    bottomImageView.image = [UIImage imageNamed:@"login-bgbgbg"];
    [self.view addSubview:bottomImageView];
}

- (void)resignTextFiled
{
    [_account resignFirstResponder];
    [_password resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignTextFiled];
    return YES;
}

- (void)dismissSelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doLogin
{
    NSString *userName = _account.text;
    NSString *password = _password.text;
    [[UserManager sharedManager] loginWithUserName:userName andPassword:password withNotifiedObject:self];
    [SVProgressHUD show];
}

#pragma mark - login protocol func
- (void)didUserLoginSuccessed
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self dismissSelf];
        
        [self connectRongyun];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"]) {
            NSString *registrationID = [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"];
            [[UserManager sharedManager] didRequestBindJPushWithCID:registrationID withNotifiedObject:self];
        }else
        {
            [[UserManager sharedManager] didRequestBindJPushWithCID:@"" withNotifiedObject:self];
        }
        
    });
    
}

- (void)didUserLoginFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


- (void)connectRongyun
{
    [[RCIM sharedRCIM] connectWithToken:[[UserManager sharedManager] getRongToken] success:^(NSString *userId) {
        NSLog(@"连接融云成功");
        
        RCUserInfo *user = [RCUserInfo new];
        
            user.userId = [NSString stringWithFormat:@"%d", [UserManager sharedManager].getUserId];
            user.name = [[UserManager sharedManager] getUserName];
            user.portraitUri = [[UserManager sharedManager] getIconUrl];
        
            [[RCIM sharedRCIM]refreshUserInfoCache:user withUserId:user.userId];
            [RCIM sharedRCIM].currentUserInfo.userId = user.userId;
            [RCIM sharedRCIM].currentUserInfo.name = user.name;
            [RCIM sharedRCIM].currentUserInfo.portraitUri = user.portraitUri;
        
    } error:^(RCConnectErrorCode status) {
        NSLog(@"连接失败");
        NSString *userName = _account.text;
        NSString *password = _password.text;
        [[UserManager sharedManager] loginWithUserName:userName andPassword:password withNotifiedObject:self];
    } tokenIncorrect:^{
        NSLog(@"token过期");
        NSString *userName = _account.text;
        NSString *password = _password.text;
        [[UserManager sharedManager] loginWithUserName:userName andPassword:password withNotifiedObject:self];
        
    }];
}

- (void)didRequestBindJPushSuccessed
{
    
}

- (void)didRequestBindJPushFailed:(NSString *)failedInfo
{
    
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)setTopGradientLayer
{
    CGPoint startP = CGPointMake(kScreenWidth / 2, 0);
    CGPoint endP = CGPointMake(kScreenWidth / 2, self.view.frame.size.height);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startP];
    [path addLineToPoint:endP];
    
    CAShapeLayer * layer = [[CAShapeLayer alloc]init];
    layer.frame = self.view.bounds;
    layer.lineWidth = kScreenWidth;
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:layer];
    
    // 渐变进度条
    CALayer *gradientLayer = [CALayer layer];
    gradientLayer.frame = self.view.bounds;
    
    CAGradientLayer * gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = self.view.bounds;
    [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[UIRGBColor(28, 144, 247) CGColor],(id)[UIRGBColor(9, 68, 255) CGColor], nil]];
    [gradientLayer1 setLocations:@[@0, @0.5, @1]];
    [gradientLayer1 setStartPoint:CGPointMake(0.5, 0)];
    [gradientLayer1 setEndPoint:CGPointMake(0.5, 1)];
    [gradientLayer addSublayer:gradientLayer1];
    
    CAShapeLayer * processLayer = [[CAShapeLayer alloc] init];
    processLayer.frame = self.view.bounds;
    processLayer.fillColor = [UIColor clearColor].CGColor;
    processLayer.strokeColor = [UIColor whiteColor].CGColor;
    processLayer.lineWidth = kScreenWidth;
    processLayer.path = path.CGPath;
    processLayer.strokeEnd = 0.5;
    
    [gradientLayer setMask:processLayer];
    
    [self.view.layer addSublayer:gradientLayer];
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
