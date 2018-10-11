//
//  MainViewController.m
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MainViewController.h"
#import "UIMacro.h"
#import "MainViewMacro.h"
#import "ContentTableViewDataSource.h"
#import "NotificaitonMacro.h"
#import "ImageManager.h"
#import "CourseraManager.h"
#import "AllCourseViewController.h"
#import "CommonMacro.h"
#import "SVProgressHUD.h"
#import "CourseModuleProtocol.h"
#import "ImageModuleProtocol.h"
#import "MJRefresh.h"
#import "MainViewMacro.h"
#import "UserManager.h"
#import "QuestionManager.h"
#import "UIUtility.h"
#import "QuestionMacro.h"
#import "QuestionDetailViewController.h"
#import "SearchViewController.h"
#import "UIImage+Scale.h"
#import "LivingCourseViewController.h"
#import "RCDCustomerServiceViewController.h"
#import "DiscountCouponVIew.h"
#import "DiscountCouponViewController.h"
#import "LivingChatViewController.h"
#import "LivingSectionDetailViewController.h"
//#define SERVICE_ID @"KEFU150105808199853"

#define SERVICE_ID @"KEFU150336412912915"

//#define SERVICE_ID_XIAONENG1 @"kf_4029_1483495902343"
//#define SERVICE_ID_XIAONENG2 @"op_1000_1483495280515"
#define OrderAlerttag 2000

@interface MainViewController ()<UITableViewDelegate,CourseModule_HottestCourseProtocl,ImageModule_BannerProtocol,QuestionModule_QuestionProtocol, CourseModule_NotStartLivingCourse,UIAlertViewDelegate,CourseModule_LivingSectionDetail,CourseModule_LivingSectionDetail,CourseModule_AllCourseProtocol,UserModule_LevelDetailProtocol,UserModule_AcquireDiscountCouponProtocol,TestModule_AllCategoryProtocol,UIWebViewDelegate,UserModule_MyCoin>

@property (nonatomic,strong)    UITableView                     *contentTableView;
@property (nonatomic,strong)    ContentTableViewDataSource      *contentTableSource;

@property (nonatomic,strong)    NSArray                         *categoryArray;
@property (nonatomic,strong)    NSArray                         *mainQuestionArray;
@property (nonatomic, strong)  NSArray                          *notStartLivingArray;

@property (nonatomic, strong) DiscountCouponVIew        *discountCouponView;

@property (nonatomic, assign) BOOL courseVCdidload;
@property (nonatomic, assign) int orderCourseId;

@property (nonatomic, assign)int selectLivingCourseId;// 已选中直播课id

@property (nonatomic, strong)NSDictionary * selectLivingCourseInfoDic;

@end

@implementation MainViewController

#pragma mark - view controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.notStartLivingArray = [NSArray array];
    
    [self tableDataSetup];
    
    [self navigationViewSetup];
    [self contentViewInit];
    
    [self addNotifications];
    
    [self startRequest];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    self.navigationController.navigationBar.barTintColor = UIRGBColor(10, 3, 126);
//}

//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"shouye-状态栏"]];
//}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    UINavigationBar * bar = self.navigationController.navigationBar;
    [bar setShadowImage:[UIImage imageNamed:@"tm"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tm"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    self.navBarBgAlpha = @"1.0";
    CGFloat offset = self.contentTableView.contentOffset.y;
    CGFloat alpha = fabs(offset / 64.0);
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[UIRGBColor(19, 0, 160) colorWithAlphaComponent:alpha]] forBarMetrics:UIBarMetricsDefault];
    [super viewWillAppear:animated];
    
    [[CourseraManager sharedManager]didRequestNotStartLivingCourseWithInfo:@{@"Month":@([NSString getCurrentMonth]),@"year":[NSString stringWithFormat:@"%d", [NSString getCurrentYear]]} NotifiedObject:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setBarTintColor:kCommonNavigationBarColor];
}

- (void)startRequest
{
    [SVProgressHUD show];
    [[ImageManager sharedManager] didRequestBannerImagesWithNotifiedObject:self];
    [[CourseraManager sharedManager] didRequestHottestCoursesWithNotifiedObject:self];
    [[CourseraManager sharedManager] didRequestAllCourseCategoryWithNotifiedObject:self];
    [[QuestionManager sharedManager] didRequestMainPageQuestionRequestWithNotifiedObject:self];
    [[TestManager sharedManager] didRequestTestAllCategoryWithNotifiedObject:self];
    [[CourseraManager sharedManager]didRequestNotStartLivingCourseWithInfo:@{@"Month":@([NSString getCurrentMonth]),@"year":[NSString stringWithFormat:@"%d", [NSString getCurrentYear]]} NotifiedObject:self];
    [[UserManager sharedManager] didRequestAssistantWithInfo:@{} withNotifiedObject:nil];
    [[UserManager sharedManager]didRequestLevelDetailWithNotifiedObject:self];
    
    [[UserManager sharedManager] didRequestMyCoinsWithInfo:@{} withNotifiedObject:self];
    
    if ([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled] && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        [[UserManager sharedManager] didRequestAcquireDiscountCouponWithCourseInfo:@{} withNotifiedObject:self];
    }
}

- (void)allCourseClick
{
    AllCourseViewController *vc = [[AllCourseViewController alloc] init];
    vc.intoType = IntoPageTypeAllCourse;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableDataSetup
{
    self.categoryArray = @[@{kCourseCategoryName:@"会计入门",
                             kCourseCategoryCoverUrl:@"shouye-1.png",
                             kCourseCategoryId:@(52)},
                           @{kCourseCategoryName:@"出纳实操",
                             kCourseCategoryCoverUrl:@"shouye-2.png",
                             kCourseCategoryId:@(62)},
                           @{kCourseCategoryName:@"会计实操",
                             kCourseCategoryCoverUrl:@"shouye-3.png",
                             kCourseCategoryId:@(44)},
                           @{kCourseCategoryName:@"税务",
                             kCourseCategoryCoverUrl:@"shouye-4.png",
                             kCourseCategoryId:@(46)},
                           @{kCourseCategoryName:@"行业实操",
                             kCourseCategoryCoverUrl:@"shouye-5.png",
                             kCourseCategoryId:@(66)},
                           @{kCourseCategoryName:@"岗位实训",
                             kCourseCategoryCoverUrl:@"shouye-6.png",
                             kCourseCategoryId:@(61)},
                           @{kCourseCategoryName:@"财务管理",
                             kCourseCategoryCoverUrl:@"shouye-7.png",
                             kCourseCategoryId:@(47)},
                           @{kCourseCategoryName:@"考证",
                             kCourseCategoryCoverUrl:@"shouye-8.png",
                             kCourseCategoryId:@(40)}];
}

- (void)pushQuestionDetailWithQuestionId:(int)questionId
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    QuestionDetailViewController *detailController = [[QuestionDetailViewController alloc] init];
    detailController.questionId = questionId;
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - notifications
- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseCategoryClick:) name:kNotificationOfCategoryPageCategoryClick object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseVCdidload:) name:kNotificationOfCourseVCdidLoad object:nil];
    
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0;
    if (indexPath.section == 0 && indexPath.row == 0) {
        if(IS_PAD)
        {
            return kScreenWidth * 0.37;
        }
        return  2 * kCellHeightOfCategoryView + 30 + 30;
//        return [UIImage imageGetHeight:[UIImage imageNamed:@"shouye-banner"]] + 2 * kCellHeightOfCategoryView + 30 - 20 + 10;
    }
    if (indexPath.section == 1) {
        cellHeight = 60;
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        cellHeight = kCellHeightOfCourseTitle;
    }
    if (indexPath.section == 2 && indexPath.row != 0) {
        if(IS_PAD)
        {
            cellHeight = 145;
        }else
        {
            cellHeight = 100;
        }
    }
    
    if (indexPath.section == 2 && [CourseraManager sharedManager].showMore && indexPath.row == [[[[CourseraManager sharedManager]getNotStartLivingCourseArray] objectAtIndex:0] count] + 1) {
        return kCellHeightOfCourseTitle;
    }
    
    if(indexPath.section == 2 && ![CourseraManager sharedManager].showMore && indexPath.row == 4){
        return kCellHeightOfCourseTitle;
    }
    
    if (indexPath.section == 3 && (indexPath.row == 0 || indexPath.row == 3)) {
        cellHeight = kCellHeightOfCourseTitle;
    }
    if (indexPath.section == 3 && indexPath.row != 0 && indexPath.row != 3) {
        if (IS_PAD) {
            cellHeight = kCellHeightOfCourse_IPAD + 15;
        }else
        {
            cellHeight = kCellHeightOfCourse + 15;
        }
    }
    
    if (indexPath.section == 4) {
        if (IS_PAD) {
            return 42 + (kCellHeightOfCourse_IPAD + 15) * 2 + 40;
        }else
        {
            return 42 + (kCellHeightOfCourse + 15) * 2 + 40;
        }
    }
    
    if (indexPath.section == 5 && indexPath.row == 0) {
        cellHeight = kCellHeightOfCourseTitle;
    }
    if (indexPath.section == 5 && indexPath.row != 0) {
//        CGFloat height;
//        CGFloat maxHeight = 80;
//        UIFont *font = [UIFont systemFontOfSize:16];
//        CGFloat contentHeight = [UIUtility getHeightWithText:[[self.mainQuestionArray objectAtIndex:indexPath.row-1] objectForKey:kQuestionContent] font:font width:kScreenWidth - 40];
//        if (contentHeight > maxHeight) {
//            height = 80;
//        }else{
//            height = contentHeight;
//        }
//        
//        return 10 + kHeightOfCellHeaderImage + 10 + height + 10 + kheightOfCellSeeLabel + 10;
        
        
        CGFloat height;
        CGFloat maxHeight = 80;
        UIFont *font = kMainFont;
        CGFloat contentHeight = [UIUtility getSpaceLabelHeght:[[self.mainQuestionArray objectAtIndex:indexPath.row-1] objectForKey:kQuestionContent] font:font width:kScreenWidth - 40];
        height = contentHeight;
        if (contentHeight > 80) {
            height = 80;
        }else
        {
            height = contentHeight;
        }
        
        NSDictionary * replyDic = [[[self.mainQuestionArray objectAtIndex:indexPath.row-1] objectForKey:@"replyList"] firstObject];
        
        CGFloat replyHeight = [UIUtility getHeightWithText:[replyDic objectForKey:@"replyCon"] font:font width:kScreenWidth - 30];
        
        CGFloat cellHeight = 10 + kHeightOfCellHeaderImage + 10 + height;
        
        if ([[[self.mainQuestionArray objectAtIndex:indexPath.row-1] objectForKey:kQuestionImgStr] count] > 0) {
            cellHeight += 5 + 60 + 10 + 30 ;
        }else
        {
            cellHeight += 10 + 30;
        }
        
        return cellHeight;
        
    }
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row == 0) {
        
        [self.tabBarController setSelectedIndex:1];
        if (self.courseVCdidload) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMoreLiving object:nil];
        }else
        {
            [self performSelector:@selector(postCourseVC:) withObject:@{@"infoDic":@{},@"nitifiName":kNotificationMoreLiving} afterDelay:1.0];
        }
    }
    
    if (indexPath.section == 2 && indexPath.row != 0 && (([CourseraManager sharedManager].showMore && indexPath.row != [[[[CourseraManager sharedManager]getNotStartLivingCourseArray] objectAtIndex:0] count] + 1) || (![CourseraManager sharedManager].showMore && indexPath.row != 4))) {

        [SVProgressHUD show];
        NSDictionary *infoDic = [[[[CourseraManager sharedManager]getNotStartLivingCourseArray] objectAtIndex:0] objectAtIndex:indexPath.row - 1];
        self.selectLivingCourseInfoDic = infoDic;
        NSDictionary * dic = @{kCourseID:[infoDic objectForKey:kCourseID],
                               kteacherId:@"",
                               @"month":@(0)};
        [[CourseraManager sharedManager] didrequestLivingSectionDetailWithInfo:dic andNotifiedObject:self];
        NSLog(@"点击直播课");
    }
    
    if (indexPath.section == 3 && indexPath.row != 0 && indexPath.row != 3) {
        NSDictionary *info = [[[CourseraManager sharedManager] getHottestCourseArray] objectAtIndex:indexPath.row];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfCourseClick object:info];
    }
    if (indexPath.section == 5 && indexPath.row == 0) {
        [self.tabBarController setSelectedIndex:2];
    }
    if (indexPath.section == 5 && indexPath.row != 0) {
        int questionId = [[[self.contentTableSource.mainQuestionArray objectAtIndex:indexPath.row - 1] objectForKey:kQuestionId] intValue];
        QuestionDetailViewController *detailController = [[QuestionDetailViewController alloc] init];
        detailController.hidesBottomBarWhenPushed = YES;
        detailController.questionId = questionId;
        [self.navigationController pushViewController:detailController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2 || section == 3 || section == 4 || section == 5) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2 || section == 3 || section == 4 || section == 5) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 2*kCellHeightOfCategoryView + 30, kScreenWidth, 10)];
        view.backgroundColor = UIRGBColor(240, 240, 240);
        return view;
    }
    return nil;
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"首  页";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    
    UINavigationBar * bar = self.navigationController.navigationBar;
    [bar setShadowImage:[UIImage imageNamed:@"tm"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tm"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView = [self prepareTitleView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shouye-消息(5)"] style:UIBarButtonItemStylePlain target:self action:@selector(lookMessage)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)contentViewInit
{
    CGRect tableViewRect = CGRectMake(0, -(kStatusBarHeight + kNavigationBarHeight), kScreenWidth, kScreenHeight - kTabBarHeight);
    self.contentTableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    self.contentTableSource = [[ContentTableViewDataSource alloc] init];
    self.contentTableView.delegate = self;
    self.contentTableSource.catoryDataSourceArray = self.categoryArray;
    
    self.contentTableView.dataSource = self.contentTableSource;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self startRequest];
    }];
    
    __weak typeof(self)weakSelf = self;
    
    self.contentTableSource.mainCountDownBlock = ^{
        [[CourseraManager sharedManager]didRequestNotStartLivingCourseWithInfo:@{@"Month":@([NSString getCurrentMonth]),@"year":[NSString stringWithFormat:@"%d", [NSString getCurrentYear]]} NotifiedObject:weakSelf];
    };
    
    self.contentTableSource.mainMoreCourseBlock = ^{
        [weakSelf.tabBarController setSelectedIndex:1];
    };
    
    self.contentTableSource.clockBlock = ^(NSDictionary *infoDic){
        NSLog(@"%@", [infoDic description]);
        weakSelf.orderCourseId = [[infoDic objectForKey:kCourseID] intValue];
        if ([[UserManager sharedManager] isUserLogin]){
        
            [SVProgressHUD show];
            weakSelf.selectLivingCourseId = [[infoDic objectForKey:kCourseID] intValue];
            NSDictionary * infoDic1 = @{kCourseID:[infoDic objectForKey:kCourseID],
                                        kteacherId:@"",
                                        @"month":@(0)};
            
            [[CourseraManager sharedManager]didrequestLivingSectionDetailWithInfo:infoDic1 andNotifiedObject:weakSelf];
            
        }else{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLoginClick object:nil];
        }
        
    };
    
    self.contentTableSource.exchangeNewCourseBlock = ^{
        [weakSelf.contentTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    self.contentTableSource.moreLivingCourseBlock = ^{
        [weakSelf.contentTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        [weakSelf.contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    };
    
    [self.view addSubview:self.contentTableView];
}

- (void)requestEnd
{
    [self.contentTableView.mj_header endRefreshing];
    [SVProgressHUD dismiss];
}

#pragma mark - notification func
- (void)courseCategoryClick:(NSNotification *)notifier
{
    NSDictionary *infoDic = notifier.object;
    
    /*
     AllCourseViewController *allCourse = [[AllCourseViewController alloc] init];
     allCourse.intoType = IntoPageTypeCategoryCourse;
     UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
     self.navigationItem.backBarButtonItem = item;
     allCourse.courseCategoryId = [[infoDic objectForKey:kCourseCategoryId] intValue];
     allCourse.categoryName = [infoDic objectForKey:kCourseCategoryName];
     [self.navigationController pushViewController:allCourse animated:YES];
     */
    
    [self.tabBarController setSelectedIndex:1];
    
    if (self.courseVCdidload) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDetailCourse object:infoDic];
    }else
    {
        [self performSelector:@selector(postCourseVC:) withObject:@{@"infoDic":infoDic,@"nitifiName":kNotificationDetailCourse} afterDelay:1.0];
    }
}

- (void)postCourseVC:(NSDictionary *)infoDic
{
    NSDictionary * info = [infoDic objectForKey:@"infoDic"];
    NSString * notifiName = [infoDic objectForKey:@"nitifiName"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifiName object:info];
}

- (void)courseVCdidload:(NSNotification *)notification
{
    self.courseVCdidload = YES;
}

#pragma mark - myCoin
- (void)didRequestMyCoinSuccessed
{
    
}

- (void)didRequestMyCoinFailed:(NSString *)failedInfo
{
    
}

#pragma mark - hottest course delegate
- (void)didRequestHottestCourseSuccessed
{
    [self requestEnd];
    [self.contentTableView reloadData];
}

- (void)didRequestHottestFailed
{
    [self requestEnd];
    [SVProgressHUD showErrorWithStatus:@"网络连接失败，请稍后再试"];
}

#pragma mark - notStartLivingCourse course delegate
- (void)didRequestNotStartLivingCourseSuccessed
{
    self.notStartLivingArray = [[[CourseraManager sharedManager]getNotStartLivingCourseArray] objectAtIndex:0];
    [self requestEnd];
    [self.contentTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didRequestNotStartLivingCourseFailed:(NSString *)failedInfo
{
    [self requestEnd];
}

- (void)didRequestAllTestCategorySuccess
{
    
}

- (void)didRequestAllTestCategoryFailed:(NSString *)failedInfo
{
    
}

#pragma mark - acquireDiscountConpon
- (void)didRequestAcquireDiscountCouponSuccessed
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.discountCouponView = [[DiscountCouponVIew alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.discountCouponView.dataArray = [[UserManager sharedManager] getAcquireDiscountCoupon];
    [self.discountCouponView refreshUIWith:[[UserManager sharedManager] getAcquireDiscountCoupon]];
    if (self.discountCouponView.dataArray.count > 0) {
        if (![delegate.window.subviews containsObject:self.discountCouponView]) {
            [delegate.window addSubview:self.discountCouponView];
        }
    }
    
    __weak typeof(self)weakSelf = self;
    self.discountCouponView.closeBlock = ^{
        [weakSelf.discountCouponView removeFromSuperview];
        weakSelf.discountCouponView = nil;
        [weakSelf acquireDiscountCouponSuccesse];
    };
    self.discountCouponView.getDiscountCouponBlock = ^{
        
        [weakSelf.discountCouponView removeFromSuperview];
        DiscountCouponViewController * discountVC = [[DiscountCouponViewController alloc]init];
        discountVC.hidesBottomBarWhenPushed = YES;
        discountVC.myDscountCoupon = YES;
        [weakSelf.navigationController pushViewController:discountVC animated:YES];
        [weakSelf acquireDiscountCouponSuccesse];
        
//        [weakSelf.discountCouponView removeFromSuperview];
//        weakSelf.discountCouponView = nil;
//        [weakSelf acquireDiscountCouponSuccesse];
    };
}

- (void)didRequestAcquireDiscountCouponFailed:(NSString *)failedInfo
{
    
}

- (void)acquireDiscountCouponSuccesse
{
    NSArray * couponArr = [[UserManager sharedManager] getAcquireDiscountCoupon];
    NSMutableArray * arr = [NSMutableArray array];
    for (NSDictionary * infoDic in couponArr) {
        [arr addObject:[infoDic objectForKey:@"CouponId"]];
    }
    NSString * couponIdStr = [arr componentsJoinedByString:@","];
    
    [[UserManager sharedManager] didRequestAcquireDiscountCouponSuccessWithCourseInfo:@{@"couponIdStr":couponIdStr}];
}

#pragma mark - banner delegate
- (void)didBannerRequestSuccess
{
    [self requestEnd];
    [self.contentTableView reloadData];
}

- (void)didBannerRequestFailed
{
    [self requestEnd];
//    [SVProgressHUD showErrorWithStatus:@"网络连接失败，请稍后再试"];
}

#pragma mark - all course category delegate
- (void)didRequestAllCourseCategorySuccessed
{
//    self.categoryArray = [[CourseraManager sharedManager] getAllCategoryArray];
    [self requestEnd];
    [self.contentTableView reloadData];
}

- (void)didRequestAllCourseFailed
{
    [self requestEnd];
    [SVProgressHUD showErrorWithStatus:@"网络连接失败，请稍后再试"];
}

#pragma mark - question delegate
- (void)didQuestionRequestSuccessed
{
    self.mainQuestionArray = [[QuestionManager sharedManager] getMainQuestionInfos];
    self.contentTableSource.mainQuestionArray = self.mainQuestionArray;
    [self requestEnd];
    [self.contentTableView reloadData];
}

- (void)didQuestionRequestFailed:(NSString *)failedInfo
{
    [self requestEnd];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}
#pragma mark - LivingSectionDetailProtocal

- (void)didRequestLivingSectionDetailSuccessed
{
    [SVProgressHUD dismiss];
//    LivingSectionDetailViewController * livingSectionVC = [[LivingSectionDetailViewController alloc]init];
//    livingSectionVC.courseId = self.selectLivingCourseId;
//    livingSectionVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:livingSectionVC animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLivingChatClick object:self.selectLivingCourseInfoDic];
    
}

- (void)didRequestLivingSectionDetailFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestLevelDetailSuccessed
{
    
}

- (void)didRequestLevelDetailFailed:(NSString *)failedInfo
{
    
}

#pragma mark - navigationaction
- (void)lookMessage
{
    
    NSDictionary * teacherInfo = [[[UserManager sharedManager] getAssistantList] firstObject];
    NSString  *qqNumber=[teacherInfo objectForKey:@"assistantQQ"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectZero];
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qqNumber]];
        
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        webView.delegate = self;
        [webView loadRequest:request];
        [self.view addSubview:webView];
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"对不起，您还没安装QQ"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
    return;
    
    if ([[UserManager sharedManager] getUserId]) {
        
        /*
         RCDCustomerServiceViewController * chatService = [[RCDCustomerServiceViewController alloc]init];
         chatService.conversationType = ConversationType_CUSTOMERSERVICE;
         
         chatService.targetId = SERVICE_ID;
         
         RCCustomerServiceInfo *csInfo = [[RCCustomerServiceInfo alloc] init];
         csInfo.userId = [RCIMClient sharedRCIMClient].currentUserInfo.userId;
         csInfo.nickName = @"昵称";
         csInfo.loginName = @"登录名称";
         csInfo.name = @"用户名称";
         csInfo.grade = @"11级";
         csInfo.gender = @"男";
         csInfo.birthday = @"2016.5.1";
         csInfo.age = @"36";
         csInfo.profession = @"software engineer";
         csInfo.portraitUrl =
         [RCIMClient sharedRCIMClient].currentUserInfo.portraitUri;
         csInfo.province = @"beijing";
         csInfo.city = @"beijing";
         csInfo.memo = @"这是一个好顾客!";
         
         csInfo.mobileNo = @"13800000000";
         csInfo.email = @"test@example.com";
         csInfo.address = @"北京市北苑路北泰岳大厦";
         csInfo.QQ = @"88888888";
         csInfo.weibo = @"my weibo account";
         csInfo.weixin = @"myweixin";
         
         csInfo.page = @"卖化妆品的页面来的";
         csInfo.referrer = @"客户端";
         csInfo.enterUrl = @"testurl";
         csInfo.skillId = @"技能组";
         csInfo.listUrl = @[@"用户浏览的第一个商品Url",
         @"用户浏览的第二个商品Url"];
         csInfo.define = @"自定义信息";
         
         chatService.csInfo = csInfo;
         chatService.title = @"客服";
         
         chatService.hidesBottomBarWhenPushed = YES;
         UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
         self.navigationItem.backBarButtonItem = item;
         
         [self.navigationController pushViewController:chatService animated:YES];
         */
        
    }else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationOfLoginClick object:nil];
    }
    
}

- (UIView *)prepareTitleView
{
    
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 7, kScreenWidth - 100, 30)];
    titleView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    titleView.layer.cornerRadius = titleView.frame.size.height / 2;
    titleView.layer.masksToBounds = YES;
    
    UIImageView * searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 9, 12, 12)];
    searchImageView.image = [UIImage imageNamed:@"shouye-搜索_"];
    searchImageView.userInteractionEnabled = YES;
    [titleView addSubview:searchImageView];
    
    UILabel * searchLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(searchImageView.frame) + 5, 9, titleView.frame.size.width - 32, 12)];
    searchLB.text = @"搜视频课、直播课";
    searchLB.font = [UIFont systemFontOfSize:12];
    searchLB.textColor = [UIColor whiteColor];
    searchLB.userInteractionEnabled = YES;
    [titleView addSubview:searchLB];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchClick)];
    [titleView addGestureRecognizer:tap];
    
    return titleView;
}

- (void)searchClick
{
    SearchViewController * vc = [[SearchViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = fabs(offset / 64.0);
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[UIRGBColor(19, 0, 160) colorWithAlphaComponent:alpha]] forBarMetrics:UIBarMetricsDefault];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *imgae = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgae;
}


@end
