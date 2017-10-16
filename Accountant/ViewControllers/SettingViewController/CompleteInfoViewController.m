//
//  CompleteInfoViewController.m
//  Accountant
//
//  Created by aaa on 2017/9/13.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CompleteInfoViewController.h"
#define kImageWidth 20
@interface CompleteInfoViewController ()<UserModule_CompleteUserInfoProtocol,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HttpUploadProtocol>

@property (nonatomic,strong) UIImageView                *logoImageView;
@property (nonatomic,strong) UITextField                *nikeNameTF;
@property (nonatomic,strong) UITextField                *qqTF;
@property (nonatomic,strong) UIButton                   *completeButton;

@property (nonatomic,strong) UIButton                   *touristBtn;

@property (nonatomic, strong)UIImagePickerController * imagePic;
@property (nonatomic, copy)NSString * iconImageUrl;// 头像地址连接

@property (nonatomic, strong)NSString * iconMsg;

@end

@implementation CompleteInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完善信息";
    [self prepareUI];
}

- (void)prepareUI
{
    UIControl *resignControl = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [resignControl addTarget:self action:@selector(resignTextFiled) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resignControl];
    
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 30, 100, 60, 60)];
    self.logoImageView.image = [UIImage imageNamed:@"completeDefaultImage"];
    self.logoImageView.userInteractionEnabled = YES;
    self.logoImageView.layer.cornerRadius = self.logoImageView.hd_width / 2;
    self.logoImageView.layer.masksToBounds = YES;
    [self.view addSubview:self.logoImageView];
    UITapGestureRecognizer * iconTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeIconAction)];
    [self.logoImageView addGestureRecognizer:iconTap];
    
    self.imagePic = [[UIImagePickerController alloc] init];
    _imagePic.allowsEditing = YES;
    _imagePic.delegate = self;
    
    UILabel * iconTipLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.logoImageView.frame) + 5, kScreenWidth, 15)];
    iconTipLB.text = @"点击设置头像";
    iconTipLB.textAlignment = 1;
    iconTipLB.font = kMainFont;
    iconTipLB.textColor = kCommonMainTextColor_200;
    [self.view addSubview:iconTipLB];
    
    // 昵称
    UIView * accountView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(iconTipLB.frame) + 40, kScreenWidth - 40, 40)];
    accountView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:accountView];
    
    UIImageView * accountImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, kImageWidth, kImageWidth)];
    accountImageView.image = [UIImage imageNamed:@"complete_nikeName"];
    [accountView addSubview:accountImageView];
    
    _nikeNameTF=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accountImageView.frame) + 10, 10, accountView.hd_width - 70, 20)];
    [_nikeNameTF setBackgroundColor:[UIColor clearColor]];
    _nikeNameTF.placeholder=[NSString stringWithFormat:@"请输入昵称"];
    _nikeNameTF.delegate = self;
    _nikeNameTF.font = kMainFont;
    _nikeNameTF.textColor = kCommonMainTextColor_50;
    [accountView addSubview:_nikeNameTF];
    
    UIView * accountBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, accountView.hd_height - 1, accountView.hd_width, 1)];
    accountBottomView.backgroundColor = kCommonMainTextColor_200;
    [accountView addSubview:accountBottomView];
    
    
    // qq
    UIView * passwordView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(accountView.frame) + 20, kScreenWidth - 40, 40)];
    passwordView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:passwordView];
    
    UIImageView * passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, kImageWidth, kImageWidth)];
    passwordImageView.image = [UIImage imageNamed:@"complete_QQ"];
    [passwordView addSubview:passwordImageView];
    
    _qqTF=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passwordImageView.frame) + 10, 10, kScreenWidth-40, 20)];
    [_qqTF setBackgroundColor:[UIColor clearColor]];
    _qqTF.secureTextEntry = YES;
    _qqTF.placeholder=[NSString stringWithFormat:@"请输入您的QQ号(选填)"];
    _qqTF.layer.cornerRadius=5.0;
    _qqTF.delegate = self;
    _qqTF.font = kMainFont;
    _qqTF.textColor = kCommonMainTextColor_50;
    [passwordView addSubview:_qqTF];
    
    UIView * passwordBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, passwordView.hd_height - 1, passwordView.hd_width, 1)];
    passwordBottomView.backgroundColor = kCommonMainTextColor_200;
    [passwordView addSubview:passwordBottomView];
    
    
    _completeButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_completeButton setFrame:CGRectMake(20, CGRectGetMaxY(passwordView.frame) + 70, kScreenWidth - 40, 40)];
    _completeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _completeButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [_completeButton setTitle:@"确认" forState:UIControlStateNormal];
    _completeButton.layer.cornerRadius = _completeButton.hd_height / 2;
    _completeButton.layer.masksToBounds = YES;
    _completeButton.layer.borderColor = kCommonMainTextColor_150.CGColor;
    _completeButton.layer.borderWidth = 0.5;
    [_completeButton addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    [_completeButton setBackgroundColor:[UIColor whiteColor]];
    [_completeButton setTitleColor:kCommonMainTextColor_150 forState:UIControlStateNormal];
    [self.view addSubview:_completeButton];
    
    _touristBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _touristBtn.frame = CGRectMake(_completeButton.hd_x, CGRectGetMaxY(_completeButton.frame) + 10, _completeButton.hd_width, 20);
    _touristBtn.titleLabel.font = kMainFont;
    _touristBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_touristBtn setTitle:@"暂不填写，随便看看>>>" forState:UIControlStateNormal];
    [_touristBtn setTitleColor:kCommonMainColor forState:UIControlStateNormal];
    [self.view addSubview:_touristBtn];
    [_touristBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)completeAction
{
    [SVProgressHUD show];
    [self upLoadImage:self.logoImageView.image];
}

- (void)popAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeIconAction
{
    [self resignTextFiled];
    
    UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePic.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePic animated:YES completion:nil];
        }else
        {
            UIAlertController * tipControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有相机,请选择图库" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ;
            }];
            [tipControl addAction:sureAction];
            [self presentViewController:tipControl animated:YES completion:nil];
            
        }
    }];
    UIAlertAction * libraryAction = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePic animated:YES completion:nil];
    }];
    
    [alertcontroller addAction:cancleAction];
    [alertcontroller addAction:cameraAction];
    [alertcontroller addAction:libraryAction];
    
    [self presentViewController:alertcontroller animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.logoImageView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)upLoadImage:(UIImage *)image
{
    [[HttpUploaderManager sharedManager]uploadImage:UIImagePNGRepresentation(image) withProcessDelegate:self];
}


- (void)resignTextFiled
{
    [_nikeNameTF resignFirstResponder];
    [_qqTF resignFirstResponder];
}

- (void)didCompleteUserSuccessed
{
    [SVProgressHUD dismiss];
    
    NSDictionary * infoDic = @{@"icon":self.iconMsg,
                               @"phoneNumber":@"",
                               @"nickName":self.nikeNameTF.text
                               };
    [[UserManager sharedManager]refreshUserInfoWith:infoDic];
    
    [SVProgressHUD showSuccessWithStatus:@"完善信息完成"];
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

#pragma mark - uploadImageProtocol
- (void)didUploadSuccess:(NSDictionary *)successInfo
{
    NSString * imageStr = [successInfo objectForKey:@"msg"];
    NSArray * imageStrArr = [imageStr componentsSeparatedByString:@","];
    
    self.iconMsg = [imageStrArr objectAtIndex:0];
    
    NSString * nickStr = self.nikeNameTF.text.length > 0 ? self.nikeNameTF.text : @"";
    NSString * qqAccount = self.qqTF.text.length > 0 ? self.qqTF.text : @"";
    
    NSDictionary *dic = @{
                          @"iconStr":[imageStrArr objectAtIndex:1],
                          @"nickName":nickStr,
                          @"qqAccount":qqAccount,
                          @"phoneNumber":@""
                          };
    [[UserManager sharedManager]completeUserInfoWithDic:dic withNotifiedObject:self];
}

- (void)didUploadFailed:(NSString *)uploadFailed
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:uploadFailed];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

@end
