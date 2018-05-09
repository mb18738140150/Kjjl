//
//  TestLibraryViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/16.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestLibraryViewController.h"
#import "UIMacro.h"
#import "CommonMacro.h"
#import "TestListViewController.h"
#import "TestSimulateViewController.h"
#import "TestErrorViewController.h"
#import "TestRewriteWrongViewController.h"
#import "SubCategoryCollectionViewCell.h"
#import "SimpleHeaderCollectionViewCell.h"
#import "TestRecordViewController.h"
#import "CourseTypeCollectionViewCell.h"
#import "SimulateresulrHeadCell.h"
#import "TestCollectionViewController.h"
#import "DailyPracticeViewController.h"

#import "CourseTypeBottomCollectionViewCell.h"
#define kCourseTypeCollectionViewCellID @"CourseTypeCollectionViewCellID"
#define kSimulateresulrHeadCellId @"SimulateresulrHeadCellId"
#define kCourseTypeBottomCollectionViewCellid @"CourseTypeBottomCollectionViewCellID"

@interface TestLibraryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TestModule_JurisdictionProtocol,TestModule_AllCategoryProtocol>

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView * titleImageView;
@property (nonatomic,strong) NSArray            *categoryArray;
//@property (nonatomic,strong) NSArray            *subcategoryArray1;
//@property (nonatomic,strong) NSArray            *subcategoryArray2;
//@property (nonatomic,strong) NSArray            *subcategoryArray3;
//@property (nonatomic,strong) NSArray            *subcategoryArray4;
@property (nonatomic, assign)BOOL isFold;

@property (nonatomic, assign)int section;
@property (nonatomic, assign)int row;
@property (nonatomic, assign)int lid;
@property (nonatomic,strong) NSString       *cateName;
@property (nonatomic,assign) int             cateId;

@property (nonatomic, strong)NSDictionary * selectDic;

@property (nonatomic,strong) UIView             *section1View;
@property (nonatomic,strong) UIView             *section2View;
@property (nonatomic,strong) UIView             *section3View;

@property (nonatomic,strong) NSString           *clickCateName;
@property (nonatomic,assign) int                 clickCateId;

@property (nonatomic,strong) UICollectionView   *collectView;
@property (nonatomic, strong)UIView *backView;
@property (nonatomic,strong) UICollectionViewFlowLayout         *flowLayout;

@property (nonatomic, strong)UICollectionView *questionTypeCollectionView;
@property (nonatomic, strong)NSArray * typeDetailArray;

#pragma mark - 权限
@property (nonatomic, assign)BOOL isHaveJurisdiction;

@end

@implementation TestLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.categoryArray = [[TestManager sharedManager] getAllCategory];
    self.typeDetailArray = @[@{@"title":@"章节练习", @"content":@"配合视频学习更佳哦", @"iconUrl":@"tiku-icon1"}, @{@"title":@"模拟试题", @"content":@"练习模拟试题可以预测分数哦", @"iconUrl":@"tiku-icon2"}, @{@"title":@"易错题", @"content":@"巩固学习会让基础知识更扎实哦", @"iconUrl":@"icon_yct"},@{@"title":@"每日一练", @"content":@"每日一练会巩固基础知识哦", @"iconUrl":@"icon_mryl"}];

    
    [self navigationViewSetup];
    [self contentViewSetup];
    
    if (self.categoryArray.count == 0) {
        [SVProgressHUD show];
        [[TestManager sharedManager] didRequestTestAllCategoryWithNotifiedObject:self];
        return;
    }
    
    
//    self.categoryArray = @[@"初级会计职称",@"2017中级会计职称",@"2018中级会计职称"];
    // 初级lid：21 中级lid：112
    
    /*
     self.subcategoryArray1 = @[@{kTestCategoryName:@"会计基础",
     kTestCategoryImageName:@"classImg-1-2.png",
     kTestCategoryId:@(12924)},
     @{kTestCategoryName:@"财经法规",
     kTestCategoryImageName:@"classImg-1-3.png",
     kTestCategoryId:@(12925)},
     @{kTestCategoryName:@"会计电算化",
     kTestCategoryImageName:@"classImg-1-4.png",
     kTestCategoryId:@(12926)}];
     
     self.subcategoryArray2 = @[@{kTestCategoryName:@"经济法基础",
     kTestCategoryImageName:@"classImg-2-2.png",
     kTestCategoryId:@(67),
     kLID:@(21)},
     @{kTestCategoryName:@"初级会计实务",
     kTestCategoryImageName:@"classImg-2-3.png",
     kTestCategoryId:@(22),
     kLID:@(21)}];
     self.subcategoryArray3 = @[@{kTestCategoryName:@"中级经济法",
     kTestCategoryImageName:@"classImg-3-3.png",
     kTestCategoryId:@(317),
     kLID:@(112)},
     @{kTestCategoryName:@"中级会计实务",
     kTestCategoryImageName:@"classImg-3-2.png",
     kTestCategoryId:@(318),
     kLID:@(112)},
     @{kTestCategoryName:@"中级财务管理",
     kTestCategoryImageName:@"classImg-3-4.png",
     kTestCategoryId:@(315),
     kLID:@(112)}];
     
     self.subcategoryArray4 = @[@{kTestCategoryName:@"中级经济法",
     kTestCategoryImageName:@"classImg-3-3.png",
     kTestCategoryId:@(317),
     kLID:@(112)},
     @{kTestCategoryName:@"中级会计实务",
     kTestCategoryImageName:@"classImg-3-2.png",
     kTestCategoryId:@(318),
     kLID:@(112)},
     @{kTestCategoryName:@"中级财务管理",
     kTestCategoryImageName:@"classImg-3-4.png",
     kTestCategoryId:@(315),
     kLID:@(112)}];
     */
    
   
    /*
     //    if (cateId != 0) {
     //        for (int i = 0; i < 2; i++) {
     //            if (i == 0) {
     //                for (int j = 0; j < self.subcategoryArray2.count; j++) {
     //                    NSDictionary * infoDic = self.subcategoryArray2[j];
     //                    if (cateId ==  [[infoDic objectForKey:kTestCategoryId] intValue]) {
     //                        self.cateId = [[infoDic objectForKey:kTestCategoryId] intValue];
     //                        self.cateName = [infoDic objectForKey:kTestCategoryName];
     //                        self.section= i;
     //                        self.row = j;
     //                    }
     //                }
     //
     //            }else
     //            {
     //                for (int j = 0; j < self.subcategoryArray3.count; j++) {
     //                    NSDictionary * infoDic = self.subcategoryArray3[j];
     //                    if (cateId ==  [[infoDic objectForKey:kTestCategoryId] intValue]) {
     //                        self.cateId = [[infoDic objectForKey:kTestCategoryId] intValue];
     //                        self.cateName = [infoDic objectForKey:kTestCategoryName];
     //                        self.section= i;
     //                        self.row = j;
     //                    }
     //                }
     //            }
     //        }
     //
     //    }else
     //    {
     //        NSDictionary * dic = self.subcategoryArray2[0];
     //        self.cateId = [[dic objectForKey:kTestCategoryId] intValue];
     //        self.cateName = [dic objectForKey:kTestCategoryName];
     //        self.lid = [[dic objectForKey:kLID] intValue];
     //    }
     */
    
    
    [self resetInfoDic];
}

- (void)resetInfoDic
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kLID]) {
        self.lid = [[[NSUserDefaults standardUserDefaults] objectForKey:kLID] intValue];
    }
    int cateId = 0;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kTestCategoryId]) {
        cateId = [[[NSUserDefaults standardUserDefaults] objectForKey:kTestCategoryId] intValue];
    }
    
    NSLog(@"cateID = %d", cateId);
    
    if (cateId != 0) {
        
        for (int i = 0; i < self.categoryArray.count; i++) {
            NSDictionary *lDic = [self.categoryArray objectAtIndex:i];
            
            NSArray * cateArr = [lDic objectForKey:@"subject"];
            for (int j = 0; j <[cateArr count] ; j++) {
                NSDictionary * cateDic = [cateArr objectAtIndex:j];
                if (cateId == [[cateDic objectForKey:kTestCategoryId] intValue]) {
                    self.cateId = [[cateDic objectForKey:kTestCategoryId] intValue];
                    self.cateName = [cateDic objectForKey:kTestCategoryName];
                    self.section= i;
                    self.row = j;
                }
            }
        }
    }else
    {
        NSDictionary * cateDic = [[[self.categoryArray objectAtIndex:0] objectForKey:@"subject"] objectAtIndex:0];
        self.cateId = [[cateDic objectForKey:kTestCategoryId] intValue];
        self.cateName = [cateDic objectForKey:kTestCategoryName];
        self.lid = [[cateDic objectForKey:kLID] intValue];
    }
    self.titleLabel.text = self.cateName;
    [self.collectView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectView reloadData];
//        [self.questionTypeCollectionView reloadData];
    });
    
}

#pragma mark - response func
- (void)click
{
    TestListViewController *vc = [[TestListViewController alloc] init];
    vc.categoryName = self.clickCateName;
    vc.courseCategoryId = self.clickCateId;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ui

- (void)navigationViewSetup
{
    self.navigationItem.title = @"题  库";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
    
    self.navigationItem.titleView = [self getTitleView];
}

- (UIView *)getTitleView
{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 100, 44)];
    titleView.backgroundColor = kCommonNavigationBarColor;
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleView.hd_centerX - 80, 0, 110, 44)];
    self.titleLabel.text = @"选择科目";
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    self.titleLabel.textColor = kCommonMainTextColor_50;
    [titleView addSubview:self.titleLabel];
    
    self.titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 10, 17, 15, 10)];
    self.titleImageView.image = [UIImage imageNamed:@"tiku-tra2"];
    [titleView addSubview:self.titleImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchClick)];
    [titleView addGestureRecognizer:tap];
    
    return titleView;
}

- (void)searchClick
{
    if (!self.isFold) {
        
        self.collectView.hidden = NO;
        self.backView.hidden = NO;
        self.collectView.frame = CGRectMake(0, 0, kScreenWidth, 0);
        [UIView animateWithDuration:0.3 animations:^{
            self.collectView.frame = CGRectMake(0, 0, kScreenWidth, 240);
            self.titleImageView.transform = CGAffineTransformRotate(self.titleImageView.transform, M_PI);
        } completion:^(BOOL finished) {
        }];
    }else
    {
        self.collectView.frame = CGRectMake(0, 0, kScreenWidth, 240);
        [UIView animateWithDuration:0.3 animations:^{
            self.collectView.frame = CGRectMake(0, 0, kScreenWidth, 0);
            self.titleImageView.transform = CGAffineTransformRotate(self.titleImageView.transform, -M_PI);
        } completion:^(BOOL finished) {
            self.collectView.hidden = YES;
            self.backView.hidden = YES;
        }];
    }
    self.isFold = !self.isFold;
}

- (void)contentViewSetup
{
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.itemSize = CGSizeMake(kScreenWidth / 2, 40);
    
    UICollectionViewFlowLayout * laoout = [[UICollectionViewFlowLayout alloc]init];
    laoout.minimumLineSpacing = 0;
    laoout.minimumInteritemSpacing = 0;
    self.questionTypeCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kTabBarHeight - kStatusBarHeight) collectionViewLayout:laoout];
    [self.questionTypeCollectionView registerNib:[UINib nibWithNibName:@"SimulateresulrHeadCell" bundle:nil] forCellWithReuseIdentifier:kSimulateresulrHeadCellId];
    [self.questionTypeCollectionView registerNib:[UINib nibWithNibName:@"CourseTypeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCourseTypeCollectionViewCellID];
    [self.questionTypeCollectionView registerNib:[UINib nibWithNibName:@"CourseTypeBottomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCourseTypeBottomCollectionViewCellid];
    self.questionTypeCollectionView.backgroundColor = kBackgroundGrayColor;
    self.questionTypeCollectionView.delegate = self;
    self.questionTypeCollectionView.dataSource = self;
    [self.view addSubview:self.questionTypeCollectionView];
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kTabBarHeight)];
    self.backView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.4];
    [self.view addSubview:self.backView];
    self.backView.hidden = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchClick)];
    [self.backView addGestureRecognizer:tap];
    
    self.collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 340) collectionViewLayout:self.flowLayout];
    [self.collectView registerClass:[SubCategoryCollectionViewCell class] forCellWithReuseIdentifier:@"testSubCategoryCell"];
    [self.collectView registerClass:[SimpleHeaderCollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"testCategoryHeader"];
    self.collectView.hidden = YES;
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    self.collectView.backgroundColor = [UIColor whiteColor];
//    self.collectView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.view addSubview:self.collectView];
    
    self.view.backgroundColor = UIRGBColor(240, 240, 240);
    
    self.titleLabel.text = self.cateName;
    [self.collectView reloadData];
    
}

#pragma mark - collect view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([collectionView isEqual:self.collectView]) {
        
        self.section = (int)indexPath.section;
        self.row = (int)indexPath.row;
        
        NSDictionary * dic = [NSDictionary dictionary];

        dic = [[self.categoryArray[indexPath.section] objectForKey:@"subject"] objectAtIndex:indexPath.row];
        
        self.selectDic = dic;
        self.lid = [[dic objectForKey:kLID] intValue];
        self.cateId = [[dic objectForKey:kTestCategoryId] intValue];
        self.cateName = [dic objectForKey:kTestCategoryName];
        self.titleLabel.text = self.cateName;
        [self.collectView reloadData];
        [self.questionTypeCollectionView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self searchClick];
        });
        [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:kTestCategoryId] forKey:kTestCategoryId];
        [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:kLID] forKey:kLID];
        
//        [[TestManager sharedManager] didRequestTestJurisdictionWithcourseId:[[dic objectForKey:kTestCategoryId] intValue] NotifiedObject:self];
//        [SVProgressHUD show];
        
    }else
    {
        switch (indexPath.row) {
            case 1:
                [self chapterTestClick];
                break;
            case 2:
                [self simulateTestClick];
                break;
            case 3:
                [self easyErrorTestClick];
                break;
            case 4:
                [self dailyPracticeClick];
                break;
            default:
                break;
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([collectionView isEqual:self.collectView]) {
        NSLog(@"self.categoryArray.count = %d", self.categoryArray.count);
        return self.categoryArray.count;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:self.collectView]) {
        NSLog(@"[[self.categoryArray[section] objectForKey:@\"subject\"] count] = %d", [[self.categoryArray[section] objectForKey:@"subject"] count]);
        return [[self.categoryArray[section] objectForKey:@"subject"] count];
    }
    NSLog(@"***** zoule *****");
    return 4;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.collectView]) {
        
        SubCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"testSubCategoryCell" forIndexPath:indexPath];
        NSDictionary * infoDic = [[self.categoryArray[indexPath.section] objectForKey:@"subject"] objectAtIndex:indexPath.row];
        [cell resetViewWithDic:infoDic indexPath:indexPath];

        if (self.section == indexPath.section && self.row == indexPath.row) {
            cell.titleLabel.textColor = kCommonMainColor;
        }
        
        return cell;
    }
    
    if (indexPath.row == 0) {
        SimulateresulrHeadCell * headCell = [collectionView dequeueReusableCellWithReuseIdentifier:kSimulateresulrHeadCellId forIndexPath:indexPath];
        [headCell resetScoreWithInfo:[[DBManager sharedManager] getSimulateScoreWith:@(self.cateId)]];
        return headCell;
    }else if (indexPath.row == 3) {
        CourseTypeBottomCollectionViewCell * headCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCourseTypeBottomCollectionViewCellid forIndexPath:indexPath];
        __weak typeof(self)weakSelf = self;
        headCell.SelectTypeBlock = ^(SelectType type){
            if (Type_wrong == type) {
                [weakSelf reWriteClick];
            }else if (Type_collect == type)
            {
                [weakSelf collectTestClick];
            }else
            {
                [weakSelf recordClick];
            }
        };
        return headCell;
    }
    else
    {
        CourseTypeCollectionViewCell * typeCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCourseTypeCollectionViewCellID forIndexPath:indexPath];
        
        [typeCell resetWithInfo:[self.typeDetailArray objectAtIndex:indexPath.row - 1]];
        
        return typeCell;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = kScreenWidth/2;
    if ([collectionView isEqual:self.collectView]) {
        
        return CGSizeMake(width, 40);
    }else
    {
        if (indexPath.row == 0) {
            return CGSizeMake(kScreenWidth, kCellHeightOfBanner + 25);
        }else if (indexPath.row == 3){
            return CGSizeMake(kScreenWidth, 115);
        }
        
        return CGSizeMake(kScreenWidth, 75);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.collectView]) {
        SimpleHeaderCollectionViewCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"testCategoryHeader" forIndexPath:indexPath];
        [cell resetViewWithInfo:[[self.categoryArray objectAtIndex:indexPath.section] objectForKey:@"name"]];
        return cell;
    }else
    {
        return nil;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (![self.collectView isEqual:collectionView]) {
        return CGSizeMake(0, 0);
        
    }
    return CGSizeMake(kScreenWidth, 60);
}

#pragma mark - allCategory
- (void)didRequestAllTestCategorySuccess
{
   [SVProgressHUD dismiss];
    self.categoryArray = [[TestManager sharedManager] getAllCategory];
    [self resetInfoDic];
}

- (void)didRequestAllTestCategoryFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
//    [SVProgressHUD showErrorWithStatus:failedInfo];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [SVProgressHUD dismiss];
//
//    });
}

#pragma mark - courseJurisdiction
- (void)didRequestJurisdictionSuccess
{
    self.isHaveJurisdiction = YES;
    [SVProgressHUD dismiss];
    NSDictionary * dic = self.selectDic;
    self.lid = [[dic objectForKey:kLID] intValue];
    self.cateId = [[dic objectForKey:kTestCategoryId] intValue];
    self.cateName = [dic objectForKey:kTestCategoryName];
    self.titleLabel.text = self.cateName;
    [self.collectView reloadData];
    [self.questionTypeCollectionView reloadData];
    [self searchClick];
}
 
- (void)didRequestJurisdictionFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        
    });
}

- (void)chapterTestClick
{
    TestListViewController *vc = [[TestListViewController alloc] init];
    vc.categoryName = self.cateName;
    vc.courseCategoryId = self.cateId;
    vc.lid = self.lid;
    vc.listType = TestListTypeChapterTest;
    vc.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)simulateTestClick
{
    TestSimulateViewController *vc = [[TestSimulateViewController alloc] init];
    vc.cateName = self.cateName;
    vc.cateId = self.cateId;
    vc.lid = self.lid;
    vc.hidesBottomBarWhenPushed = YES;
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)reWriteClick
{
    TestRewriteWrongViewController * vc = [[TestRewriteWrongViewController alloc]init];
    vc.cateName = self.cateName;
    vc.courseCategoryId = self.cateId;
    vc.lid = self.lid;
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dailyPracticeClick
{
    DailyPracticeViewController *vc = [[DailyPracticeViewController alloc] init];
    vc.courseCategoryId = self.cateId;
    vc.lid = self.lid;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)easyErrorTestClick
{
    TestErrorViewController *vc = [[TestErrorViewController alloc] init];
    vc.cateName = self.cateName;
    vc.courseCategoryId = self.cateId;
    vc.lid = self.lid;
    vc.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)collectTestClick
{
    TestCollectionViewController *vc = [[TestCollectionViewController alloc] init];
    vc.cateName = self.cateName;
    vc.courseCategoryId = self.cateId;
    vc.lid = self.lid;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)recordClick
{
    TestRecordViewController *vc = [[TestRecordViewController alloc] init];
    vc.courseCategoryId = self.cateId;
    vc.lid = self.lid;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
