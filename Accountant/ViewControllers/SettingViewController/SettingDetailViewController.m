//
//  SettingDetailViewController.m
//  Accountant
//
//  Created by aaa on 2017/6/26.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "SettingDetailViewController.h"
#import "ResetPasswordViewController.h"
#import "ChangeEquipmentNameView.h"

@interface SettingDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate,UserModule_bindRegCodeProtocol>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)UILabel * cacheSize;
@property (nonatomic, strong)ChangeEquipmentNameView  * changeNameView;
@end

@implementation SettingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self navigationViewSetup];
    [self contentViewSetup];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, 64)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"设置";
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
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = kBackgroundGrayColor;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[UserManager sharedManager] getCodeview]) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cellID";
    static NSString * cellID1 = @"cellID1";
    UITableViewCell * cell = [UIUtility getCellWithCellName:cellID inTableView:tableView andCellClass:[UITableViewCell class]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0) {
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID1];
        if (cell1 == nil) {
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID1];
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell1.textLabel.text = @"缓存清理";
        self.cacheSize = cell1.detailTextLabel;
        self.cacheSize.text = [NSString stringWithFormat:@"缓存大小%0.2f",[self readCacheSize]] ;
        return cell1;
    }
    
    if (indexPath.row == 1) {
        cell.textLabel.text = @"邀请码";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    bottomView.backgroundColor = kBackgroundGrayColor;
    
    UIButton * quitBT = [UIButton buttonWithType:UIButtonTypeCustom];
    quitBT.frame = CGRectMake(15, 30, kScreenWidth - 30, 40);
    quitBT.backgroundColor = UIRGBColor(252, 55, 26);
    [quitBT setTitle:@"退出登录" forState:UIControlStateNormal];
    [quitBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    quitBT.layer.cornerRadius = 5;
    quitBT.layer.masksToBounds = YES;
    [bottomView addSubview:quitBT];
    
    [quitBT addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    
    return bottomView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            [self clearFile];
        }
            break;
        case 1:
        {
            [self inviteAction];
        }
            break;
        default:
            break;
    }
    
}

- (void)quit
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要退出该账号么" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    [alert show];
}

#pragma mark - alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self logout];
    }
}
- (void)logout
{
    [[UserManager sharedManager] logout];
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:nil object:nil];
    [[RCIMClient sharedRCIMClient] setRCConnectionStatusChangeDelegate:nil];
    [[RCIMClient sharedRCIMClient] logout];
    if (self.quitBlock) {
        self.quitBlock();
    }
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)inviteAction
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
        self.changeNameView.title = @"邀请码绑定";
        self.changeNameView.titleLabel.text = @"邀请码绑定";
        self.changeNameView.equipmentNameTF.placeholder = @"请输入邀请码";
        AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
        [delegate.window addSubview:self.changeNameView];
        self.changeNameView.alpha = 0;
        [UIView animateWithDuration:.3 animations:^{
            self.changeNameView.alpha = 1;
        }];
        __weak SettingDetailViewController * meVC = self;
        [self.changeNameView getEquipmentOption:^(NSString *name) {
            NSLog(@"name = %@", name);
            [meVC.changeNameView removeFromSuperview];
            
            [meVC inviteCode:name];
            
        }];
    }
}

- (void)inviteCode:(NSString *)regaCode;
{
    [SVProgressHUD show];
    [[UserManager sharedManager] bindRegCodeWithRegCode:regaCode withNotifiedObject:self];
}

#pragma mark - UserModule_bindRegCodeProtocol
- (void)didRequestbindRegCodeSuccessed
{
    [SVProgressHUD dismiss];
    [[UserManager sharedManager] changeCodeViewWith:0];
}

- (void)didRequestbindRegCodeFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

//1. 获取缓存文件的大小
-( float )readCacheSize
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    return [ self folderSizeAtPath :cachePath];
}


//由于缓存文件存在沙箱中，我们可以通过NSFileManager API来实现对缓存文件大小的计算。
// 遍历文件夹获得文件夹大小，返回多少 M
- ( float ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        //获取文件全路径
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0);
}

// 计算 单个文件的大小
- ( long long ) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil] fileSize];
    }
    return 0;
}

//2. 清除缓存
- (void)clearFile
{
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :cachePath];
    //NSLog ( @"cachpath = %@" , cachePath);
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        //获取文件全路径
        NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
        
        if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
            [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
        }
    }
    
    //读取缓存大小
    float cacheSize = [self readCacheSize] *1024;
    self.cacheSize.text = [NSString stringWithFormat:@"%.2fKB",cacheSize];
    
}

@end
