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
#import "LivingCourseTableViewCell.h"

#import "HYSegmentedControl.h"
#import "ClassroomLivingTableViewCell.h"
#import "VideoPlayViewController.h"

#import "LivingCourseViewController.h"

#import "CourseraManager.h"
#import "CourseModuleProtocol.h"
#import "MonthSelectView.h"
#import "LivingSectionDetailViewController.h"
#import "MainLivingCourseTableViewCell.h"

#import "CourseSectionTableViewCell.h"
#define kCourseSectionCellID  @"CourseSectionCellID"

#define kClassroomcellId @"ClassroomVideoTableViewCellID"
#define kClassroomLivingcellId @"ClassroomLivingTableViewCellID"
#define kLivingCourseCellId @"LivingCourseCellID"

#define kVideoTableTag  10000
#define kTime 0.3
#define kSegmentHeight 42
#define OrderAlerttag 2000

@interface CourseCategoryViewController ()<HYSegmentedControlDelegate, UITableViewDelegate, UITableViewDataSource, CourseModule_AllCourseCategoryProtocol, CourseModule_NotStartLivingCourse, CourseModule_EndLivingCourse,UIAlertViewDelegate,CourseModule_LivingSectionDetail,UIScrollViewDelegate,UserModule_OrderLivingCourseProtocol,UserModule_CancelOrderLivingCourseProtocol,UIScrollViewDelegate,UserModule_LivingBackYearList,CourseModule_PackageProtocol>

/**
 *  视频和直播页面切换segment
 */
@property (nonatomic, strong)HYSegmentedControl * segmentC;
@property (nonatomic, strong)HYSegmentedControl * livingSegmentC;
@property (nonatomic, strong)MonthSelectView    * monthSelectView;

@property (nonatomic, strong)UISegmentedControl * topSegment;

@property (nonatomic, strong)UIScrollView * scrollView;

// zhibo
@property (nonatomic, strong)UITableView *livingTableview;// 直播课列表

// 课程视频
@property (nonatomic, strong)UITableView *videoTableview;
@property (nonatomic, strong) UITableView   *screenTableView;// 视频课程分类
@property (nonatomic, strong) UIView        *screenBackView;
@property (nonatomic, strong) UITableView *sectionScreentableview;// 视频课程小节分类
@property (nonatomic, strong) UITableView * teacherTableView;
@property (nonatomic, strong) UITableView * monthTableView;
@property (nonatomic, strong) UIView        *livingBackView;
@property (nonatomic, strong)UITableView *yearListTableView;
@property (nonatomic, strong)UIView * yearBackView;

@property (nonatomic, strong) NSIndexPath *currentVideoIndexpath;// 课程分类indexpath
@property (nonatomic, strong) NSIndexPath *currentSectionIndexpath;// 课程小节indexpath

@property (nonatomic, strong)NSArray                        *packageArray;
@property (nonatomic,strong) NSArray                        *categoryArray;// 课程数据源
@property (nonatomic,strong) NSArray                        *allCategoryArray;
@property (nonatomic, strong)NSArray                        *sectionArray;// 课程小节数据源

@property (nonatomic, strong)NSDictionary *currentCourseInfo;
@property (nonatomic, strong)NSMutableArray *dataSourceArr;// 数据源
@property (nonatomic, strong)NSMutableArray * allCourseArr;
@property (nonatomic, strong)NSMutableArray * videoCourseArray;// 视频数据源
@property (nonatomic, strong)NSMutableArray *livingCourseArr;// 直播课数据源

@property (nonatomic, strong)NSMutableArray *teacherArr;

@property (nonatomic, assign)NSInteger topIndex;//
@property (nonatomic,assign)NSInteger videoIndex;// 视频 segmentIndex
@property (nonatomic, assign)NSInteger livingIndex;// 直播 segmentIndex

@property (nonatomic, assign) int selectCurrentMonthCourseId;// 选中的本月直播课程分类id
@property (nonatomic, strong)NSDictionary * selectCurrentMonthCourseSectionInfoDic;// 选中的本月直播课程小节info

@property (nonatomic, strong)NSDictionary * selectCourseInfoDic;

@property (nonatomic, assign)int selectLivingCourseId;// 已选中直播课id
@property (nonatomic, assign)CGFloat teachertableviewheight;
@property (nonatomic, assign)CGFloat sectionScreentableviewHeight;
@property (nonatomic, strong)NSString * teacherId;// 已选中的老师id
@property (nonatomic, strong)NSIndexPath *teacherIndexpath;// 选择老师indexpath
@property (nonatomic, strong)NSIndexPath *monthIndexPath;// 本月直播还是往期直播indexpath
@property (nonatomic, strong)NSIndexPath *selectMonthIndexpath;// 往期直播课选中的月份indexpath
@property (nonatomic, assign)int        month;// 往期直播课选中月份，选年为0。
@property (nonatomic, strong)NSString * yearStr;

@property (nonatomic, strong)NSDictionary *selectOrderLivingSectionInfoDic;// 预约课

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

- (NSMutableArray *)teacherArr
{
    if (!_teacherArr) {
        _teacherArr = [NSMutableArray array];
    }
    return _teacherArr;
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
    
    self.teacherId = @"";
    self.month = [NSString getCurrentMonth];
    self.yearStr = [NSString stringWithFormat:@"%d", [NSString getCurrentYear]];
    [self addNotification];
    [self doRequestAllCategory];
    [self doRequestLivingcourse];
    [self navigationViewSetup];
    [self tableviewSetup];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfCourseVCdidLoad object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.selectCurrentMonthCourseId = 0;
    self.selectCurrentMonthCourseSectionInfoDic = nil;
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
            [self reloadLivingTableViewData];
        }
        
    }
}

#pragma mark - request funcs
- (void)doRequestAllCategory
{
    [SVProgressHUD show];
    [[CourseraManager sharedManager] didRequestAllPackageWithNotifiedObject:self];
    [[CourseraManager sharedManager] didRequestAllCourseCategoryWithNotifiedObject:self];
}

- (void)doRequestLivingcourse
{
    [SVProgressHUD show];
    [[CourseraManager sharedManager] didRequestNotStartLivingCourseWithInfo:@{@"Month":@(self.month),@"year":self.yearStr} NotifiedObject:self];
//    [[CourseraManager sharedManager] didRequestEndLivingCourseWithNotifiedObject:self];
    if ([[[UserManager sharedManager] getLivingBackYearList] count] == 0) {
        [[UserManager sharedManager]didRequestLivingBackYearListWithInfo:@{} withNotifiedObject:self];
    }
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
            
            [self hideScreenWithHide:NO];
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
                    
                    NSIndexPath * indexPath1 = [NSIndexPath indexPathForRow:j inSection:0];
                    self.currentSectionIndexpath = indexPath1;
                    [self reloadSection:indexPath1];
                    [self hideScreenWithHide:NO];
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
    
    self.topSegment  = [[UISegmentedControl alloc]initWithItems:@[@"点播", @"直播"]];
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
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    self.segmentC = [[HYSegmentedControl alloc] initWithOriginY:0 Titles:@[@"全部课程",@"全部课程"] delegate:self drop:YES] ;
//    [self.scrollView addSubview:self.segmentC];
    
    self.livingSegmentC = [[HYSegmentedControl alloc] initWithOriginX:kScreenWidth OriginY:0 Titles:@[@"本月直播",@"老师"] delegate:self drop:YES];
    self.livingSegmentC.hd_x = kScreenWidth;
    [self.scrollView addSubview:self.livingSegmentC];
    
    
    self.videoTableview = [[UITableView alloc]initWithFrame:CGRectMake(75, 0, kScreenWidth - 75, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kTabBarHeight) style:UITableViewStylePlain];
    self.videoTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.videoTableview.tag = kVideoTableTag;
    self.videoTableview.delegate = self;
    self.videoTableview.dataSource = self;
    self.videoTableview.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.videoTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.videoTableview registerClass:[CourseSectionTableViewCell class] forCellReuseIdentifier:kCourseSectionCellID];
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
        [SVProgressHUD show];
        [[CourseraManager sharedManager] didRequestNotStartLivingCourseWithInfo:@{@"Month":@(self.month),@"year":self.yearStr} NotifiedObject:self];
    }];
    
    [self.livingTableview registerClass:[LivingCourseTableViewCell class] forCellReuseIdentifier:kLivingCourseCellId];
    [self.livingTableview registerNib:[UINib nibWithNibName:@"ClassroomLivingTableViewCell" bundle:nil] forCellReuseIdentifier:kClassroomLivingcellId];
    [self.scrollView addSubview:self.livingTableview];
    
    // 月份选择view
    self.monthSelectView = [[MonthSelectView alloc]initWithFrame:CGRectMake(kScreenWidth, kSegmentHeight, kScreenWidth, 35)];
    [self.monthSelectView reloadData];
    __weak typeof(self)weakSef = self;
    self.monthSelectView.MonthSelectBlock = ^(int month) {
        weakSef.month = month;
        [weakSef doRequestLivingcourse];
    };
    self.monthSelectView.YearSelectBlock = ^(NSString *year) {
        [weakSef showYearTableview:YES];
    };
    [self.scrollView addSubview:self.monthSelectView];
    
    // 视频筛选
    self.screenBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight)];
    self.screenBackView.backgroundColor = [UIColor colorWithWhite:.4 alpha:.1];
    [self.view addSubview:self.screenBackView];
    UITapGestureRecognizer * tip = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideScreen)];
    [self.screenBackView addGestureRecognizer:tip];
    
    self.screenTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 75 , kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kTabBarHeight) style:UITableViewStylePlain];
    self.screenTableView.delegate = self;
    self.screenTableView.dataSource = self;
    self.screenTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.screenTableView.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubview:self.screenTableView];
    
    self.sectionScreentableview = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth / 2, kSegmentHeight - 1, kScreenWidth / 2 , 80) style:UITableViewStylePlain];
    self.sectionScreentableview.delegate = self;
    self.sectionScreentableview.dataSource = self;
    self.sectionScreentableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.sectionScreentableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.sectionScreentableview];
    
    [self.screenBackView setHidden:YES];
    [self.sectionScreentableview setHidden:YES];
    
    // 直播课筛选
    self.livingBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 41, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight - kSegmentHeight + 1)];
    self.livingBackView.backgroundColor = [UIColor colorWithWhite:.4 alpha:.1];
    [self.view addSubview:self.livingBackView];
    UITapGestureRecognizer * livingTip = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideLiving)];
    [self.livingBackView addGestureRecognizer:livingTip];
    
    self.teacherTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth / 2, kSegmentHeight - 1, kScreenWidth / 2 , 100) style:UITableViewStylePlain];
    self.teacherTableView.delegate = self;
    self.teacherTableView.dataSource = self;
    self.teacherTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.teacherTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.teacherTableView];
    
    self.monthTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kSegmentHeight - 1, kScreenWidth / 2 , 80) style:UITableViewStylePlain];
    self.monthTableView.delegate = self;
    self.monthTableView.dataSource = self;
    self.monthTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.monthTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.monthTableView];
    [self.teacherTableView setHidden:YES];
    [self.monthTableView setHidden:YES];
    [self.livingBackView setHidden:YES];
    
    self.yearListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kSegmentHeight + 35, 50, 70) style:UITableViewStylePlain];
    self.yearListTableView.delegate = self;
    self.yearListTableView.dataSource = self;
    [self.yearListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"yearCellId"];
    [self.view addSubview:self.yearListTableView];
    self.yearListTableView.hidden = YES;
}

#pragma mark = 登录头部视图
- (UIView *)getTableHeadView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    headView.backgroundColor = kBackgroundGrayColor;
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, kScreenWidth, 15)];
    titleLabel.text = @"立即登录，查看课程";
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
    if ([tableView isEqual:self.livingTableview]) {
        if (self.monthIndexPath.row == 1) {
            return 1;
        }
        return self.livingCourseArr.count;
    }
    if ([self.videoTableview isEqual:tableView]) {
//        return  self.categoryArray.count;
        return 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.yearListTableView]) {
        return [[[UserManager sharedManager] getLivingBackYearList] count];
    }
    if ([tableView isEqual:self.screenTableView]) {
        return self.categoryArray.count + 1;
    }
    if ([tableView isEqual:self.sectionScreentableview]) {
        return self.sectionArray.count;
    }
    if ([tableView isEqual:self.videoTableview]) {
        if (self.currentVideoIndexpath.row == 0) {
            return 0;
        }
        return [[[self.categoryArray objectAtIndex:self.currentVideoIndexpath.row - 1] objectForKey:kCourseCategoryCourseInfos] count];
    }
    if ([tableView isEqual:self.teacherTableView]) {
        return self.teacherArr.count + 1;
    }
    if ([tableView isEqual:self.monthTableView]) {
        return 2;
    }
    if ([tableView isEqual:self.livingTableview]) {
        NSArray * array = self.livingCourseArr[section];
        
        if (self.monthIndexPath.row == 1) {
            // 往期回放，不显示本月课程
            
            return [[self getLivingCourseArrWithTeacher] count];
            
        }else
        {
            if (section == 0) {
                if (array.count > 0) {
                    return 1;
                }
                return 0;
            }
        }
        
        return array.count;
    }
    return [self.dataSourceArr count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.videoTableview]) {
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.videoTableview.hd_width - 10, 32)];
        headerView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        
        UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, headerView.hd_width - 75, 32)];
        titleLB.textColor = [UIColor blackColor];
        titleLB.font = [UIFont boldSystemFontOfSize:14];
        NSDictionary * infoDic = [NSDictionary dictionary];
        if (self.currentVideoIndexpath.row == 0) {
            infoDic = [self.packageArray objectAtIndex:0];
        }else
        {
            infoDic = [self.categoryArray objectAtIndex:self.currentVideoIndexpath.row - 1];
        }
        
        titleLB.text = [infoDic objectForKey:kCourseCategoryName];
        [headerView addSubview:titleLB];
        
        if ([[[self.categoryArray objectAtIndex:section] objectForKey:kCourseCategoryCourseInfos] count] > 1) {
            UIButton * allVideobtn = [UIButton buttonWithType:UIButtonTypeCustom];
            allVideobtn.frame = CGRectMake(self.videoTableview.hd_width - 90, 0, 80, 32);
            [allVideobtn setTitle:@"全部" forState:UIControlStateNormal];
            [allVideobtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            allVideobtn.titleLabel.font = kMainFont;
            [allVideobtn setImage:[[UIImage imageNamed:@"trankle"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            allVideobtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
            allVideobtn.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
//            [headerView addSubview:allVideobtn];
            [allVideobtn addTarget:self action:@selector(changeCOurseSectionVideo:) forControlEvents:UIControlEventTouchUpInside];
            allVideobtn.tag = 1000 + section;
        }
        
        return headerView;
    }
    
    if ([tableView isEqual:self.livingTableview]) {
        if (self.monthIndexPath.row == 1) {
            return nil;
        }
        if (section == 0) {
            return nil;
        }
        UIView * sectionHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 28)];
        sectionHeadView.backgroundColor = UIRGBColor(230, 230, 230);
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 28)];
        titleLabel.textColor = kCommonMainTextColor_50;
        titleLabel.font = kMainFont;
        titleLabel.textAlignment = 1;
        titleLabel.textColor = UIRGBColor(255, 102, 0);
        [sectionHeadView addSubview:titleLabel];

        titleLabel.text = @"已结束";
        
        if (section == 1) {
            
            titleLabel.text = @"未开始";
            
//            BOOL currentDay = [NSString judgeCurrentDay:[infoDic objectForKey:kLivingTime]];
//            if (currentDay) {
//                titleLabel.textAlignment = 1;
//                titleLabel.text = @"今日直播";
//                titleLabel.textColor = UIRGBColor(255, 102, 0);
//                UIImageView * stateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(titleLabel.hd_centerX - 30 - 15, 6, 13, 17)];
//                stateImageView.image = [UIImage imageNamed:@"livingHeadSectionImage"];
//                [sectionHeadView addSubview:stateImageView];
//            }
            
        }
        
        return sectionHeadView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if ([tableView isEqual:self.screenTableView]) {
        UITableViewCell * cell = [UIUtility getCellWithCellName:@"cellID" inTableView:tableView andCellClass:[UITableViewCell class]];
        cell.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [cell removeAllSubviews];
        
        if (![cell viewWithTag:1000]) {
            UIView * lineVlew = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth / 2, 1)];
            lineVlew.backgroundColor = [UIColor whiteColor];
            lineVlew.tag = 1000;
            [cell addSubview:lineVlew];
        }
        
        UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(5, 1, 65, 49)];
        titleLB.font = [UIFont systemFontOfSize:12];
        titleLB.textAlignment = 1;
        [cell addSubview:titleLB];
        
        
        if (indexPath.row == 0) {
            titleLB.text = @"套餐";
        }else
        {
            NSDictionary *categoryDic = [self.categoryArray objectAtIndex:indexPath.row - 1];
            titleLB.text = [categoryDic objectForKey:kCourseCategoryName];
            
            if ([indexPath isEqual:self.currentVideoIndexpath]) {
                titleLB.textColor = UIColorFromRGB(0xff750d);
            }else
            {
                titleLB.textColor = kMainTextColor;
            }
        }
        
        return cell;
    }else if ([tableView isEqual:self.teacherTableView]) {
        UITableViewCell * cell = [UIUtility getCellWithCellName:@"cellID" inTableView:tableView andCellClass:[UITableViewCell class]];
        cell.backgroundColor = [UIColor whiteColor];
        
        if (![cell viewWithTag:1000]) {
            UIView * lineVlew = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth / 2, 1)];
            lineVlew.backgroundColor = kTableViewCellSeparatorColor;
            lineVlew.tag = 1000;
            [cell addSubview:lineVlew];
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"全部老师";
        }else
        {
            NSDictionary *categoryDic = [self.teacherArr objectAtIndex:indexPath.row - 1];
            cell.textLabel.text = [categoryDic objectForKey:kCourseTeacherName];
        }
        
        
        if ([indexPath isEqual:self.teacherIndexpath]) {
            cell.textLabel.textColor = UIColorFromRGB(0x1D7AF8);
        }else
        {
            cell.textLabel.textColor = kMainTextColor;
        }
        cell.textLabel.textAlignment = 1;
        return cell;
    }else if ([tableView isEqual:self.monthTableView]) {
        UITableViewCell * cell = [UIUtility getCellWithCellName:@"cellID" inTableView:tableView andCellClass:[UITableViewCell class]];
        cell.backgroundColor = [UIColor whiteColor];
        
        if (![cell viewWithTag:1000]) {
            UIView * lineVlew = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth / 2, 1)];
            lineVlew.backgroundColor = kTableViewCellSeparatorColor;
            lineVlew.tag = 1000;
            [cell addSubview:lineVlew];
        }
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"本月直播";
                break;
            case 1:
                cell.textLabel.text = @"往期回放";
                break;
                
            default:
                break;
        }
        
        
        if ([indexPath isEqual:self.monthIndexPath]) {
            cell.textLabel.textColor = UIColorFromRGB(0x1D7AF8);
        }else
        {
            cell.textLabel.textColor = kMainTextColor;
        }
        cell.textLabel.textAlignment = 1;
        return cell;
    }
    
    else if ([tableView isEqual:self.sectionScreentableview]) {
        UITableViewCell * cell = [UIUtility getCellWithCellName:@"cellID" inTableView:tableView andCellClass:[UITableViewCell class]];
        cell.backgroundColor = [UIColor whiteColor];
        
        if (![cell viewWithTag:2000]) {
            UIView * lineVlew = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth / 2, 1)];
            lineVlew.backgroundColor = kTableViewCellSeparatorColor;
            lineVlew.tag = 2000;
            [cell addSubview:lineVlew];
        }
        
        NSDictionary *categoryDic = [self.sectionArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [categoryDic objectForKey:kCourseSecondName];
        
        if ([indexPath isEqual:self.currentSectionIndexpath]) {
            cell.textLabel.textColor = UIColorFromRGB(0xff750d);
        }else
        {
            cell.textLabel.textColor = kMainTextColor;
        }
        cell.textLabel.textAlignment = 1;
        cell.textLabel.font = kMainFont;
        return cell;
    }
    else if ([tableView isEqual:self.videoTableview]) {
        CourseSectionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCourseSectionCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSMutableDictionary * infoDic = [NSMutableDictionary dictionary];
        if (self.currentVideoIndexpath.row == 0) {
            infoDic = [self.packageArray objectAtIndex:0];
        }else
        {
            infoDic = [self.categoryArray objectAtIndex:self.currentVideoIndexpath.row - 1];
        }
        
        NSArray * sectionArr = [infoDic objectForKey:kCourseCategoryCourseInfos];
        NSMutableDictionary * sectionInfoDic = [sectionArr objectAtIndex:indexPath.row];
        [sectionInfoDic setObject:[infoDic objectForKey:kCourseCategoryName] forKey:kCourseCategoryName];
        [cell resetWithInfoDic:sectionInfoDic];
        
        cell.FoldBlock = ^(NSMutableDictionary *infoDic) {
            [weakSelf.videoTableview reloadData];
//            [weakSelf.videoTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
        };
        return cell;
    }else if ([tableView isEqual:self.yearListTableView])
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"yearCellId" forIndexPath:indexPath];
        [cell.contentView removeAllSubviews];
        UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.yearListTableView.hd_width, 35)];
        titleLB.textColor = UIColorFromRGB(0x333333);
        titleLB.font = kMainFont;
        titleLB.textAlignment = NSTextAlignmentCenter;
        NSDictionary * infoDic = [[[UserManager sharedManager] getLivingBackYearList] objectAtIndex:indexPath.row];
        titleLB.text = [infoDic objectForKey:@"yearStr"];
        [cell.contentView addSubview:titleLB];
        return cell;
    }
    else
    {
        if (self.monthIndexPath.row == 1) {
            static NSString *courseCellName = @"liveCourseCell";
            MainLivingCourseTableViewCell * lCell = (MainLivingCourseTableViewCell *)[self getCellWithCellName:courseCellName inTableView:tableView andCellClass:[MainLivingCourseTableViewCell class]];
            [lCell resetCellContent:[[self getLivingCourseArrWithTeacher] objectAtIndex:indexPath.row]];
            
            __weak typeof(self)weakSelf = self;
            lCell.mainCountDownFinishBlock = ^{
                [weakSelf doRequestLivingcourse];
            };
            
            return lCell;
        }
        
        __weak typeof(self)weakSelf = self;
        if (indexPath.section == 0) {
            LivingCourseTableViewCell * livingCell = [tableView dequeueReusableCellWithIdentifier:kLivingCourseCellId forIndexPath:indexPath];
            
            livingCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [livingCell resetInfoWithArray:[self getLivingCourseArrWithTeacher]];
            
            livingCell.LivingCourseBlock = ^(NSDictionary *infoDic) {
                
                // 直播课程信息
                weakSelf.selectCourseInfoDic = infoDic;
                weakSelf.selectCurrentMonthCourseId = [[infoDic objectForKey:kCourseID] intValue];
                [SVProgressHUD show];
                NSDictionary * infoDic1 = @{kCourseID:[infoDic objectForKey:kCourseID],
                                            kteacherId:@"",
                                            @"month":@(0)};
                
                [[CourseraManager sharedManager]didrequestLivingSectionDetailWithInfo:infoDic1 andNotifiedObject:self];
//                if ([[UserManager sharedManager] isUserLogin]){
//                    
//                }else
//                {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLoginClick object:nil];
//                }
            };
            
            return livingCell;
        }
        ClassroomLivingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kClassroomLivingcellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary * dic = [[self.livingCourseArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if (indexPath.row <= [[self.livingCourseArr objectAtIndex:indexPath.section] count] - 1) {
            [cell resetWithDic:dic];
        }
        
        cell.countDownFinishBlock = ^{
            NSDictionary * dic = @{kCourseID:@(0),
                                        kteacherId:self.teacherId,
                                        @"month":@(self.month)};
            [[CourseraManager sharedManager] didrequestLivingSectionDetailWithInfo:dic andNotifiedObject:self];
        };
        
        cell.LivingPlayBlock = ^(LivingPlayType playType) {
            
            switch (playType) {
                case LivingPlayType_living:
                case LivingPlayType_videoBack:
                {
                    self.selectCurrentMonthCourseId = [[dic objectForKey:kCourseID] intValue];
                    self.selectCurrentMonthCourseSectionInfoDic = dic;
                    [SVProgressHUD show];
                    NSDictionary * dic1 = @{kCourseID:[dic objectForKey:kCourseID],
                                            kteacherId:@"",
                                            @"month":@(0)};
                    [[CourseraManager sharedManager] didrequestLivingSectionDetailWithInfo:dic1 andNotifiedObject:self];
                    
                    /*
                     NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
                     
                     [infoDic setObject:[dic objectForKey:kCourseSecondID] forKey:kCourseID];
                     [infoDic setObject:[dic objectForKey:kCourseSecondName] forKey:kCourseName];
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLivingChatClick object:infoDic];
                     */
                    
                }
                    break;
                case LivingPlayType_order:
                {
                    
                    if (![[UserManager sharedManager] isUserLogin]){
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLoginClick object:nil];
                        return ;
                    }
                    [SVProgressHUD show];
                    
                    weakSelf.selectOrderLivingSectionInfoDic = dic;
                    NSDictionary * orderDic = @{@"courseID":[dic objectForKey:kCourseID],
                                                @"courseSecondID":[dic objectForKey:kCourseSecondID],
                                                @"livingTime":[[[dic objectForKey:kLivingTime] componentsSeparatedByString:@"~"] objectAtIndex:0]};
                    [[UserManager sharedManager] didRequestOrderLivingCourseOperationWithCourseInfo:orderDic withNotifiedObject:self];
                    
                }
                    break;
                case LivingPlayType_ordered:
                {
                    
                    if (![[UserManager sharedManager] isUserLogin]){
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLoginClick object:nil];
                        return ;
                    }
                    [SVProgressHUD show];
                    
                    weakSelf.selectOrderLivingSectionInfoDic = dic;
                    NSDictionary * orderDic = @{@"courseID":[dic objectForKey:kCourseID],
                                                @"courseSecondID":[dic objectForKey:kCourseSecondID],
                                                @"livingTime":[[[dic objectForKey:kLivingTime] componentsSeparatedByString:@"~"] objectAtIndex:0]};
                    [[UserManager sharedManager] didRequestCancelOrderLivingCourseOperationWithCourseInfo:orderDic withNotifiedObject:self];
                    
                }
                    break;
                    
                default:
                    break;
            }
        };
        
//        if ((indexPath.row < 3 && [[dic objectForKey:kLivingState] intValue] != 3) ||  [[dic objectForKey:kLivingState] intValue] == 3) {
//            cell.livingStateImageView.hidden = NO;
//            cell.timeLB.hidden = NO;
//        }else
//        {
//            cell.livingStateImageView.hidden = YES;
//            cell.timeLB.hidden = YES;
//        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [tableView isEqual:self.sectionScreentableview] || [tableView isEqual:self.teacherTableView] || [tableView isEqual:self.monthTableView]) {
        return 40;
    }
    if ([tableView isEqual:self.yearListTableView]) {
        return 35;
    }
    
    if ([tableView isEqual:self.screenTableView]) {
        return 50;
    }
    
    if ([tableView isEqual:self.livingTableview] && indexPath.section == 0 && self.monthIndexPath.row == 0) {
        return kScreenWidth / 4 + 20 + 25 + 38;
    }
    if ([tableView isEqual:self.livingTableview] && indexPath.section != 0 && self.monthIndexPath.row == 0) {
        NSDictionary * dic = [self.livingCourseArr[indexPath.section] objectAtIndex:indexPath.row];
        if ([[dic objectForKey:kLivingState] intValue] == 2 || [[dic objectForKey:kLivingState] intValue] == 3) {
            return 81;
        }
        return 110;
    }
    if ([tableView isEqual:self.videoTableview]) {
        
        if (self.currentVideoIndexpath.row == 0) {
            return 0;
        }
        
        NSDictionary * infoDic = [self.categoryArray objectAtIndex:self.currentVideoIndexpath.row - 1];
        NSArray * sectionArr = [infoDic objectForKey:kCourseCategoryCourseInfos];
        NSDictionary * sectionInfoDic = [sectionArr objectAtIndex:indexPath.row];
        NSArray * array = [sectionInfoDic objectForKey:kCourseCategorySecondCourseInfos];
        
        int courseCount = array.count;
        int number = 0;
        if (courseCount%2 == 0) {
            number = courseCount/2;
        }else{
            number = courseCount/2 + 1;
        }
        
        return [CourseSectionTableViewCell getCellHeightWith:sectionInfoDic andIsFold:YES];
        
        return 30 + number * kCellHeightOfCourseOfVideo;
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.videoTableview]) {
        return 0;
    }
    if ([tableView isEqual:self.livingTableview]) {
        if (self.monthIndexPath.row == 1) {
            return 0;
        }
        if (section == 0) {
            return 0;
        }
        return 28;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.screenTableView]) {
        self.currentVideoIndexpath = indexPath;
        self.currentSectionIndexpath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self reloadVideo:indexPath];
//        [self hideScreenWithHide:NO];
//        [self.videoTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        return;
    }
    if ([tableView isEqual:self.yearListTableView]) {
        NSDictionary * infoDic = [[[UserManager sharedManager] getLivingBackYearList] objectAtIndex:indexPath.row];
        NSString * text = [infoDic objectForKey:@"yearStr"];
        [self.monthSelectView setyearTitle:text];
        [self showYearTableview:NO];
        
        self.yearStr = text;
        [self doRequestLivingcourse];
        return;
    }
    
    if ([tableView isEqual:self.sectionScreentableview]) {
        
        self.currentSectionIndexpath = [NSIndexPath indexPathForRow:indexPath.row inSection:self.currentSectionIndexpath.section];
        self.currentVideoIndexpath = [NSIndexPath indexPathForRow:self.currentSectionIndexpath.section inSection:0];
        [self reloadSection:indexPath];
        [self hideScreenWithHide:YES];
        [self.videoTableview scrollToRowAtIndexPath:self.currentSectionIndexpath atScrollPosition:UITableViewScrollPositionNone animated:NO];
        return;
    }
    if ([tableView isEqual:self.teacherTableView]) {
        self.teacherIndexpath = indexPath;
        if (indexPath.row == 0) {
            self.teacherId = @"";
        }else
        {
            self.teacherId = [[self.teacherArr objectAtIndex:indexPath.row - 1] objectForKey:kteacherId];
        }
        if (self.monthIndexPath.row == 0) {
            [self doRequestLivingcourse];
        }else
        {
            [self.teacherTableView reloadData];
            [self.livingTableview reloadData];
            [self refreshlivingSegment];
        }
        [self hideLivingWithHide:NO];
        return;
    }
    
    if ([tableView isEqual:self.monthTableView]) {
        self.monthIndexPath = indexPath;
        if (indexPath.row == 0) {
            self.month = [NSString getCurrentMonth];
            [self doRequestLivingcourse];
        }else
        {
            self.month = 0;
            self.monthSelectView.selectIndexpath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self doRequestLivingcourse];
            [self reloadLivingTableViewData];
            [self refreshlivingSegment];
        }
        [self hideLivingWithHide:NO];
        return;
    }
    
    if ([tableView isEqual:self.livingTableview]) {
        
        /*
         if (![[UserManager sharedManager] isUserLogin]){
         [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLoginClick object:nil];
         return ;
         }
         */
        
        if (self.monthIndexPath.row == 1) {
            
            NSDictionary * dic = [[self getLivingCourseArrWithTeacher] objectAtIndex:indexPath.row];
            self.selectCourseInfoDic = dic;
            self.selectCurrentMonthCourseId = [[dic objectForKey:kCourseID] intValue];
            [SVProgressHUD show];
            NSDictionary * dic1 = @{kCourseID:[dic objectForKey:kCourseID],
                                   kteacherId:@"",
                                   @"month":@(0)};
            [[CourseraManager sharedManager] didrequestLivingSectionDetailWithInfo:dic1 andNotifiedObject:self];
            
            return;
        }
        
        NSDictionary * dic = [[self.livingCourseArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        self.selectCurrentMonthCourseId = [[dic objectForKey:kCourseID] intValue];
        self.selectCurrentMonthCourseSectionInfoDic = dic;
        [SVProgressHUD show];
        NSDictionary * dic1 = @{kCourseID:[dic objectForKey:kCourseID],
                                kteacherId:@"",
                                @"month":@(0)};
        [[CourseraManager sharedManager] didrequestLivingSectionDetailWithInfo:dic1 andNotifiedObject:self];
        
        /*
         LivingPlayType playType = [[dic objectForKey:kLivingState] integerValue];
         switch (playType) {
         case LivingPlayType_ordered:
         case LivingPlayType_living:
         {
         
         NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
         
         [infoDic setObject:[dic objectForKey:kCourseSecondID] forKey:kCourseID];
         [infoDic setObject:[dic objectForKey:kCourseSecondName] forKey:kCourseName];
         
         [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLivingChatClick object:infoDic];
         
         
         
         }
         break;
         case LivingPlayType_order:
         {
         [SVProgressHUD show];
         
         self.selectOrderLivingSectionInfoDic = dic;
         NSDictionary * orderDic = @{@"courseID":[dic objectForKey:kCourseID],
         @"courseSecondID":[dic objectForKey:kCourseSecondID],
         @"livingTime":[[[dic objectForKey:kLivingTime] componentsSeparatedByString:@"~"] objectAtIndex:0]};
         [[UserManager sharedManager] didRequestOrderLivingCourseOperationWithCourseInfo:orderDic withNotifiedObject:self];
         
         }
         break;
         case LivingPlayType_videoBack:
         {
         [self playBackWith:dic];
         }
         break;
         
         default:
         break;
         }
         */
        
        /*
         //        self.orderCourseId = [[info objectForKey:kCourseID] intValue];
         //        if ([[info objectForKey:kLivingState] intValue] != 5) {
         //
         //            if ([[UserManager sharedManager] isUserLogin]){
         //
         //                [SVProgressHUD show];
         //                self.selectCourseInfoDic = info;
         //
         //                NSDictionary * infoDic = @{kCourseID:[info objectForKey:kCourseID],
         //                                           kteacherId:@"",
         //                                           @"month":@(0)};
         //
         //                [[CourseraManager sharedManager]didrequestLivingSectionDetailWithInfo:infoDic andNotifiedObject:self];
         //
         //
         //            }else
         //            {
         //                 [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLoginClick object:nil];
         //            }
         //            return;
         //        }
         
         */
        
        return;
    }
//    NSDictionary *info = [self.dataSourceArr objectAtIndex:indexPath.row];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfCourseClick object:info];
}
#pragma mark - utility
- (UITableViewCell *)getCellWithCellName:(NSString *)reuseName inTableView:(UITableView *)table andCellClass:(Class)cellClass
{
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:reuseName];
    if (cell == nil) {
        cell = [[cellClass alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)reloadLivingTableViewData
{
    if (self.monthIndexPath.row == 1) {
        self.livingTableview.frame = CGRectMake(kScreenWidth, kSegmentHeight + 35, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kTabBarHeight - kSegmentHeight - 35);
        self.monthSelectView.hidden = NO;
        
        [self.monthSelectView reloadData];
    }else
    {
        self.livingTableview.frame = CGRectMake(kScreenWidth, kSegmentHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kTabBarHeight - kSegmentHeight);
        self.monthSelectView.hidden = YES;
    }
    [self.livingTableview reloadData];
}

#pragma mark - alertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == OrderAlerttag) {
        if (buttonIndex == 1) {
            [SVProgressHUD showWithStatus:@"预约中"];
//            [[UserManager sharedManager] didRequestOrderLivingCourseOperationWithCourseId:self.orderCourseId withNotifiedObject:self];
        }
    }
}

#pragma mark - segmentAction
- (void)changeSlect:(UISegmentedControl *)segment
{
    self.topIndex = segment.selectedSegmentIndex;
    [self.scrollView setContentOffset:CGPointMake(segment.selectedSegmentIndex * _scrollView.hd_width, 0) animated:NO];
    
    if (self.topIndex == 0) {
        [self hideLivingWithHide:YES];
        [self.videoTableview reloadData];
    }else
    {
        [self hideScreenWithHide:YES];
        
        [self reloadLivingTableViewData];
    }
}

#pragma mark - HYSegmentedControl 代理方法
- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    if (self.topIndex == 0) {
        self.videoIndex = index;
        [self reloadLivingTableViewData];
        [self.videoTableview reloadData];
        
    }else
    {
        self.livingIndex = index;
        
        if (index == 1) {
            
            if (self.teacherTableView.hidden) {
                
                [self showTeacherTableview:YES];
            }else
            {
                [self showTeacherTableview:NO];
            }
        }else
        {
            if (self.monthTableView.hidden) {
                
                [self showMonthTableview:YES];
            }else
            {
                [self showMonthTableview:NO];
            }
        }
        
        [self reloadLivingTableViewData];
    }
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

- (void)showSecondLeveltableview:(BOOL)isShow andY:(CGFloat)y
{
    
    if (isShow) {
        [self.screenBackView setHidden:NO];
        [self.sectionScreentableview setHidden:NO];
        self.sectionScreentableview.frame = CGRectMake(kScreenWidth / 2 , y, kScreenWidth / 2 , 0);
        
        [UIView animateWithDuration:kTime animations:^{
            self.sectionScreentableview.frame = CGRectMake(kScreenWidth / 2 , y, kScreenWidth / 2 , self.sectionScreentableviewHeight);
        } completion:^(BOOL finished) {
            
        }];
    }else
    {
        [self.screenBackView setHidden:NO];
        self.sectionScreentableview.frame = CGRectMake(kScreenWidth / 2 , y, kScreenWidth / 2 , self.sectionScreentableviewHeight);
        [UIView animateWithDuration:kTime animations:^{
            self.sectionScreentableview.frame = CGRectMake(kScreenWidth / 2 , y, kScreenWidth / 2 , 0);
        } completion:^(BOOL finished) {
            [self.sectionScreentableview setHidden:YES];
            [self.screenBackView setHidden:YES];
        }];
    }
}

- (void)showTeacherTableview:(BOOL)isShow
{
    [self.monthTableView setHidden:YES];
    [self.yearListTableView setHidden:YES];
    if (isShow) {
        [self.livingBackView setHidden:NO];
        [self.teacherTableView setHidden:NO];
        self.teacherTableView.frame = CGRectMake(kScreenWidth / 2, kSegmentHeight - 1, kScreenWidth / 2 , 0);
        
        [UIView animateWithDuration:kTime animations:^{
            self.teacherTableView.frame = CGRectMake(kScreenWidth / 2, kSegmentHeight - 1, kScreenWidth / 2 , self.teachertableviewheight);
        } completion:^(BOOL finished) {
            
        }];
        
    }else
    {
        [self.livingBackView setHidden:NO];
        self.teacherTableView.frame = CGRectMake(kScreenWidth / 2, kSegmentHeight - 1, kScreenWidth /2 , self.teachertableviewheight);
        
        [UIView animateWithDuration:kTime animations:^{
            self.teacherTableView.frame = CGRectMake(kScreenWidth / 2, kSegmentHeight - 1, kScreenWidth / 2 , 0);
        } completion:^(BOOL finished) {
            [self.teacherTableView setHidden:YES];
            [self.livingBackView setHidden:YES];
        }];
    }
}

- (void)showYearTableview:(BOOL)isShow
{
    if (isShow) {
        [self.livingBackView setHidden:NO];
        [self.yearListTableView setHidden:NO];
        self.yearListTableView.frame = CGRectMake(0, kSegmentHeight + 35, kScreenWidth, 0);
        
        [UIView animateWithDuration:kTime animations:^{
            self.yearListTableView.frame = CGRectMake(0, kSegmentHeight + 35, kScreenWidth, 2 * 35);
        } completion:^(BOOL finished) {
            
        }];
        
    }else
    {
        [self.livingBackView setHidden:NO];
        self.yearListTableView.frame = CGRectMake(0, kSegmentHeight + 35, kScreenWidth, 2 * 35);
        
        [UIView animateWithDuration:kTime animations:^{
            self.yearListTableView.frame = CGRectMake(0, kSegmentHeight + 35, kScreenWidth, 0);
        } completion:^(BOOL finished) {
            [self.yearListTableView setHidden:YES];
            [self.livingBackView setHidden:YES];
        }];
    }
}

- (void)showMonthTableview:(BOOL)isShow
{
    [self.teacherTableView setHidden:YES];
    [self.yearListTableView setHidden:YES];
    if (isShow) {
        [self.livingBackView setHidden:NO];
        [self.monthTableView setHidden:NO];
        self.monthTableView.frame = CGRectMake(0 , 41, kScreenWidth / 2 , 0);
        
        [UIView animateWithDuration:kTime animations:^{
            self.monthTableView.frame = CGRectMake(0 , 41, kScreenWidth / 2 , 80);
        } completion:^(BOOL finished) {
            
        }];
    }else
    {
        [self.livingBackView setHidden:NO];
        self.monthTableView.frame = CGRectMake(0 , 41, kScreenWidth / 2 , 80);
        [UIView animateWithDuration:kTime animations:^{
            self.monthTableView.frame = CGRectMake(0 , 41, kScreenWidth / 2 , 0);
        } completion:^(BOOL finished) {
            [self.monthTableView setHidden:YES];
            [self.livingBackView setHidden:YES];
        }];
    }
}

- (void)hideScreen
{
    [self hideScreenWithHide:YES];
}

- (void)hideScreenWithHide:(BOOL)isHide
{
    if (isHide) {
//        self.screenTableView.hidden = YES;
        self.sectionScreentableview.hidden = YES;
        self.screenBackView.hidden = YES;
        return;
    }
    if (self.screenTableView.hidden && self.sectionScreentableview.hidden) {
        return;
    }
    [self.segmentC clickBT:self.videoIndex];
}

- (void)hideLiving
{
    [self hideLivingWithHide:YES];
}

- (void)hideLivingWithHide:(BOOL)isHide
{
    if (isHide) {
        self.yearListTableView.hidden = YES;
        self.teacherTableView.hidden = YES;
        self.monthTableView.hidden = YES;
        self.livingBackView.hidden = YES;
        return;
    }
    if (self.teacherTableView.hidden && self.monthTableView.hidden && self.yearListTableView.hidden) {
        return;
    }
    [self.livingSegmentC clickBT:self.livingIndex];
}

- (void)changeCOurseSectionVideo:(UIButton *)button
{
    if (self.sectionScreentableview.hidden) {
        [self hideScreen];
    }
    
    NSInteger section = button.tag - 1000;
    self.currentSectionIndexpath = [NSIndexPath indexPathForRow:0 inSection:section];
    self.sectionArray = [[self.categoryArray objectAtIndex:section] objectForKey:kCourseCategoryCourseInfos];
    [self refreshSectiontableViewFrame];
    
    CGRect rect = [self.videoTableview rectForHeaderInSection:section];
    
    CGFloat y = 0.0;
    if (self.currentVideoIndexpath.row == section) {
        y = 32;
    }else
    {
         y = rect.origin.y - self.videoTableview.contentOffset.y + 32;
    }
    
    [self showSecondLeveltableview:YES andY:y];
    [self.sectionScreentableview reloadData];
}

#pragma mark 观看视频回放
- (void)playBackWith:(NSDictionary *)infoDic
{
    if ([[infoDic objectForKey:kHaveJurisdiction] intValue]) {
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - allPackage delegate
- (void)didReuquestPackageSuccessed
{
    self.packageArray = [[CourseraManager sharedManager] getAllPackageList];
    [self.screenTableView reloadData];
    [self.videoTableview reloadData];
    [self.sectionScreentableview reloadData];
}

- (void)didReuquestPackageFailed:(NSString *)failedInfo
{
    
}

#pragma mark - all course category delegate
- (void)didRequestAllCourseCategorySuccessed
{
    [SVProgressHUD dismiss];
    self.categoryArray = [[CourseraManager sharedManager] getAllCategoryArray];
    [self getAllDataSourseArray];
    [self.videoTableview.mj_header endRefreshing];
    
    
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
    self.teacherArr = [[CourseraManager sharedManager] getLivingTeacherInfoArrar];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.teacherTableView.frame = CGRectMake(kScreenWidth / 2, kSegmentHeight - 1, kScreenWidth / 2 , (self.teacherArr.count + 1) * 40.0) ;
        self.teachertableviewheight = (self.teacherArr.count + 1) * 40.0;
    });
    [self.teacherTableView reloadData];
    
    if (self.monthIndexPath.row == 0) {
        NSDictionary * dic = @{kCourseID:@(0),
                               kteacherId:self.teacherId,
                               @"month":@(self.month)};
        [[CourseraManager sharedManager] didrequestLivingSectionDetailWithInfo:dic andNotifiedObject:self];
    }else
    {
        self.livingCourseArr = [[CourseraManager sharedManager] getNotStartLivingCourseArray];
        [SVProgressHUD dismiss];
        [self.livingTableview.mj_header endRefreshing];
        [self reloadLivingTableViewData];
    }
}

- (void)didRequestNotStartLivingCourseFailed:(NSString *)failedInfo
{
    [self.livingTableview.mj_header endRefreshing];
    [SVProgressHUD dismiss];
    if ([failedInfo isEqualToString:@"暂无数据"]) {
        failedInfo = @"暂无课程";
    }
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    self.livingCourseArr = [[CourseraManager sharedManager] getNotStartLivingCourseArray];
    [self reloadLivingTableViewData];
    
    if(self.monthIndexPath.row == 0){
        
        NSDictionary * dic = @{kCourseID:@(0),
                               kteacherId:self.teacherId,
                               @"month":@(self.month)};
        [[CourseraManager sharedManager] didrequestLivingSectionDetailWithInfo:dic andNotifiedObject:self];
        return;
    }
}

#pragma mark - LivingSectionDetailProtocal

- (void)didRequestLivingSectionDetailSuccessed
{
    [SVProgressHUD dismiss];
    [self.livingTableview.mj_header endRefreshing];
    [self refreshlivingSegment];
    
    if (self.selectCurrentMonthCourseId) {
//        self.selectCurrentMonthCourseId = 0;
        if (self.selectCurrentMonthCourseSectionInfoDic) {
            
            NSArray * livingSectionList = [[CourseraManager sharedManager] getLivingSectionDetailArray];
//            NSDictionary * currentLivingSectionInfoDic ;
            for (NSDictionary * infoDic in livingSectionList) {
                if ([[self.selectCurrentMonthCourseSectionInfoDic objectForKey:kCourseSecondID] intValue] == [[infoDic objectForKey:kCourseSecondID] intValue]) {
                    self.selectCurrentMonthCourseSectionInfoDic = infoDic;
                }
            }
            
            // 直播课小节信息
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLivingChatClick object:self.selectCurrentMonthCourseSectionInfoDic];
            self.selectCurrentMonthCourseSectionInfoDic = nil;
        }else
        {
            // 直播课程信息
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLivingChatClick object:self.selectCourseInfoDic];
            self.selectCourseInfoDic = nil;
        }
        
        return;
    }else
    {
        self.livingCourseArr = [[CourseraManager sharedManager] getNotStartLivingCourseArray];
        if (self.topIndex == 1) {
        }
        
        [self reloadLivingTableViewData];
    }
}

- (void)didRequestLivingSectionDetailFailed:(NSString *)failedInfo
{
    if ([failedInfo isEqualToString:@"暂无数据"]) {
        failedInfo = @"暂无课程";
    }
    
    [SVProgressHUD dismiss];
    [self.livingTableview.mj_header endRefreshing];
    if (self.selectCurrentMonthCourseId) {
        self.selectCurrentMonthCourseId = 0;
        self.selectCurrentMonthCourseSectionInfoDic = nil;
        [SVProgressHUD showErrorWithStatus:failedInfo];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    self.livingCourseArr = [[CourseraManager sharedManager] getNotStartLivingCourseArray];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    [self reloadLivingTableViewData];
    [self refreshlivingSegment];
}

- (void)refreshlivingSegment
{
    if (self.teacherIndexpath) {
        if (self.teacherIndexpath.row == 0) {
            [self.livingSegmentC changeTitle:@"全部老师" withIndex:1];
        }else
        {
            [self.livingSegmentC changeTitle:[self.teacherArr[self.teacherIndexpath.row - 1] objectForKey:kCourseTeacherName] withIndex:1];
        }
    }
    if (self.monthIndexPath) {
        if (self.monthIndexPath.row == 0) {
            [self.livingSegmentC changeTitle:@"本月直播" withIndex:0];
        }else
        {
            [self.livingSegmentC changeTitle:@"往期回放" withIndex:0];
        }
    }
}

#pragma mark - livingBackYearListDelegate
- (void)didRequestLivingBackYearListSuccessed
{
    
}

- (void)didRequestLivingBackYearListFailed:(NSString *)failedInfo
{
    
}

#pragma mark - orderLivingProtocol

- (void)didRequestOrderLivingSuccessed
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"预约成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    
    [[CourseraManager sharedManager] refreshLivingSectionStateOrder_complateWith:self.selectOrderLivingSectionInfoDic];
    self.livingCourseArr = [[CourseraManager sharedManager] getNotStartLivingCourseArray];
    [self reloadLivingTableViewData];
}

- (void)didRequestOrderLivingFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)orderSuccess
{
    [SVProgressHUD dismiss];
}

- (void)didRequestCancelOrderLivingSuccessed
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"取消预约成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    
    [[CourseraManager sharedManager] refreshLivingSectionStateOrder_complateWith:self.selectOrderLivingSectionInfoDic];
    self.livingCourseArr = [[CourseraManager sharedManager] getNotStartLivingCourseArray];
    [self reloadLivingTableViewData];
}

- (void)didRequestCancelOrderLivingFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - reload

- (void)reloadVideo:(NSIndexPath *)indexPath
{
    
    NSMutableArray * array = [NSMutableArray array];
    
    if (indexPath.row == 0) {
        self.currentCourseInfo = [self.packageArray objectAtIndex:0];
        return;
    }
    self.currentCourseInfo = [self.categoryArray objectAtIndex:indexPath.row - 1];
    
    [self refreshSectiontableViewFrame];
    
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

- (void)reloadSection:(NSIndexPath *)indexPath
{
    NSMutableArray * array = [NSMutableArray array];
    [self refreshSectiontableViewFrame];
    NSDictionary * courseSecondInfo = [self.sectionArray objectAtIndex:indexPath.row];
    
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

- (void)refreshSectiontableViewFrame
{
    self.sectionScreentableviewHeight = (self.sectionArray.count) * 40;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.sectionScreentableview.hd_height = self.sectionScreentableviewHeight;
    });
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.videoTableview]) {
        
        /*
         NSArray * cellsArray = [self.videoTableview visibleCells];
         CourseSectionTableViewCell * cell = [cellsArray firstObject];
         NSIndexPath * indexPath = [self.videoTableview indexPathForCell:cell];
         self.currentVideoIndexpath = [NSIndexPath indexPathForRow:indexPath.section inSection:0];
         [self.screenTableView reloadData];
         */
        
        return;
    }
    if ([scrollView isEqual:self.scrollView]) {
        int i = self.scrollView.contentOffset.x / kScreenWidth;
        switch (i ) {
            case 0:
                self.topSegment.selectedSegmentIndex = 0;
                break;
            case 1:
                self.topSegment.selectedSegmentIndex = 1;
                break;
            default:
                break;
        }
        [self changeSlect:self.topSegment];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:self.videoTableview]) {
        
        /*
         NSArray * cellsArray = [self.videoTableview visibleCells];
         CourseSectionTableViewCell * cell = [cellsArray firstObject];
         NSIndexPath * indexPath = [self.videoTableview indexPathForCell:cell];
         self.currentVideoIndexpath = [NSIndexPath indexPathForRow:indexPath.section inSection:0];
         [self.screenTableView reloadData];
         */
        
        return;
    }
}

- (NSString *)getDate:(NSDictionary *)infoDic
{
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    // 截止时间字符串格式
    NSString * expireDateStr = [infoDic objectForKey:kLivingTime];
    
    expireDateStr = [[expireDateStr componentsSeparatedByString:@"~"] objectAtIndex:0];
    
    // 截止时间data格式
    NSDate *expireDate = [dateFomatter dateFromString:expireDateStr];
    
    dateFomatter.dateFormat = @"MM月dd日";
    
    NSString * nDateStr = [dateFomatter stringFromDate:expireDate];
    
    return nDateStr;
}

- (NSArray *)getLivingCourseArrWithTeacher
{
    NSArray * livingCourseArr = self.livingCourseArr[0];
    NSString * teacherName = @"";
    for (NSDictionary * teacherInfo in self.teacherArr) {
        if ([self.teacherId isEqualToString:[teacherInfo objectForKey:kteacherId]]) {
            teacherName = [teacherInfo objectForKey:kCourseTeacherName];
        }
    }
    
    NSMutableArray * livingCourseArrWithTeacher = [NSMutableArray array];
    
    for (NSDictionary * infoDic in livingCourseArr) {
        if ([teacherName isEqualToString:[infoDic objectForKey:kCourseTeacherName]]) {
            [livingCourseArrWithTeacher addObject:infoDic];
        }
    }
    
    if (self.teacherId.length == 0) {
        return livingCourseArr;
    }
    return livingCourseArrWithTeacher;
}

@end
