//
//  LivingSectionDetailViewController.m
//  Accountant
//
//  Created by aaa on 2017/9/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "LivingSectionDetailViewController.h"
#import "LivingSectionDetailTableViewCell.h"
#import "CourseraManager.h"
#define kLivingSectionDetailCellID @"LivingSectionDetailCellID"

@interface LivingSectionDetailViewController ()<UITableViewDelegate, UITableViewDataSource,UserModule_OrderLivingCourseProtocol>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray * dataArray;

@property (nonatomic, assign)int selectOrderLivingSection;

@end

@implementation LivingSectionDetailViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [[CourseraManager sharedManager] getLivingSectionDetailArray];
    self.haveJurisdiction = [[self.courseInfoDic objectForKey:kHaveJurisdiction] intValue];
    [self navigationViewSetup];
    [self tablesSetup];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, 64)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"直播详情";
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

- (void)tablesSetup
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.navigationController.navigationBar.hd_height - kStatusBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"LivingSectionDetailTableViewCell" bundle:nil] forCellReuseIdentifier:kLivingSectionDetailCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LivingSectionDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kLivingSectionDetailCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    
    [cell resetInfoWithDic:dic];
    
    __weak typeof(self)weakSelf = self;
    cell.PlayBlock = ^(PlayType playType) {
        switch (playType) {
            case PlayType_living:
            {
                NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
                [infoDic setObject:[weakSelf.courseInfoDic objectForKey:kTeacherDetail] forKey:kTeacherDetail];
                [infoDic setObject:[weakSelf.courseInfoDic objectForKey:kTeacherPortraitUrl] forKey:kTeacherPortraitUrl];
                [infoDic setObject:[weakSelf.courseInfoDic objectForKey:kCourseTeacherName] forKey:kCourseTeacherName];
                [infoDic setObject:[dic objectForKey:kCourseSecondID] forKey:kCourseID];
                [infoDic setObject:[dic objectForKey:kCourseSecondName] forKey:kCourseName];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLivingChatClick object:infoDic];
            }
                break;
            case PlayType_order:
            {
                [SVProgressHUD show];
                weakSelf.selectOrderLivingSection = (int)indexPath.row;
                NSDictionary * orderDic = @{@"courseID":@(self.courseId),
                                            @"courseSecondID":[dic objectForKey:kCourseSecondID],
                                            @"livingTime":[[[dic objectForKey:kLivingTime] componentsSeparatedByString:@"~"] objectAtIndex:0]};
                [[UserManager sharedManager] didRequestOrderLivingCourseOperationWithCourseInfo:orderDic withNotifiedObject:self];
            
            }
                break;
            case PlayType_videoBack:
            {
                [weakSelf playBackWith:dic];
            }
                break;
                
            default:
                break;
        }
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    headView.backgroundColor = UIColorFromRGB(0xffffff);
    headView.layer.cornerRadius = 5;
    headView.layer.masksToBounds = YES;
    [self.view addSubview:headView];
    
    UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth / 2, 50)];
    titleLB.textColor = UIColorFromRGB(0x333333);
    titleLB.textAlignment = NSTextAlignmentCenter;
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(CGRectGetMaxX(titleLB.frame), 10, 30, 30);
    [closeBtn setTitle:@"140-140" forState:UIControlStateNormal];
    [closeBtn setTitleColor:UIColorFromRGB(0xff0000) forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [closeBtn setAdjustsImageWhenDisabled:YES];
    [headView addSubview:closeBtn];
    
    UITextField * tf = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth / 2, 0, kScreenWidth / 2, 50)];
    tf.textColor = UIColorFromRGB(0x333333);
    tf.textAlignment = NSTextAlignmentLeft;
    tf.background = [UIImage imageNamed:@""];
    tf.placeholder = @"";
    [headView addSubview:tf];
    
    UIGravityBehavior * gravity = [[UIGravityBehavior alloc]init];
    [gravity addItem:self.view];
    gravity.angle = 0;
    gravity.magnitude = 1.0;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

- (void)playBackWith:(NSDictionary *)infoDic
{
    if (self.haveJurisdiction) {
        
        if ([infoDic objectForKey:kPlayBackUrl] && [[infoDic objectForKey:kPlayBackUrl] length] > 0) {
            NSMutableDictionary * mInfoDic = [NSMutableDictionary dictionary];
            [mInfoDic setObject:[infoDic objectForKey:kCourseSecondID] forKey:kVideoId];
            [mInfoDic setObject:[infoDic objectForKey:kCourseSecondName] forKey:kVideoName];
            [mInfoDic setObject:[infoDic objectForKey:kPlayBackUrl] forKey:kVideoURL];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLivingPlayBackClick object:mInfoDic];
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"视频暂未上传完成，请稍等..."];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
        
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"暂无观看权限"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
}

#pragma mark - orderLivingProtocol

- (void)didRequestOrderLivingSuccessed
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"预约成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    
    [[CourseraManager sharedManager] refreshLivingSectionStateOrder_complate:self.selectOrderLivingSection];
    self.dataArray = [[CourseraManager sharedManager] getLivingSectionDetailArray];
    [self.tableView reloadData];
}

- (void)didRequestOrderLivingFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


@end
