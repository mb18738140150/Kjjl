//
//  UserCenterViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "UserCenterViewController.h"
#import "UIMacro.h"
#import "CommonMacro.h"
#import "UIImage+Blur.h"
#import "UIImage+Scale.h"
#import "SettingMacro.h"
#import "UIUtility.h"
#import "UserManager.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+AFNetworking.h"
#import "ChangeEquipmentNameView.h"
#import "AppDelegate.h"
#import "ChangeBindViewController.h"
#import "ResetPasswordViewController.h"
#import "DredgeMemberViewController.h"

#define headerImageName @"stuhead"

@interface UserCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UserModule_CompleteUserInfoProtocol,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HttpUploadProtocol>

@property (nonatomic,strong) UIImageView            *bgImageView;
@property (nonatomic,strong) UIImageView            *headerImageView;

@property (nonatomic,strong) UIButton               *backButton;

@property (nonatomic,strong) UITableView            *infoTableView;

@property (nonatomic,strong) NSDictionary           *userInfos;
@property (nonatomic,strong) NSArray                *userDisplayKeyArray;
@property (nonatomic,strong) NSArray                *userDisplayNameArray;
// 修改昵称
@property (nonatomic, strong)ChangeEquipmentNameView  * changeNameView;
@property (nonatomic, strong)NSMutableDictionary      * nickNameDic;

@property (nonatomic, strong)UIImagePickerController * imagePic;
@property (nonatomic, strong)UIImage                 * nImage;
@property (nonatomic, strong)NSString                * iconMsg;

@end

@implementation UserCenterViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userInfos = [[UserManager sharedManager] getUserInfos];
    self.userDisplayNameArray = @[@"头像",@"昵称",@"用户名",@"用户ID",@"用户级别",@"电话号码",@"修改密码"];
    self.userDisplayKeyArray = @[kUserHeaderImageUrl,kUserNickName,kUserName,kUserId,kUserLevel,kUserTelephone];
    self.iconMsg = @"";
    [self navigationViewSetup];
    [self contentSetup];
}

#pragma mark - response func
- (void)navigationBack11
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer
                                      *)gestureRecognizer{
    return NO; //YES：允许右滑返回  NO：禁止右滑返回
}
#pragma mark - table delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userDisplayNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *userInfoCellName = @"userInfoNameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:userInfoCellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.font = kMainFont;
    cell.detailTextLabel.font = kMainFont;
    
    cell.textLabel.text = [self.userDisplayNameArray objectAtIndex:indexPath.row];
    if (indexPath.row == 4) {
        cell.backgroundColor = UIColorFromRGBValue(0xedf0f0);
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 17, kScreenWidth, 40)];
        backView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:backView];
        
        UILabel * titlabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 13, 150, 15)];
        titlabel.font = kMainFont;
        [backView addSubview:titlabel];
        
        UIButton * upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        upBtn.frame = CGRectMake(kScreenWidth - 70, 9, 60, 22);
        [upBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [upBtn setTitle:@"升级会员" forState:UIControlStateNormal];
        upBtn.titleLabel.font = kMainFont;
        upBtn.backgroundColor = UIColorFromRGBValue(0xffa116);
        upBtn.layer.cornerRadius = 4;
        upBtn.layer.masksToBounds = YES;
        [upBtn addTarget:self action:@selector(upgradeMemberLevel) forControlEvents:UIControlEventTouchUpInside];
        if ([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled]) {
            [backView addSubview:upBtn];
        }
        
        int level = [[self.userInfos objectForKey:[self.userDisplayKeyArray objectAtIndex:indexPath.row]] intValue];
        
        if (level == 1) {
            titlabel.text = @"普通用户";
        }else if (level == 2){
            titlabel.text = @"试用会员";
        }else{
            if ([self isHaveMemberLevel]) {
                titlabel.text = [self.userInfos objectForKey:@"levelDetail"];
                
                if ([titlabel.text isEqualToString:@"K5"] ) {
                    upBtn.hidden = YES;
                }else
                {
                    if ([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled]) {
                        upBtn.hidden = NO;
                    }else
                    {
                        upBtn.hidden = YES;
                    }
                }
            }else
            {
                titlabel.text = @"正式会员";
            }
        }
        
    }else if(indexPath.row == 5){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSString *tele = [self.userInfos objectForKey:[self.userDisplayKeyArray objectAtIndex:indexPath.row]];
        if (tele == nil || [tele isEqualToString:@""]) {
            cell.detailTextLabel.text = @"未绑定";
        }else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.userInfos objectForKey:[self.userDisplayKeyArray objectAtIndex:indexPath.row]]];
        }
        UITapGestureRecognizer * changePhoneNumberTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePhoneNumberAction:)];
        cell.detailTextLabel.userInteractionEnabled = YES;
        
        [cell addGestureRecognizer:changePhoneNumberTap];
        
    }else if (indexPath.row == 1){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.userInfos objectForKey:[self.userDisplayKeyArray objectAtIndex:indexPath.row]]];
        cell.detailTextLabel.userInteractionEnabled = YES;
        [self.nickNameDic setObject:cell.detailTextLabel.text forKey:@"old"];
        [self.nickNameDic setObject:cell.detailTextLabel.text forKey:@"new"];
        
        if (cell.detailTextLabel.gestureRecognizers.count == 0) {
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeNickname)];
            [cell.detailTextLabel addGestureRecognizer:tap];
        }
    }else if (indexPath.row == 6)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 0)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 40 - 26, 7, 26, 26)];
        self.headerImageView.layer.cornerRadius = self.headerImageView.hd_height / 2;
        self.headerImageView.layer.masksToBounds = YES;
        [cell addSubview:self.headerImageView];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[self.userInfos objectForKey:[self.userDisplayKeyArray objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:@""]];
        self.headerImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * changeIconTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeIcon)];
        [self.headerImageView addGestureRecognizer:changeIconTap];
    }
    
    else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.userInfos objectForKey:[self.userDisplayKeyArray objectAtIndex:indexPath.row]]];
    }
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, kScreenWidth, 1)];
    if (indexPath.row == 4) {
        bottomView.hd_y = 73;
    }
    bottomView.backgroundColor = UIColorFromRGBValue(0xedf0f0);
    [cell addSubview:bottomView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        return 74;
    }else
    {
        return 40;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 6) {
        ResetPasswordViewController *vc = [[ResetPasswordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == 5)
    {
        ChangeBindViewController * changeVC = [[ChangeBindViewController alloc]init];
        [self.navigationController pushViewController:changeVC animated:YES];
    }else if(indexPath.row == 0)
    {
        [self changeIcon];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 17)];
    view.backgroundColor = UIColorFromRGB(0xedf0f0);
    return view;
}

#pragma mark - changeNickName
- (void)changeNickname
{
    if (self.changeNameView) {
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
        [delegate.window addSubview:self.changeNameView];
        self.changeNameView.alpha = 0;
        [UIView animateWithDuration:.3 animations:^{
            self.changeNameView.alpha = 1;
        }];
    }else
    {
        NSArray * nibarr = [[NSBundle mainBundle]loadNibNamed:@"ChangeEquipmentNameView" owner:self options:nil];
        self.changeNameView = [nibarr objectAtIndex:0];
        CGRect tmpFrame = [[UIScreen mainScreen] bounds];
        self.changeNameView.frame = tmpFrame;
        self.changeNameView.equipmentNameTF.delegate = self.changeNameView;
        self.changeNameView.title = @"昵称";
        self.changeNameView.titleLabel.text = @"修改昵称";
        self.changeNameView.equipmentNameTF.placeholder = @"请输入昵称";
        self.changeNameView.equipmentNameTF.text = [self.nickNameDic objectForKey:@"new"];
        AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
        [delegate.window addSubview:self.changeNameView];
        self.changeNameView.alpha = 0;
        [UIView animateWithDuration:.3 animations:^{
            self.changeNameView.alpha = 1;
        }];
        __weak UserCenterViewController * meVC = self;
        [self.changeNameView getEquipmentOption:^(NSString *name) {
            NSLog(@"name = %@", name);
            [meVC.changeNameView removeFromSuperview];
            
            [meVC changeNickName:name];
            
            [meVC.nickNameDic setObject:name forKey:@"new"];
        }];
    }
}

- (void)changeNickName:(NSString *)nNickName;
{
    [SVProgressHUD show];
    NSDictionary *dic = @{
                          @"iconStr":@"",
                          @"nickName":nNickName,
                          @"qqAccount":@"",
                          @"phoneNumber":@""
                          };
    [[UserManager sharedManager]completeUserInfoWithDic:dic withNotifiedObject:self];
}

#pragma mark - 绑定新手机号
- (void)changePhoneNumberAction:(UITapGestureRecognizer *)tapGesture
{
    UILabel * label = (UILabel *)tapGesture.view;
    
    ChangeBindViewController * changePhoneNBVC = [[ChangeBindViewController alloc]init];
    if ([label.text isEqualToString:@"未绑定"]) {
        changePhoneNBVC.isBind = YES;
    }else
    {
        changePhoneNBVC.isBind = NO;
        changePhoneNBVC.verifyPhoneNumber = [self.userInfos objectForKey:kUserTelephone];
    }
    [self.navigationController pushViewController:changePhoneNBVC animated:YES];
}

#pragma mark - completeuserInfo
- (void)didCompleteUserSuccessed
{
    [SVProgressHUD dismiss];
    [self.nickNameDic setObject:[self.nickNameDic objectForKey:@"new"] forKey:@"old"];
    NSDictionary * infoDic = @{@"icon":self.iconMsg,
                               @"phoneNumber":@"",
                               @"nickName":[self.nickNameDic objectForKey:@"new"]
                               };
    [[UserManager sharedManager]refreshUserInfoWith:infoDic];
    self.userInfos = [[UserManager sharedManager]getUserInfos];
    [self.infoTableView reloadData];
    if (self.iconMsg && self.iconMsg.length > 0) {
        [self refreshHeadImage];
        self.iconMsg = @"";
    }
    
}

- (void)didCompleteUserFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    self.iconMsg = @"";
    [self.nickNameDic setObject:[self.nickNameDic objectForKey:@"old"] forKey:@"new"];
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)refreshHeadImage
{
    self.headerImageView.image = self.nImage;
    self.bgImageView.image = self.headerImageView.image;
}

#pragma mark - ui setup
- (void)navigationViewSetup
{
    self.navigationItem.title = @"个人资料";
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

- (void)contentSetup
{
//    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth+20, kScreenWidth/5*3)];
//    self.bgImageView.backgroundColor = [UIColor grayColor];
//
//    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bgImageView.frame.size.width/2 - kWidthOfWidthImage/2, self.bgImageView.frame.size.height/2 - kWidthOfWidthImage/2 + 10, kWidthOfWidthImage, kWidthOfWidthImage)];
////    self.headerImageView.image = [UIImage imageNamed:headerImageName];
//    [self.headerImageView setImageWithURL:[NSURL URLWithString:[self.userInfos objectForKey:kUserHeaderImageUrl]]];
//    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width/2;
//    self.headerImageView.layer.masksToBounds = YES;
//    self.headerImageView.userInteractionEnabled = YES;
    
    self.imagePic = [[UIImagePickerController alloc] init];
    _imagePic.allowsEditing = YES;
    _imagePic.delegate = self;
    
//    UITapGestureRecognizer * changeIconTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeIcon)];
//    [self.headerImageView addGestureRecognizer:changeIconTap];
    
    
//    UIImage *oriImage = self.headerImageView.image;
///*    UIImage *bgImage = [oriImage imageByScalingAndCroppingForSize:CGSizeMake(kScreenWidth+20, kScreenWidth+20)];
//    self.bgImageView.image = [bgImage coreBlurWithBlurNumber:10];*/
////    [self.bgImageView setImageWithURL:[NSURL URLWithString:[self.userInfos objectForKey:kUserHeaderImageUrl]]];
//    self.bgImageView.image = oriImage;
////    self.bgImageView.contentMode = UIViewContentModeCenter;
//    self.bgImageView.clipsToBounds = YES;
//    self.bgImageView.userInteractionEnabled = YES;
//    
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.frame = CGRectMake(0, 0, self.bgImageView.frame.size.width, self.bgImageView.frame.size.height);
//    [self.bgImageView addSubview:effectView];
//    
//    self.backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    self.backButton.frame = CGRectMake(10, 30, 60, 40);
//    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
//    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.backButton addTarget:self action:@selector(navigationBack11) forControlEvents:UIControlEventTouchUpInside];
//    self.backButton.userInteractionEnabled = YES;
//    
//    [self.bgImageView addSubview:self.headerImageView];
//    [self.bgImageView addSubview:self.backButton];
//    [self.view addSubview:self.bgImageView];
    
    self.infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight) style:UITableViewStyleGrouped];
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    [self.view addSubview:self.infoTableView];
    self.infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.nickNameDic = [NSMutableDictionary dictionary];
}

- (void)changeIcon
{
    
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
    self.nImage = image;
    [SVProgressHUD show];
    
    [self upLoadImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)upLoadImage:(UIImage *)image
{
   
    [[HttpUploaderManager sharedManager]uploadImage:UIImagePNGRepresentation(image) withProcessDelegate:self];
}

- (BOOL)isHaveMemberLevel
{
    NSString * levelDetail = [self.userInfos objectForKey:@"levelDetail"];
    if ([levelDetail isEqualToString:@"K1"] || [levelDetail isEqualToString:@"K2"] || [levelDetail isEqualToString:@"K3"] || [levelDetail isEqualToString:@"K4"] || [levelDetail isEqualToString:@"K5"]) {
        return YES;
    }else
    {
        return NO;
    }
    
}

#pragma mark - uploadImageProtocol
- (void)didUploadSuccess:(NSDictionary *)successInfo
{
    [SVProgressHUD dismiss];
    NSLog(@"%@", successInfo);
    
    NSString * imageStr = [successInfo objectForKey:@"msg"];
    NSArray * imageStrArr = [imageStr componentsSeparatedByString:@","];
    
    self.iconMsg = [imageStrArr objectAtIndex:0];
    NSDictionary *dic = @{
                          @"iconStr":[imageStrArr objectAtIndex:1],
                          @"nickName":@"",
                          @"qqAccount":@"",
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

- (void)upgradeMemberLevel
{
    DredgeMemberViewController * vc = [[DredgeMemberViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
