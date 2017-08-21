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

#define headerImageName @"stuhead"

@interface UserCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIImageView            *bgImageView;
@property (nonatomic,strong) UIImageView            *headerImageView;

@property (nonatomic,strong) UIButton               *backButton;

@property (nonatomic,strong) UITableView            *infoTableView;

@property (nonatomic,strong) NSDictionary           *userInfos;
@property (nonatomic,strong) NSArray                *userDisplayKeyArray;
@property (nonatomic,strong) NSArray                *userDisplayNameArray;

@end

@implementation UserCenterViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userInfos = [[UserManager sharedManager] getUserInfos];
    self.userDisplayNameArray = @[@"用户名",@"用户id",@"昵称",@"用户级别",@"电话号码"];
    self.userDisplayKeyArray = @[kUserName,kUserId,kUserNickName,kUserLevel,kUserTelephone];
    
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
    cell.textLabel.text = [self.userDisplayNameArray objectAtIndex:indexPath.row];
    if (indexPath.row == 3) {
        int level = [[self.userInfos objectForKey:[self.userDisplayKeyArray objectAtIndex:indexPath.row]] intValue];
        if (level == 1) {
            cell.detailTextLabel.text = @"普通用户";
        }else if (level == 2){
            cell.detailTextLabel.text = @"试用会员";
        }else{
            cell.detailTextLabel.text = @"正式会员";
        }
        
    }else if(indexPath.row == 4){
        NSString *tele = [self.userInfos objectForKey:[self.userDisplayKeyArray objectAtIndex:indexPath.row]];
        if (tele == nil || [tele isEqualToString:@""]) {
            cell.detailTextLabel.text = @"未绑定";
        }else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.userInfos objectForKey:[self.userDisplayKeyArray objectAtIndex:indexPath.row]]];
        }
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.userInfos objectForKey:[self.userDisplayKeyArray objectAtIndex:indexPath.row]]];
    }
    return cell;
}


#pragma mark - ui setup
- (void)navigationViewSetup
{
    
    self.navigationItem.title = @"个人中心";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth+20, kScreenWidth/5*3)];
    self.bgImageView.backgroundColor = [UIColor grayColor];

    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bgImageView.frame.size.width/2 - kWidthOfWidthImage/2, self.bgImageView.frame.size.height/2 - kWidthOfWidthImage/2 + 10, kWidthOfWidthImage, kWidthOfWidthImage)];
    self.headerImageView.backgroundColor = [UIColor greenColor];
//    self.headerImageView.image = [UIImage imageNamed:headerImageName];
    [self.headerImageView setImageWithURL:[NSURL URLWithString:[self.userInfos objectForKey:kUserHeaderImageUrl]]];
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width/2;
    self.headerImageView.layer.masksToBounds = YES;
    
    UIImage *oriImage = [UIImage imageNamed:headerImageName];
/*    UIImage *bgImage = [oriImage imageByScalingAndCroppingForSize:CGSizeMake(kScreenWidth+20, kScreenWidth+20)];
    self.bgImageView.image = [bgImage coreBlurWithBlurNumber:10];*/
//    [self.bgImageView setImageWithURL:[NSURL URLWithString:[self.userInfos objectForKey:kUserHeaderImageUrl]]];
    self.bgImageView.image = oriImage;
//    self.bgImageView.contentMode = UIViewContentModeCenter;
    self.bgImageView.clipsToBounds = YES;
    self.bgImageView.userInteractionEnabled = YES;
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, self.bgImageView.frame.size.width, self.bgImageView.frame.size.height);
    [self.bgImageView addSubview:effectView];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.backButton.frame = CGRectMake(10, 30, 60, 40);
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(navigationBack11) forControlEvents:UIControlEventTouchUpInside];
    self.backButton.userInteractionEnabled = YES;
    
    [self.bgImageView addSubview:self.headerImageView];
    [self.bgImageView addSubview:self.backButton];
    [self.view addSubview:self.bgImageView];
    
    self.infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.bgImageView.frame.origin.y+self.bgImageView.frame.size.height, kScreenWidth, kScreenHeight - self.bgImageView.frame.size.height) style:UITableViewStyleGrouped];
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    [self.view addSubview:self.infoTableView];
}

@end
