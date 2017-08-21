//
//  CourseCategoryViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/3.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CourseCategoryViewController.h"
#import "UIMacro.h"
#import "CourseraManager.h"
#import "CourseModuleProtocol.h"
#import "SVProgressHUD.h"
#import "UIUtility.h"
#import "CommonMacro.h"
#import "AllCourseViewController.h"
#import "CategoryTableViewCell.h"
#import "MainViewMacro.h"
#import "NotificaitonMacro.h"
#import "AllCategoryTableViewCell.h"
#import "ScreenView.h"
#import "CoursecategoryTableViewCell.h"
#import "SecondLevelTableViewCell.h"

#import "HYSegmentedControl.h"
#import "ClassroomLivingTableViewCell.h"
#import "VideoPlayViewController.h"

#import "LivingCourseViewController.h"

#import "CourseraManager.h"
#import "CourseModuleProtocol.h"

#define kClassroomcellId @"ClassroomVideoTableViewCellID"
#define kClassroomLivingcellId @"ClassroomLivingTableViewCellID"

#define kTime 0.3
#define kSegmentHeight 42
#define OrderAlerttag 2000

@interface CourseCategoryViewController ()<HYSegmentedControlDelegate, UITableViewDelegate, UITableViewDataSource, CourseModule_AllCourseCategoryProtocol, CourseModule_NotStartLivingCourse, CourseModule_EndLivingCourse,UIAlertViewDelegate,UserModule_OrderLivingCourseProtocol>

/**
 *  视频和直播页面切换segment
 */
@property (nonatomic, strong)HYSegmentedControl * segmentC;
@property (nonatomic, strong)HYSegmentedControl * livingSegmentC;

@property (nonatomic, strong)UISegmentedControl * topSegment;

@property (nonatomic, strong)UIScrollView * scrollView;

// zhibo
@property (nonatomic, strong)UITableView *livingTableview;

// 课程视频
@property (nonatomic, strong)UITableView *videoTableview;
//@property (nonatomic, strong)UITableView                    *secondLevelTableView;
@property (nonatomic, strong) UITableView   *screenTableView;
@property (nonatomic, strong) UIView        *screenBackView;
@property (nonatomic, strong) UITableView *sectionScreentableview;

@property (nonatomic, strong) NSIndexPath *currentVideoIndexpath;
@property (nonatomic, strong) NSIndexPath *currentSectionIndexpath;

@property (nonatomic,strong) NSArray                        *categoryArray;
@property (nonatomic,strong) NSArray                        *allCategoryArray;
@property (nonatomic, strong)NSArray                        *sectionArray;

@property (nonatomic, strong)NSDictionary *currentCourseInfo;
@property (nonatomic, strong)NSMutableArray *dataSourceArr;
@property (nonatomic, strong)NSMutableArray * allCourseArr;
@property (nonatomic, strong)NSMutableArray * videoCourseArray;
@property (nonatomic, strong)NSMutableArray *livingCourseArr;

@property (nonatomic, assign)NSInteger topIndex;
@property (nonatomic,assign)NSInteger videoIndex;
@property (nonatomic, assign)NSInteger livingIndex;

@property (nonatomic, assign) int orderCourseId;

@end

@implementation CourseCategoryViewController
- (NSMutableArray *)dataSourceArr
{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}
- (NSMutableArray *)allCourseArr
{
    if (!_allCourseArr) {
        _allCourseArr = [NSMutableArray array];
    }
    return _allCourseArr;
}

- (NSMutableArray *)videoCourseArray
{
    if (!_videoCourseArray) {
        _videoCourseArray = [NSMutableArray array];
    }
    return _videoCourseArray;
}

- (NSMutableArray *)livingCourseArr
{
    if (!_livingCourseArr) {
        _livingCourseArr = [NSMutableArray array];
    }
    return _livingCourseArr;
}

- (NSArray *)sectionArray
{
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kCommonNavigationBarColor;
    
    [self addNotification];
    [self doRequestAllCategory];
    [self doRequestLivingcourse];
    [self navigationViewSetup];
    [self tableviewSetup];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfCourseVCdidLoad object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    if (![[UserManager sharedManager] isUserLogin]) {
        self.videoTableview.tableHeaderView = [self getTableHeadView];
        self.livingTableview.tableHeaderView = [self getTableHeadView];
    }else
    {
        self.videoTableview.tableHeaderView = nil;
        self.livingTableview.tableHeaderView = nil;
        
        if (self.topSegment.selectedSegmentIndex == 0) {
            [self.videoTableview reloadData];
        }else
        {
            [self.livingTableview reloadData];
        }
        
    }
}


#pragma mark - request funcs
- (void)doRequestAllCategory
{
    [SVProgressHUD show];
    [[CourseraManager sharedManager] didRequestAllCourseCategoryWithNotifiedObject:self];
}

- (void)doRequestLivingcourse
{
    [SVProgressHUD show];
    [[CourseraManager sharedManager] didRequestNotStartLivingCourseWithNotifiedObject:self];
    [[CourseraManager sharedManager] didRequestEndLivingCourseWithNotifiedObject:self];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreLivingClick:) name:kNotificationMoreLiving object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseClick:) name:kNotificationDetailCourse object:nil];
    
}

- (void)courseClick:(NSNotification *)notification
{
    NSDictionary * info = notification.object;
    
    NSLog(@"%@", [info description]);
    
    if (self.topSegment.selectedSegmentIndex == 1) {
        [self.topSegment setSelectedSegmentIndex:0];
        [self changeSlect:self.topSegment];
    }
    
    int categoryId = [[info objectForKey:kCourseCategoryId] intValue];
    NSString * categoryName = [info objectForKey:kCourseCategoryName];
    
    for (int i = 0; i < self.categoryArray.count; i++) {
        NSDictionary * infoDic = [self.categoryArray objectAtIndex:i];
        
        if (categoryId == [[infoDic objectForKey:kCourseCategoryId] intValue]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i + 1 inSection:0];
            self.currentVideoIndexpath = indexPath;
            self.currentSectionIndexpath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self reloadVideo:indexPath];
            
            [self hideScreen];
            return;
        }else
        {
            NSArray * secondArr = [infoDic objectForKey:kCourseCategoryCourseInfos];
            for (int j = 0; j < secondArr.count; j++) {
                NSDictionary * sectionDic = secondArr[j];
                if (categoryId == [[sectionDic objectForKey:kCourseSecondID] intValue]) {
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i + 1 inSection:0];
                    self.currentVideoIndexpath = indexPath;
                    self.currentSectionIndexpath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self reloadVideo:indexPath];
                    
                    NSIndexPath * indexPath1 = [NSIndexPath indexPathForRow:j+1 inSection:0];
                    self.currentSectionIndexpath = indexPath1;
                    [self reloadSection:indexPath1];
                    [self hideScreen];
                    return;
                }
            }
        }
        
    }
}



- (void)moreLivingClick:(NSNotification *)notification
{
    [self.topSegment setSelectedSegmentIndex:1];
    [self changeSlect:self.topSegment];
}

- (void)navigationViewSetup
{
    self.navigationItem.title = @"课堂";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.titleView = [self prepareTitleView];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50,NSFontAttributeName:[UIFont systemFontOfSize:17]};
}
- (UIView *)prepareTitleView
{
    
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 7, kScreenWidth - 100, 30)];
    titleView.backgroundColor = [UIColor whiteColor];
    
    self.topSegment  = [[UISegmentedControl alloc]initWithItems:@[@"视频", @"直播"]];
    self.topSegment.frame = CGRectMake(titleView.hd_centerX - 75, 1, 150, 28);
    self.topSegment.tintColor = kCommonMainColor;
    
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:UIColorFromRGBValue(0xffffff)};
    [self.topSegment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName: kCommonMainColor};
    [self.topSegment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    self.topSegment.selectedSegmentIndex = 0;
    self.topIndex = 0;
    [self.topSegment addTarget:self action:@selector(changeSlect:) forControlEvents:UIControlEventValueChanged];
    
    [titleView addSubview:self.topSegment];
    
    return titleView;
}

- (void)tableviewSetup
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kTabBarHeight)];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kTabBarHeight - kSegmentHeight);
    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    
    self.segmentC = [[HYSegmentedControl alloc] initWithOriginY:0 Titles:@[@"全部课程",@"全部课程"] delegate:self drop:YES] ;
    [self.scrollView addSubview:self.segmentC];
    
    self.livingSegmentC = [[HYSegmentedControl alloc] initWithOriginY:0 Titles:@[@"近期直播",@"往期直播"] delegate:self];
    self.livingSegmentC.hd_x = kScreenWidth;
    [self.scrollView addSubview:self.livingSegmentC];
    
    
    self.videoTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, kSegmentHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kTabBarHeight - 42) style:UITableViewStylePlain];
    self.videoTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.videoTableview.delegate = self;
    self.videoTableview.dataSource = self;
    self.videoTableview.backgroundColor = UIRGBColor(230, 230, 230);
    self.videoTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.videoTableview registerClass:[CoursecategoryTableViewCell class] forCellReuseIdentifier:kClassroomcellId];
    [self.scrollView addSubview:self.videoTableview];
    self.videoTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self doRequestAllCategory];
    }];
    
    self.livingTableview = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth, kSegmentHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kTabBarHeight - kSegmentHeight) style:UITableViewStylePlain];
    self.livingTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.livingTableview.delegate = self;
    self.livingTableview.dataSource = self;
    self.livingTableview.backgroundColor = UIRGBColor(230, 230, 230);
    
    self.livingTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.livingIndex == 0) {
            [SVProgressHUD show];
            [[CourseraManager sharedManager] didRequestNotStartLivingCourseWithNotifiedObject:self];
        }else
        {
            [SVProgressHUD show];
            [[CourseraManager sharedManager]didRequestEndLivingCourseWithNotifiedObject:self];
        }
    }];
    
    [self.livingTableview registerNib:[UINib nibWithNibName:@"ClassroomLivingTableViewCell" bundle:nil] forCellReuseIdentifier:kClassroomLivingcellId];
    [self.scrollView addSubview:self.livingTableview];
    
    
    self.screenBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 41, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight - kSegmentHeight + 1)];
    self.screenBackView.backgroundColor = [UIColor colorWithWhite:.4 alpha:.5];
    [self.view addSubview:self.screenBackView];
    
    UITapGestureRecognizer * tip = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideScreen)];
    [self.screenBackView addGestureRecognizer:tip];
    
    self.screenTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kSegmentHeight - 1, kScreenWidth / 2 , 260) style:UITableViewStylePlain];
    self.screenTableView.delegate = self;
    self.screenTableView.dataSource = self;
    self.screenTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.screenTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.screenTableView];
    
    self.sectionScreentableview = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth / 2, kSegmentHeight - 1, kScreenWidth / 2 , 80) style:UITableViewStylePlain];
    self.sectionScreentableview.delegate = self;
    self.sectionScreentableview.dataSource = self;
    self.sectionScreentableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.sectionScreentableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.sectionScreentableview];
    
    [self.screenTableView setHidden:YES];
    [self.screenBackView setHidden:YES];
    [self.sectionScreentableview setHidden:YES];
    
}

- (void)showScreenTableview:(BOOL)isShow
{
    [self.sectionScreentableview setHidden:YES];
    if (isShow) {
        [self.screenBackView setHidden:NO];
        [self.screenTableView setHidden:NO];
        self.screenTableView.frame = CGRectMake(0, kSegmentHeight - 1, kScreenWidth / 2 , 0);
        
        [UIView animateWithDuration:kTime animations:^{
            self.screenTableView.frame = CGRectMake(0, kSegmentHeight - 1, kScreenWidth / 2 , 260);
        } completion:^(BOOL finished) {
            
        }];
        
    }else
    {
        [self.screenBackView setHidden:NO];
        self.screenTableView.frame = CGRectMake(0, kSegmentHeight - 1, kScreenWidth /2 , 260);
        
        [UIView animateWithDuration:kTime animations:^{
            self.screenTableView.frame = CGRectMake(0, kSegmentHeight - 1, kScreenWidth / 2 , 0);
        } completion:^(BOOL finished) {
            [self.screenTableView setHidden:YES];
            [self.screenBackView setHidden:YES];
        }];
    }
    
}

- (void)showSecondLeveltableview:(BOOL)isShow
{
    [self.screenTableView setHidden:YES];
    
    if (isShow) {
        [self.screenBackView setHidden:NO];
        [self.sectionScreentableview setHidden:NO];
        self.sectionScreentableview.frame = CGRectMake(kScreenWidth / 2 , 41, kScreenWidth / 2 , 0);
        
        [UIView animateWithDuration:kTime animations:^{
            self.sectionScreentableview.frame = CGRectMake(kScreenWidth / 2 , 41, kScreenWidth / 2 , 80);
        } completion:^(BOOL finished) {
            
        }];
    }else
    {
        [self.screenBackView setHidden:NO];
        self.sectionScreentableview.frame = CGRectMake(kScreenWidth / 2 , 41, kScreenWidth / 2 , 80);
        [UIView animateWithDuration:kTime animations:^{
            self.sectionScreentableview.frame = CGRectMake(kScreenWidth / 2 , 41, kScreenWidth / 2 , 0);
        } completion:^(BOOL finished) {
            [self.sectionScreentableview setHidden:YES];
            [self.screenBackView setHidden:YES];
        }];
    }
}

- (void)hideScreen
{
    if (self.screenTableView.hidden && self.sectionScreentableview.hidden) {
        return;
    }
    [self.segmentC clickBT:self.videoIndex];
}

#pragma mark = 登录头部视图
- (UIView *)getTableHeadView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    headView.backgroundColor = kBackgroundGrayColor;
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, kScreenWidth, 15)];
    titleLabel.text = @"立即登录，查看你买过的课程";
    titleLabel.textColor = kCommonMainTextColor_50;
    titleLabel.font = kMainFont;
    titleLabel.textAlignment = 1;
    [headView addSubview:titleLabel];
    
    UIButton * loginBT = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBT.frame = CGRectMake(kScreenWidth / 2  - 50,CGRectGetMaxY(titleLabel.frame) + 20, 100, 25);
    loginBT.layer.cornerRadius = loginBT.hd_height / 2;
    loginBT.layer.masksToBounds = YES;
    loginBT.backgroundColor = UIRGBColor(15, 66, 250);
    [loginBT setTitle:@"登录" forState:UIControlStateNormal];
    [loginBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBT.titleLabel.font = kMainFont;
    [headView addSubview:loginBT];
    
    UIButton * registeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    registeBT.frame = CGRectMake(kScreenWidth / 2 + 10,CGRectGetMaxY(titleLabel.frame) + 20, 100, 25);
    registeBT.layer.cornerRadius = loginBT.hd_height / 2;
    registeBT.layer.masksToBounds = YES;
    registeBT.layer.borderWidth = 1;
    registeBT.layer.borderColor = UIRGBColor(15, 66, 250).CGColor;
    registeBT.backgroundColor = kBackgroundGrayColor;
    [registeBT setTitle:@"注册" forState:UIControlStateNormal];
    [registeBT setTitleColor:UIRGBColor(15, 66, 250) forState:UIControlStateNormal];
    registeBT.titleLabel.font = kMainFont;
//    [headView addSubview:registeBT];
    
    [loginBT addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [registeBT addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    
    return headView;
}

- (void)loginClick
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationOfLoginClick object:nil];
}

- (void)registerClick
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationOfRegisterClick object:nil];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.screenTableView]) {
        return self.categoryArray.count + 1;
    }
    if ([tableView isEqual:self.sectionScreentableview]) {
        return self.sectionArray.count + 1;
    }
    if ([tableView isEqual:self.videoTableview]) {
        return [self.dataSourceArr count];
    }
    return [self.dataSourceArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView isEqual:self.screenTableView]) {
        UITableViewCell * cell = [UIUtility getCellWithCellName:@"cellID" inTableView:tableView andCellClass:[UITableViewCell class]];
        cell.backgroundColor = [UIColor whiteColor];
        
        if (![cell viewWithTag:1000]) {
            UIView * lineVlew = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth / 2, 1)];
            lineVlew.backgroundColor = kTableViewCellSeparatorColor;
            lineVlew.tag = 1000;
            [cell addSubview:lineVlew];
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"全部课程";
        }else
        {
            NSDictionary *categoryDic = [self.categoryArray objectAtIndex:indexPath.row - 1];
            cell.textLabel.text = [categoryDic objectForKey:kCourseCategoryName];
        }
        
        if ([indexPath isEqual:self.currentVideoIndexpath]) {
            cell.textLabel.textColor = UIColorFromRGB(0x1D7AF8);
        }else
        {
            cell.textLabel.textColor = kMainTextColor;
        }
        cell.textLabel.textAlignment = 1;
        return cell;
    }else if ([tableView isEqual:self.sectionScreentableview]) {
        UITableViewCell * cell = [UIUtility getCellWithCellName:@"cellID" inTableView:tableView andCellClass:[UITableViewCell class]];
        cell.backgroundColor = [UIColor whiteColor];
        
        if (![cell viewWithTag:2000]) {
            UIView * lineVlew = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth / 2, 1)];
            lineVlew.backgroundColor = kTableViewCellSeparatorColor;
            lineVlew.tag = 2000;
            [cell addSubview:lineVlew];
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"全部课程";
        }else
        {
            NSDictionary *categoryDic = [self.sectionArray objectAtIndex:indexPath.row - 1];
            cell.textLabel.text = [categoryDic objectForKey:kCourseSecondName];
        }
        
        if ([indexPath isEqual:self.currentSectionIndexpath]) {
            cell.textLabel.textColor = UIColorFromRGB(0x1D7AF8);
        }else
        {
            cell.textLabel.textColor = kMainTextColor;
        }
        cell.textLabel.textAlignment = 1;
        return cell;
    }
    else if ([tableView isEqual:self.videoTableview]) {
        CoursecategoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kClassroomcellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.courseType = CourseCategoryType_nomal;
        if (indexPath.row <= self.dataSourceArr.count - 1) {
            [cell resetCellContent:[self.dataSourceArr objectAtIndex:indexPath.row]];
        }
        cell.courseChapterNameLabel.hidden = YES;
        return cell;
    }else
    {
        ClassroomLivingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kClassroomLivingcellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row <= self.dataSourceArr.count - 1) {
            [cell resetWithDic:[self.dataSourceArr objectAtIndex:indexPath.row]];
        }
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.screenTableView] || [tableView isEqual:self.sectionScreentableview]) {
        return 40;
    }
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.screenTableView]) {
        self.currentVideoIndexpath = indexPath;
        self.currentSectionIndexpath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self reloadVideo:indexPath];
        
        [self hideScreen];
        
        return;
    }
    if ([tableView isEqual:self.sectionScreentableview]) {
        self.currentSectionIndexpath = indexPath;
        [self reloadSection:indexPath];
        [self hideScreen];
        
        return;
    }
    
    NSDictionary *info = [self.dataSourceArr objectAtIndex:indexPath.row];
    if ([tableView isEqual:self.livingTableview]) {
        self.orderCourseId = [[info objectForKey:kCourseID] intValue];
        if ([[info objectForKey:kLivingState] intValue] != 5) {
            
            if ([[UserManager sharedManager] isUserLogin]){
            
                if ([[info objectForKey:kLivingState] intValue] == 3) {
                    UIAlertView *orderAlert = [[UIAlertView alloc]initWithTitle:nil message:@"您还未预约，是否预约？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                    orderAlert.tag = OrderAlerttag;
                    [orderAlert show];
                }else
                {
                    NSLog(@"%@", info);
                    
//                    LivingCourseViewController * vc = [[LivingCourseViewController alloc]init];
//                    vc.infoDic = info;
//                    vc.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:vc animated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLivingChatClick object:info];
                }
            }else
            {
                 [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLoginClick object:nil];
            }
            return;
        }
    }
    
    NSLog(@"info = %@", [info description]);
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfCourseClick object:info];
}

#pragma mark - alertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == OrderAlerttag) {
        if (buttonIndex == 1) {
            [SVProgressHUD showWithStatus:@"预约中"];
            [[UserManager sharedManager] didRequestOrderLivingCourseOperationWithCourseId:self.orderCourseId withNotifiedObject:self];
        }
    }
}

#pragma mark - orderLivingCourseProtocal
- (void)didRequestOrderLivingSuccessed
{
    [SVProgressHUD showWithStatus:@"预约成功"];
    [self performSelector:@selector(orderSuccess) withObject:nil afterDelay:0.7];
}

- (void)didRequestOrderLivingFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:failedInfo delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    [alert performSelector:@selector(dismiss) withObject:nil afterDelay:0.7];
}

- (void)orderSuccess
{
    [SVProgressHUD dismiss];
}

#pragma mark - segmentAction
- (void)changeSlect:(UISegmentedControl *)segment
{
    self.topIndex = segment.selectedSegmentIndex;
    [self.scrollView setContentOffset:CGPointMake(segment.selectedSegmentIndex * _scrollView.hd_width, 0) animated:NO];
    
    if (self.topIndex == 0) {
        [self reloadVideo:self.currentVideoIndexpath];
        [self reloadSection:self.currentSectionIndexpath];
        [self.videoTableview reloadData];
    }else
    {
        [self hideScreen];
        self.dataSourceArr = self.livingCourseArr;
        [self.livingTableview reloadData];
    }
}

#pragma mark - HYSegmentedControl 代理方法
- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    if (self.topIndex == 0) {
        self.videoIndex = index;
        
        if (index == 0) {
            
            if (self.screenTableView.hidden) {
                
                [self showScreenTableview:YES];
            }else
            {
                [self showScreenTableview:NO];
            }
        }else
        {
            if (self.sectionScreentableview.hidden) {
                
                [self showSecondLeveltableview:YES];
            }else
            {
                [self showSecondLeveltableview:NO];
            }
        }
        [self.livingTableview reloadData];
        [self.videoTableview reloadData];
        
    }else
    {
        self.livingIndex = index;
        
        if (index == 0) {
            self.livingCourseArr = [[CourseraManager sharedManager] getNotStartLivingCourseArray];
        }else
        {
            self.livingCourseArr = [[CourseraManager sharedManager] getEndLivingCourseArray] ;
        }
        
        if (!self.screenTableView.hidden) {
            
            [self showScreenTableview:NO];
        }
        if (!self.sectionScreentableview.hidden) {
            
            [self showSecondLeveltableview:NO];
        }
        
        self.dataSourceArr = self.livingCourseArr;
        [self.livingTableview reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - all course category delegate
- (void)didRequestAllCourseCategorySuccessed
{
    [SVProgressHUD dismiss];
    self.categoryArray = [[CourseraManager sharedManager] getAllCategoryArray];
    [self getAllDataSourseArray];
    [self.videoTableview.mj_header endRefreshing];
    
    [self reloadVideo:self.currentVideoIndexpath];
    [self reloadSection:self.currentSectionIndexpath];
    
    [self.screenTableView reloadData];
    [self.videoTableview reloadData];
    [self.sectionScreentableview reloadData];
}

- (void)getAllDataSourseArray
{
    for (NSDictionary * dic in self.categoryArray) {
        
        NSArray * courseSecondArr = [dic objectForKey:kCourseCategoryCourseInfos];
        for (NSDictionary * secondDic in courseSecondArr) {
            NSArray * courseArr = [secondDic objectForKey:kCourseCategorySecondCourseInfos];
            for (NSDictionary * courseDic in courseArr) {
                [self.allCourseArr addObject:courseDic];
            }
        }
    }
    self.videoCourseArray = self.allCourseArr;
    self.dataSourceArr = [self.allCourseArr copy];
}

- (void)didRequestAllCourseFailed
{
    [SVProgressHUD dismiss];
    [self.videoTableview.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:@"网络连接失败，请稍后再试"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)didRequestEndLivingCourseSuccessed
{
    [SVProgressHUD dismiss];
    [self.livingTableview.mj_header endRefreshing];
}
- (void)didRequestEndLivingCourseFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.livingTableview.mj_header endRefreshing];
}

- (void)didRequestNotStartLivingCourseSuccessed
{
    [SVProgressHUD dismiss];
    self.livingCourseArr = [[CourseraManager sharedManager] getNotStartLivingCourseArray];
    [self.livingTableview.mj_header endRefreshing];
    [self.livingTableview reloadData];
}

- (void)didRequestNotStartLivingCourseFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.livingTableview.mj_header endRefreshing];
}

#pragma mark - reload

- (void)reloadVideo:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        self.videoCourseArray = self.allCourseArr;
        self.dataSourceArr = self.allCourseArr;
        self.sectionArray = @[];
        self.currentCourseInfo = nil;
        [self.videoTableview reloadData];
        [self.screenTableView reloadData];
        [self.sectionScreentableview reloadData];
        [self.segmentC changeTitle:@"全部课程" withIndex:0];
        [self.segmentC changeTitle:@"全部课程" withIndex:1];
    }else
    {
        NSMutableArray * array = [NSMutableArray array];
        
        self.currentCourseInfo = [self.categoryArray objectAtIndex:indexPath.row - 1];
        self.sectionArray = [self.currentCourseInfo objectForKey:kCourseCategoryCourseInfos];
        for (NSDictionary * courseSecondInfo in [self.currentCourseInfo objectForKey:kCourseCategoryCourseInfos]) {
            for (NSDictionary *courseDic in [courseSecondInfo objectForKey:kCourseCategorySecondCourseInfos]) {
                
                NSLog(@"%@", [courseSecondInfo description]);
                
                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                dic = [courseDic mutableCopy];
                if ([courseSecondInfo objectForKey:kCourseSecondName] && [[courseSecondInfo objectForKey:kCourseSecondName] length] != 0) {
                    [dic setObject:[courseSecondInfo objectForKey:kCourseSecondName] forKey:kCourseSecondName];
                }
                [array addObject:dic];
            }
        }
        
        self.videoCourseArray = array;
        self.dataSourceArr = [array copy];
        
        [self.segmentC changeTitle:[self.currentCourseInfo objectForKey:kCourseCategoryName] withIndex:0];
        [self.segmentC changeTitle:@"全部课程" withIndex:1];
        [self.videoTableview reloadData];
        [self.screenTableView reloadData];
        [self.sectionScreentableview reloadData];
    }
}

- (void)reloadSection:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSMutableArray * array = [NSMutableArray array];
        for (NSDictionary * courseSecondInfo in [self.currentCourseInfo objectForKey:kCourseCategoryCourseInfos]) {
            for (NSDictionary *courseDic in [courseSecondInfo objectForKey:kCourseCategorySecondCourseInfos]) {
                
                NSLog(@"%@", [courseSecondInfo description]);
                
                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                dic = [courseDic mutableCopy];
                if ([courseSecondInfo objectForKey:kCourseSecondName] && [[courseSecondInfo objectForKey:kCourseSecondName] length] != 0) {
                    [dic setObject:[courseSecondInfo objectForKey:kCourseSecondName] forKey:kCourseSecondName];
                }
                [array addObject:dic];
            }
        }
        [self.segmentC changeTitle:@"全部课程" withIndex:1];
        
        self.videoCourseArray = array;
        self.dataSourceArr = [array copy];
        if (self.currentVideoIndexpath.row == 0) {
            self.videoCourseArray = self.allCourseArr;
            self.dataSourceArr = self.allCourseArr;
        }
        
        [self.videoTableview reloadData];
        [self.screenTableView reloadData];
        [self.sectionScreentableview reloadData];
    }else
    {
        NSMutableArray * array = [NSMutableArray array];
        self.sectionArray = [self.currentCourseInfo objectForKey:kCourseCategoryCourseInfos];
        NSDictionary * courseSecondInfo = [self.sectionArray objectAtIndex:indexPath.row - 1];
        
        for (NSDictionary *courseDic in [courseSecondInfo objectForKey:kCourseCategorySecondCourseInfos]) {
            
            NSLog(@"%@", [courseSecondInfo description]);
            
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            dic = [courseDic mutableCopy];
            if ([courseSecondInfo objectForKey:kCourseSecondName] && [[courseSecondInfo objectForKey:kCourseSecondName] length] != 0) {
                [dic setObject:[courseSecondInfo objectForKey:kCourseSecondName] forKey:kCourseSecondName];
            }
            [array addObject:dic];
        }
        
        self.dataSourceArr = [array copy];
        [self.segmentC changeTitle:[courseSecondInfo objectForKey:kCourseSecondName] withIndex:1];
        [self.videoTableview reloadData];
        [self.screenTableView reloadData];
        [self.sectionScreentableview reloadData];
    }
}

@end
