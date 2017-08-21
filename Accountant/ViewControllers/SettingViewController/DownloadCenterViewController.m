//
//  DownloadCenterViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/10.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DownloadCenterViewController.h"
#import "UIMacro.h"
#import "DownloaderManager.h"
#import "DownloadingTableViewDataSource.h"
#import "DownloadedTableViewDataSource.h"
#import "DownloadModule_Protocol.h"
#import "DownloadingTableViewCell.h"
#import "DownloadedVideoListViewController.h"
#import "CommonMacro.h"
#import "HYSegmentedControl.h"

#define kHeaderViewHeight 45
#define kSegmentHeight 42
@interface DownloadCenterViewController ()<UITableViewDelegate,DownloadModule_DownloadProtocol, HYSegmentedControlDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong)HYSegmentedControl * segmentC;
@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic,strong) UITableView                            *downloadingTableView;
@property (nonatomic,strong) UITableView                            *downloadedTableView;
@property (nonatomic,strong) DownloadingTableViewDataSource         *downloadingTableDataSource;
@property (nonatomic,strong) DownloadedTableViewDataSource          *downloadedTableDataSource;



@property (nonatomic,strong) NSArray                                *downloadCourseArray;

@property (nonatomic,strong) UIView                                 *headerView;

@property (nonatomic,strong) UIButton                               *button1;
@property (nonatomic,strong) UIButton                               *button2;

@end

@implementation DownloadCenterViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self reloadTables];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [DownloaderManager sharedManager].processDownloadDelegate = self;
    self.downloadCourseArray = [[[DownloaderManager sharedManager] getDownloadCourseInfoArray] copy];
    [self segmentSetup];
    [self setupTables];
//    [self contentViewSetup];
    [self navigationViewSetup];
}

- (void)navigationViewSetup
{
    self.navigationItem.title = @"下载中心";
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer
                                      *)gestureRecognizer{
    return YES; //YES：允许右滑返回  NO：禁止右滑返回
}

- (void)resetPauseButton
{
//    if ([[DownloaderManager sharedManager] getIsDownloadPause]) {
//        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"继续" style:UIBarButtonItemStylePlain target:self action:@selector(continueDownload)];
//        self.navigationItem.rightBarButtonItem = item;
//    }else{
//        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"暂停" style:UIBarButtonItemStylePlain target:self action:@selector(pauseDownload)];
//        self.navigationItem.rightBarButtonItem = item;
//    }
}

- (void)switchDownloadedTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self.downloadingTableView removeFromSuperview];
        [self.view addSubview:self.downloadedTableView];
        [self.button1 setTitleColor:kCommonNavigationBarColor forState:UIControlStateNormal];
        [self.button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = nil;
        [self reloadTables];
    });
}

- (void)switchDownloadingTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.downloadedTableView removeFromSuperview];
        [self.view addSubview:self.downloadingTableView];
        [self.button2 setTitleColor:kCommonNavigationBarColor forState:UIControlStateNormal];
        [self.button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self resetPauseButton];
        [self reloadTables];
    });
}

- (void)contentViewSetup
{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderViewHeight)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headerView];
    
    self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button1.frame = CGRectMake(0, 0, kScreenWidth/2, kHeaderViewHeight);
    [self.button1 setTitle:@"已下载" forState:UIControlStateNormal];
    [self.button1 setTitleColor:kCommonNavigationBarColor forState:UIControlStateNormal];
    self.button1.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.button1 addTarget:self action:@selector(switchDownloadedTable) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button2.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, kHeaderViewHeight);
    [self.button2 setTitle:@"下载中" forState:UIControlStateNormal];
    [self.button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.button2.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.button2 addTarget:self action:@selector(switchDownloadingTable) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2, 5, 1, 30)];
    lineView.backgroundColor = kTableViewCellSeparatorColor;
    [self.headerView addSubview:lineView];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 5)];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = bottomLineView.bounds;
    layer.startPoint = CGPointMake(0.5, 0);
    layer.endPoint = CGPointMake(0.5, 1);
    layer.colors = [NSArray arrayWithObjects:(id)kTableViewCellSeparatorColor.CGColor,(id)[UIColor whiteColor].CGColor, nil];
    layer.locations = @[@(0.3f)];
    [bottomLineView.layer addSublayer:layer];
    
    [self.headerView addSubview:bottomLineView];
    [self.headerView addSubview:self.button1];
    [self.headerView addSubview:self.button2];
    
    [self.view addSubview:self.downloadedTableView];
/*    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kHeaderViewHeight, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight - kHeaderViewHeight) style:UITableViewStylePlain];
    self.tableDataSource = [[DownloadCenterTableDataSource alloc] init];
    self.tableDataSource.downloadCourseInfos = self.downloadCourseArray;
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self.tableDataSource;
    
    [self.view addSubview:self.contentTableView];*/
}

- (void)segmentSetup
{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, 64)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    
    if (self.isPresent) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [self addTopView];
        
        self.segmentC = [[HYSegmentedControl alloc] initWithOriginY:64 Titles:@[@"已下载", @"正在下载"] delegate:self];
    }else
    {
        self.segmentC = [[HYSegmentedControl alloc] initWithOriginY:0 Titles:@[@"已下载", @"正在下载"] delegate:self];
    }
    
    [self.view addSubview:self.segmentC];
}

- (void)setupTables
{
    CGFloat presentHeight = 0;
    if (self.isPresent) {
        presentHeight = 64;
    }
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kSegmentHeight + presentHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kSegmentHeight)];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kSegmentHeight);
    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    
    self.downloadedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kHeaderViewHeight) style:UITableViewStylePlain];
    self.downloadedTableDataSource = [[DownloadedTableViewDataSource alloc] init];
    self.downloadedTableView.dataSource = self.downloadedTableDataSource;
    self.downloadedTableView.delegate = self;
    self.downloadedTableDataSource.downloadedCourseInfoArray = [[DownloaderManager sharedManager] getDownloadCourseInfoArray];
    [self.scrollView addSubview:self.downloadedTableView];
    
    self.downloadingTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kHeaderViewHeight) style:UITableViewStylePlain];
    self.downloadingTableDataSource = [[DownloadingTableViewDataSource alloc] init];
    self.downloadingTableView.dataSource = self.downloadingTableDataSource;
    self.downloadingTableView.delegate = self;
    
    self.downloadingTableDataSource.downloadingVideoInfos = [[DownloaderManager sharedManager] getDownloadingVideoInfoArray];
    [self.scrollView addSubview:self.downloadingTableView];
}

- (void)reloadTables
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.downloadedTableDataSource.downloadedCourseInfoArray = [[DownloaderManager sharedManager] getDownloadCourseInfoArray];
        self.downloadingTableDataSource.downloadingVideoInfos = [[DownloaderManager sharedManager] TY_getDownloadingVideoInfoArray];

        [self.downloadingTableView reloadData];
        [self.downloadedTableView reloadData];
    });
    
}

#pragma mark - download delegate
- (void)didDownloadSuccess
{
    [self reloadTables];
}

- (void)didDownloadFailed
{
    [self reloadTables];
}

- (void)deleteDownloadTask
{
    [self reloadTables];
}

#pragma mark - table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.downloadedTableView) {
        return 100;
    }else{
        return 100;
    }
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.downloadedTableView) {
        DownloadedVideoListViewController *vc = [[DownloadedVideoListViewController alloc] init];
        vc.courseInfoDic = [[[DownloaderManager sharedManager] getDownloadCourseInfoArray] objectAtIndex:indexPath.row];
        
        if (self.isPresent) {
            vc.isPresent = self.isPresent;
            [self presentVC:vc];
            
        }else
        {
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}

- (NSArray <UITableViewRowAction *>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.downloadingTableView]) {
        NSDictionary *videoInfo = [self.downloadingTableDataSource.downloadingVideoInfos objectAtIndex:indexPath.row];
        
        TYDownloadModel * model = [[DownloaderManager sharedManager] TY_getDownLoadModelWithDownloadVideoURL:[videoInfo objectForKey:kVideoURL]];
        
        UITableViewRowAction * action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [[DownloaderManager sharedManager] TY_deleteDownloadtask:model];
        }];
        
        NSArray * arr = @[action];
        return arr;
    }else
    {
        return [NSArray array];
    }
}
#pragma mark - HYSegmentedControl 代理方法
- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    [self.scrollView setContentOffset:CGPointMake(index * _scrollView.hd_width, 0) animated:NO];
}

- (void)addTopView
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 100, 20, 200, 44)];
    titleLabel.text = @"下载中心";
    titleLabel.textColor = kCommonMainTextColor_50;
    titleLabel.textAlignment = 1;
    [topView addSubview:titleLabel];
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(15, 22 + 12, 20, 20);
    [backBT setImage:[UIImage imageNamed:@"public-返回"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBT];
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 63, kScreenWidth, 0.5)];
    bottomView.backgroundColor = kCommonMainTextColor_200;
    [topView addSubview:bottomView];
    
}

- (void)backAction
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionReveal;
    [self.view.window.layer addAnimation:animation forKey:nil ];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)presentVC:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        DownloadedVideoListViewController * vc = sender;
        CATransition *animation = [CATransition animation];
        animation.duration = 0.3;
        
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionReveal;
        animation.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:animation forKey:nil];
        
        [self presentViewController:vc animated:NO completion:nil];
    });
}

@end
