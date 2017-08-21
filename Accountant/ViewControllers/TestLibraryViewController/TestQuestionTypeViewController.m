//
//  TestQuestionTypeViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestQuestionTypeViewController.h"
#import "UIMacro.h"
#import "TestListViewController.h"
#import "TestSimulateViewController.h"
#import "TestErrorViewController.h"
#import "TestRewriteWrongViewController.h"

@interface TestQuestionTypeViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UITableView            *tableView;

@property (nonatomic,strong) UIImageView            *imageView1;
@property (nonatomic,strong) UIImageView            *imageView2;
@property (nonatomic,strong) UIImageView            *imageView3;
@property (nonatomic,strong) UIImageView            *imageView4;

@end

@implementation TestQuestionTypeViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer
                                      *)gestureRecognizer{
    return YES; //YES：允许右滑返回  NO：禁止右滑返回
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundGrayColor;
    // Do any additional setup after loading the view.
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self.view addSubview:self.tableView];
    [self navigationViewSetup];
    [self contentViewSetup];
}

- (void)navigationViewSetup
{
    self.navigationItem.title = @"类型";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
}

#pragma mark - table delegate
- (void)contentViewSetup
{
    CGSize viewSize = CGSizeMake(140, 90);
    self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth/2 - viewSize.width)/2, (kScreenHeight-kStatusBarHeight-kNavigationBarHeight-kTabBarHeight)/2 -viewSize.height - 60  , viewSize.width, viewSize.height)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] init];
    [tap1 addTarget:self action:@selector(chapterTestClick)];
    [self.imageView1 addGestureRecognizer:tap1];
    self.imageView1.userInteractionEnabled = YES;
    self.imageView1.image = [UIImage imageNamed:@"tiku-1.png"];
    [self.view addSubview:self.imageView1];
    
    self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth/2 - viewSize.width)/2 + kScreenWidth/2, (kScreenHeight-kStatusBarHeight-kNavigationBarHeight-kTabBarHeight)/2 -viewSize.height - 60  , viewSize.width, viewSize.height)];
    self.imageView2.image = [UIImage imageNamed:@"tiku-2.png"];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] init];
    [tap2 addTarget:self action:@selector(simulateTestClick)];
    [self.imageView2 addGestureRecognizer:tap2];
    self.imageView2.userInteractionEnabled = YES;
    [self.view addSubview:self.imageView2];

    self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth/2 - viewSize.width)/2, (kScreenHeight-kStatusBarHeight-kNavigationBarHeight-kTabBarHeight)/2 -viewSize.height + 60  , viewSize.width, viewSize.height)];
    self.imageView3.image = [UIImage imageNamed:@"tiku-3.png"];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] init];
    [tap3 addTarget:self action:@selector(errorTestClick)];
    [self.imageView3 addGestureRecognizer:tap3];
    self.imageView3.userInteractionEnabled = YES;
    [self.view addSubview:self.imageView3];
    
    self.imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth/2 - viewSize.width)/2 + kScreenWidth/2, (kScreenHeight-kStatusBarHeight-kNavigationBarHeight-kTabBarHeight)/2 -viewSize.height + 60, viewSize.width, viewSize.height)];
    self.imageView4.image = [UIImage imageNamed:@"tiku-4.png"];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] init];
    [tap4 addTarget:self action:@selector(myWrongTestClick)];
    [self.imageView4 addGestureRecognizer:tap4];
    self.imageView4.userInteractionEnabled = YES;
    [self.view addSubview:self.imageView4];
}

- (void)chapterTestClick
{
    TestListViewController *vc = [[TestListViewController alloc] init];
    vc.categoryName = self.cateName;
    vc.courseCategoryId = self.cateId;
    vc.listType = TestListTypeChapterTest;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)simulateTestClick
{
    TestSimulateViewController *vc = [[TestSimulateViewController alloc] init];
    vc.cateName = self.cateName;
    vc.cateId = self.cateId;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)errorTestClick
{
    TestErrorViewController *vc = [[TestErrorViewController alloc] init];
    vc.cateName = self.cateName;
    vc.cateId = self.cateId;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)myWrongTestClick
{
    TestRewriteWrongViewController *vc = [[TestRewriteWrongViewController alloc] init];
    vc.cateName = self.cateName;
    vc.cateId = self.cateId;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ccccc"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ccccc"];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"章节练习";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"模拟测试";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"易错题";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
    }
    if (indexPath.row == 1) {
        
    }
    if (indexPath.row == 2) {
        
    }
}


@end
