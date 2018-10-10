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

@interface LivingSectionDetailViewController ()<UITableViewDelegate, UITableViewDataSource,UserModule_OrderLivingCourseProtocol, UITextFieldDelegate,UITextViewDelegate>

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

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.mj_offsetY > 0) {
        if (textView.contentSize.height > 150) {
            textView.textColor = UIColorFromRGB(0x333333);
            dispatch_barrier_sync(dispatch_get_main_queue(), ^{
                textView.font = kMainFont;
            });
        }
        
    }else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString * tStr = textView.text;
            NSRange selectRange = NSMakeRange(textView.selectedRange.location, tStr.length);
            tStr = [tStr substringWithRange:selectRange];
            [UIView animateWithDuration:1 animations:^{
                textView.textColor = UIColorFromRGB(0xff7d00);
                textView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * 9 / 16);
            }];
        });
    }
    
    
    
    UIGravityBehavior * gravityBehavior = [[UIGravityBehavior alloc]init];
    [gravityBehavior addItem:self.view];
    [gravityBehavior removeItem:self.tableView];
    
    UICollisionBehavior * collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[self.view,self.tableView]];
    UIBezierPath * bezierPath1 = [UIBezierPath bezierPath];
    [bezierPath1 moveToPoint:CGPointMake(0, 0)];
    [bezierPath1 addLineToPoint:CGPointMake(0, kScreenHeight)];
    [bezierPath1 addLineToPoint:CGPointMake(kScreenWidth, kScreenHeight)];
    [bezierPath1 addLineToPoint:CGPointMake(kScreenWidth, 0)];
    [bezierPath1 stroke];
    [collisionBehavior addBoundaryWithIdentifier:@"boundary" forPath:bezierPath1];
    
    UISnapBehavior * snapBehavior = [[UISnapBehavior alloc]initWithItem:self.tableView snapToPoint:CGPointMake(kScreenWidth / 2, 0)];
    snapBehavior.damping = 0.7;
    
    UIAttachmentBehavior * attachmentBehavior = [[UIAttachmentBehavior alloc]initWithItem:self.tableView attachedToItem:self.view];
    attachmentBehavior.anchorPoint = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
    attachmentBehavior.damping = 0.8;
    attachmentBehavior.frequency = 30;
    
    UIDynamicAnimator * animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    [animator addBehavior:gravityBehavior];
    [animator addBehavior:collisionBehavior];
    [animator addBehavior:snapBehavior];
    
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
    tf.delegate = self;
    
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 9.0 / 16)];
    footView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    UIView * tipView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 2, 15)];
    tipView.backgroundColor = UIColorFromRGB(0xff1d00);
    [footView addSubview:tipView];
    
    if (section == self.dataArray.count) {
        UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 3)];
        footView.backgroundColor = UIColorFromRGB(0xfafafa);
        
        UITextField * tf = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 6)];
        tf.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.7];
        tf.textColor = UIColorFromRGB(0x333333);
        tf.delegate = self;
        tf.keyboardType = UIKeyboardTypePhonePad;
        tf.returnKeyType = UIReturnKeyDone;
        [footView addSubview:tf];
        UILabel * tipLB = [[UILabel alloc] initWithFrame:CGRectMake(0, tf.hd_height, kScreenWidth / 2, 30)];
        tipLB.textAlignment = NSTextAlignmentLeft;
        tipLB.backgroundColor = [UIColor grayColor];
        [footView addSubview:tipLB];
        
        return footView;
    }else if (section == self.dataArray.count + 1)
    {
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        bottomView.layer.cornerRadius = 5;
        bottomView.layer.masksToBounds = YES;
        bottomView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        bottomView.layer.borderWidth = 1;
        bottomView.layer.borderColor = [UIColor grayColor].CGColor;
        
        UITextField * bTF = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth - 40, 30)];
        bTF.keyboardType = UIKeyboardTypeNumberPad;
        bTF.returnKeyType = UIReturnKeyDone;
        bTF.borderStyle = UITextBorderStyleBezel;
        bTF.backgroundColor = UIColorFromRGB(0x333333);
        [footView addSubview:bTF];
        
    }
    return footView;
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
