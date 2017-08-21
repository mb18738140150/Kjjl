//
//  ResetPasswordViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "UIMacro.h"
#import "UIUtility.h"
#import "InputTextTableViewCell.h"
#import "UserManager.h"
#import "SVProgressHUD.h"

@interface ResetPasswordViewController ()<UITableViewDelegate,UITableViewDataSource,UserModule_ResetPwdProtocol>

@property (nonatomic,strong) UITableView            *contentTableView;

@property (nonatomic,strong) UITextField            *oldPwdTextField;
@property (nonatomic,strong) UITextField            *pwdTextField;
@property (nonatomic,strong) UITextField            *pwdConfirmTextField;

@property (nonatomic,strong) UILabel                *oldPwdTextLabel;
@property (nonatomic,strong) UILabel                *pwdTextLabel;
@property (nonatomic,strong) UILabel                *pwdConfirmTextLabel;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationViewSetup];
    [self contentViewSetup];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.oldPwdTextField becomeFirstResponder];
    });
    
}

- (void)resetPassword
{
    if (![self.pwdTextField.text isEqualToString:self.pwdConfirmTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"两次密码不一样，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![self checkPassword:self.pwdTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码格式不正确，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [SVProgressHUD show];
    [[UserManager sharedManager] resetPasswordWithOldPassword:self.oldPwdTextField.text andNewPwd:self.pwdTextField.text withNotifiedObject:self];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"修改密码";
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
- (void)contentViewSetup
{
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight ) style:UITableViewStylePlain];
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.contentTableView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(resetPassword)];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - 
- (BOOL)checkPassword:(NSString*) password
{
    
    NSString *pattern =@"[a-zA-Z0-9]{6,20}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    
    BOOL isMatch = [pred evaluateWithObject:password];
    
    return isMatch;
    
}

#pragma mark - 
- (void)didResetPwdSuccessed
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)didResetPwdFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - table delegate & data sources
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
    static NSString *inputCellName = @"inputCell";
//    InputTextTableViewCell *cell = (InputTextTableViewCell *)[UIUtility getCellWithCellName:inputCellName inTableView:tableView andCellClass:[InputTextTableViewCell class]];
//    [cell resetWithInfo:nil];
    UITableViewCell *cell = [UIUtility getCellWithCellName:inputCellName inTableView:tableView andCellClass:[UITableViewCell class]];
    
    CGRect labelRect = CGRectMake(10, 10, 100, 30);
    UIFont *labelFont = [UIFont systemFontOfSize:17];
    
    CGRect textFieldRect = CGRectMake(120, 10, 200, 30);
    
    for (UIView *view in cell.subviews) {
        if (view.tag > 100 && view.tag < 10) {
            [view removeFromSuperview];
        }
    }
    
    if (indexPath.row == 0) {
        self.oldPwdTextLabel = [[UILabel alloc] initWithFrame:labelRect];
        self.oldPwdTextLabel.text = @"旧密码";
        self.oldPwdTextLabel.textAlignment = NSTextAlignmentCenter;
        self.oldPwdTextLabel.font = labelFont;
        self.oldPwdTextLabel.tag = 101;
        [cell addSubview:self.oldPwdTextLabel];
        
        self.oldPwdTextField = [[UITextField alloc] initWithFrame:textFieldRect];
        self.oldPwdTextField.placeholder = @"请填写";
        self.oldPwdTextField.tag = 102;
        self.oldPwdTextField.secureTextEntry = YES;
        [cell addSubview:self.oldPwdTextField];
    }
    if (indexPath.row == 1) {
        self.pwdTextLabel = [[UILabel alloc] initWithFrame:labelRect];
        self.pwdTextLabel.text = @"新密码";
        self.pwdTextLabel.textAlignment = NSTextAlignmentCenter;
        self.pwdTextLabel.font = labelFont;
        self.pwdTextLabel.tag = 103;
        [cell addSubview:self.pwdTextLabel];
        
        self.pwdTextField = [[UITextField alloc] initWithFrame:textFieldRect];
        self.pwdTextField.placeholder = @"6-20位字母数字";
        self.pwdTextField.tag = 104;
        self.pwdTextField.secureTextEntry = YES;
        [cell addSubview:self.pwdTextField];
    }
    if (indexPath.row == 2) {
        self.pwdConfirmTextLabel = [[UILabel alloc] initWithFrame:labelRect];
        self.pwdConfirmTextLabel.text = @"确认密码";
        self.pwdConfirmTextLabel.textAlignment = NSTextAlignmentCenter;
        self.pwdConfirmTextLabel.font = labelFont;
        self.pwdConfirmTextLabel.tag = 105;
        [cell addSubview:self.pwdConfirmTextLabel];
        
        self.pwdConfirmTextField = [[UITextField alloc] initWithFrame:textFieldRect];
        self.pwdConfirmTextField.placeholder = @"请再次填写密码";
        self.pwdConfirmTextField.tag = 106;
        self.pwdConfirmTextField.secureTextEntry = YES;
        [cell addSubview:self.pwdConfirmTextField];
    }
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(20, 49, kScreenWidth, 1)];
    bottomLineView.tag = 110;
    bottomLineView.backgroundColor = kTableViewCellSeparatorColor;
    [cell addSubview:bottomLineView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
