//
//  SearchViewController.m
//  Accountant
//
//  Created by aaa on 2017/6/26.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "SearchViewController.h"

#import "SubCategoryCollectionViewCell.h"
#import "SimulateresultCollectionReusableView.h"
#import "SearchReaultViewController.h"
#import "CourseModuleProtocol.h"
#import "CourseraManager.h"

#import "HYSegmentedControl.h"
#define kSegmentHeight 42
@interface SearchViewController ()<UITextFieldDelegate, HYSegmentedControlDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,CourseModule_VideoCourseProtocol, CourseModule_LiveStreamProtocol, CourseModule_HotSearchProtocol>

@property (nonatomic, strong)UITextField *searchTF;
@property (nonatomic, strong)HYSegmentedControl * segmentC;

@property (nonatomic, strong)UICollectionView * collectionView;

@property (nonatomic, strong)NSMutableArray * dataArray;

//@property (nonatomic, strong)NSMutableArray * videoDataArray;
//@property (nonatomic, strong)NSMutableArray * livingArray;
//@property (nonatomic, strong)NSMutableArray * questionArray;
//@property (nonatomic, strong)NSMutableArray * subjectArray;

@property (nonatomic, strong)NSString * type;
@property (nonatomic, assign)int index;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self reloadDataArray];
    
    [self navigationViewSetup];
    [self segmentSetup];
    [self contentViewSetup];
    
}

- (void)reloadDataArray
{
    self.dataArray = [NSMutableArray array];
    
    NSMutableDictionary * videoDic = [NSMutableDictionary dictionary];
    [videoDic setObject:[NSMutableArray array] forKey:@"hot"];
    [videoDic setObject:[NSMutableArray array] forKey:@"history"];
    
    NSMutableDictionary * livingDic = [NSMutableDictionary dictionary];
    [videoDic setObject:[NSMutableArray array] forKey:@"hot"];
    [videoDic setObject:[NSMutableArray array] forKey:@"history"];
    
    NSMutableDictionary * questionDic = [NSMutableDictionary dictionary];
    [videoDic setObject:[NSMutableArray array] forKey:@"hot"];
    [videoDic setObject:[NSMutableArray array] forKey:@"history"];
    
    NSMutableDictionary * subjectDic = [NSMutableDictionary dictionary];
    [videoDic setObject:[NSMutableArray array] forKey:@"hot"];
    [videoDic setObject:[NSMutableArray array] forKey:@"history"];
    
    [self.dataArray addObject:videoDic];
    [self.dataArray addObject:livingDic];
//    [self.dataArray addObject:questionDic];
//    [self.dataArray addObject:subjectDic];
    
    [[CourseraManager sharedManager]didRequestHotSearchCourseWithNotifiedObject:self];
    
}

- (void)requestWithKeyword:(NSString *)keyword
{
    if (self.index == 0) {
        [[CourseraManager sharedManager] didRequestSearchVideoCoursesWithkeyWord:keyword NotifiedObject:self];
    }else
    {
        [[CourseraManager sharedManager] didRequestSearchliveStreamCoursesWithkeyWord:keyword NotifiedObject:self];
    }
}

- (void)didRequestHotSearchCourseSuccessed
{
    NSMutableDictionary * infoDic = [[CourseraManager sharedManager]getHotSearchCourseArray];
    NSMutableArray * HotVideoArr = [infoDic objectForKey:@"VideoData"];
    NSMutableArray * hotLivingArr = [infoDic objectForKey:@"LivingStreamData"];
    
    NSMutableDictionary * videoDic = [self.dataArray objectAtIndex:0];
    [videoDic setValue:HotVideoArr forKeyPath:@"hot"];
    
    NSMutableDictionary * livingDic = [self.dataArray objectAtIndex:1];
    [livingDic setValue:hotLivingArr forKeyPath:@"hot"];
    
    [self.collectionView reloadData];
}
- (void)didRequestHotSearchCourseFailed
{
    
}

- (void)didRequestLiveStreamSuccessed
{
    NSArray *dataArray = [[CourseraManager sharedManager] getSearchLiveStreamArray];
    if (dataArray.count == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无搜索结果" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self searchDBWith:self.searchTF.text];
    
    SearchReaultViewController * vc = [[SearchReaultViewController alloc]init];
    vc.searchResultType = SearchResultType_livingStream;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)didRequestLiveStreamFailed
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无搜索结果" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)didRequestVideoCourseSuccessed
{
    NSArray *dataArray = [[CourseraManager sharedManager] getSearchVideoCourseArray];
    if (dataArray.count == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无搜索结果" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    [self searchDBWith:self.searchTF.text];
    SearchReaultViewController * vc = [[SearchReaultViewController alloc]init];
    vc.searchResultType = SearchResultType_videoCourse;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didRequestVideoCourseFailed
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无搜索结果" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.translucent = NO;
    
    UINavigationBar * bar = self.navigationController.navigationBar;
    [bar setShadowImage:[UIImage imageNamed:@"tm"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tm"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView = [self prepareTitleView];
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"public-返回"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
}
- (void)backAction:(UIButton *)button
{
    [self.searchTF resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)segmentSetup
{
    self.type = @"视频课";
    self.index = 0;
    self.segmentC = [[HYSegmentedControl alloc] initWithOriginY:0 Titles:@[@"视频课", @"直播课"] delegate:self];
    [self.view addSubview:self.segmentC];
    [self hySegmentedControlSelectAtIndex:self.index];
}
- (void)contentViewSetup
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kSegmentHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kSegmentHeight) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = NO;
    [self.collectionView registerClass:[SubCategoryCollectionViewCell class] forCellWithReuseIdentifier:@"SubCategoryCollectionViewCellID"];
    
    [self.collectionView registerClass:[SimulateresultCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simulateresultReusableViewid"];
    self.collectionView.backgroundColor = kBackgroundGrayColor;
    [self.view addSubview:self.collectionView];
}

- (UIView *)prepareTitleView
{
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 7, kScreenWidth - 100, 35)];
    titleView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    titleView.layer.cornerRadius = titleView.frame.size.height / 2;
    titleView.layer.masksToBounds = YES;
    titleView.layer.borderWidth = 0.5;
    titleView.layer.borderColor = kCommonMainTextColor_200.CGColor;
    
    self.searchTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, titleView.hd_width - 50, titleView.hd_height)];
    self.searchTF.textColor = kCommonMainTextColor_50;
    self.searchTF.placeholder = @"搜视频课、直播课";
    self.searchTF.font = kMainFont;
    [titleView addSubview:self.searchTF];
    self.searchTF.returnKeyType = UIReturnKeyDone;
    self.searchTF.delegate = self;
    
    UIButton * searchBT = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBT.frame = CGRectMake(titleView.hd_width - 50, 0, 50, titleView.hd_height);
    [searchBT setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBT.titleLabel.font = kMainFont;
    searchBT.backgroundColor = UIRGBColor(29, 28, 224);
    [titleView addSubview:searchBT];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:searchBT.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(searchBT.hd_height / 2, searchBT.hd_height / 2)];
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.frame = searchBT.bounds;
    layer.path = path.CGPath;
    searchBT.layer.mask = layer;
    
    [searchBT addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    
    return titleView;
}

- (void)searchClick
{
    [self.searchTF resignFirstResponder];
    if (self.searchTF.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"搜索内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSLog(@"%@", self.searchTF.text);
    
    [self requestWithKeyword:self.searchTF.text];
}

- (void)searchDBWith:(NSString *)content
{
    NSDate *date = [NSDate date];
    NSDictionary * dic = @{@"title":content, @"type":self.type, @"time":@([date timeIntervalSince1970])};
    [[DBManager sharedManager] saveSearchContent:dic];
    NSArray * historyArr = [[DBManager sharedManager] getSearchContentWithType:self.type];
    if (historyArr.count >= 6) {
        [[DBManager sharedManager] deleteEarliestSrarchContent:self.type];
    }
    [self hySegmentedControlSelectAtIndex:self.index];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        NSMutableDictionary * dic = [self.dataArray objectAtIndex:self.index];
        return [[dic objectForKey:@"hot"] count];
    }else
    {
        NSMutableDictionary * dic = [self.dataArray objectAtIndex:self.index];
        
        if ([[dic objectForKey:@"history"] count] == 0) {
            return 0;
        }
        return [[dic objectForKey:@"history"] count] + 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SubCategoryCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SubCategoryCollectionViewCellID" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        NSDictionary * dic = [self.dataArray objectAtIndex:self.index];
        NSArray * array = [dic objectForKey:@"hot"];
        [cell resetViewWithDic:[array objectAtIndex:indexPath.row] position:1];
    }else
    {
        NSDictionary * dic = [self.dataArray objectAtIndex:self.index];
        NSArray * array = [dic objectForKey:@"history"];
        if (indexPath.row < array.count) {
            [cell resetViewWithDic:[array objectAtIndex:indexPath.row] position:0];
        }
        if (indexPath.row == array.count) {
            [cell resetViewWithDic:[NSDictionary dictionary] position:0];
            cell.titleLabel.textAlignment = 1;
            cell.titleLabel.text = @"清空历史搜索";
        }
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * reusableView = [[UICollectionReusableView alloc]init];
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            SimulateresultCollectionReusableView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
            [headView resetWithTitle:@"热门搜索"];
            reusableView = headView;
        }else
        {
            SimulateresultCollectionReusableView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"simulateresultReusableViewid" forIndexPath:indexPath];
            [headView resetWithTitle:@"历史搜索"];
            reusableView = headView;
        }
    }
    reusableView.backgroundColor = kBackgroundGrayColor;
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenWidth / 3, 40);
    }else
    {
        return CGSizeMake(kScreenWidth, 40);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, 40);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSDictionary * dic = [self.dataArray objectAtIndex:self.index];
        NSArray * array = [dic objectForKey:@"history"];
        
        if (indexPath.row == array.count) {
            if ([[DBManager sharedManager] deleteSearchType:self.type]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hySegmentedControlSelectAtIndex:self.index];
                });
            }
            return;
        }
        NSDictionary *infoDic = [array objectAtIndex:indexPath.row];
        NSString * title = [infoDic objectForKey:@"title"];
        self.searchTF.text = [infoDic objectForKey:@"title"];
        [self requestWithKeyword:title];
    }else
    {
        NSDictionary * dic = [self.dataArray objectAtIndex:self.index];
        NSArray * array = [dic objectForKey:@"hot"];
        NSDictionary * infoDic = array[indexPath.item];
        self.searchTF.text = [infoDic objectForKey:kCourseName];
        [self requestWithKeyword:[infoDic objectForKey:kCourseName]];
    }
}

#pragma mark - HYSegmentedControl 代理方法
- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    self.index = index;
    switch (index) {
        case 0:{
            self.type = @"视频课";
        }
            break;
        case 1:
            self.type = @"直播课";
            break;
        case 2:
            self.type = @"问题";
            break;
        case 3:
            self.type = @"题目";
            break;
            
        default:
            break;
    }
    
    NSArray * historyArr = [[DBManager sharedManager] getSearchContentWithType:self.type];
    NSMutableDictionary * videoDic = [self.dataArray objectAtIndex:index];
    [videoDic setValue:historyArr forKeyPath:@"history"];
    
    [self.collectionView reloadData];
}

#pragma mark - textFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
