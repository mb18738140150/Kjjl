//
//  MainVCCourseTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/10/14.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MainVCCourseTableViewCell.h"
#import "HYSegmentedControl.h"
#import "CourseraManager.h"
#import "CourseTableViewCell.h"

#define kSegmentHeight 42
@interface MainVCCourseTableViewCell ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray * dataSource;
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)HYSegmentedControl *segmentC;
@property (nonatomic, assign)int index;

@property (nonatomic, strong)UIImageView * goImageView;

@property (nonatomic, strong)NSString * categoryName;
@property (nonatomic, assign)int categoryId;

@end

@implementation MainVCCourseTableViewCell

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
//kCellHeightOfCourseTitle
- (void)resetInfo
{
    [self.contentView removeAllSubviews];
    [self getAllDataSourseArray];
    self.segmentC = [[HYSegmentedControl alloc] initWithOriginY:0 Titles:@[@"基础",@"出纳",@"会计",@"税务",@"考证"] delegate:self drop:NO color:UIRGBColor(250, 79, 13)];
    [self.contentView addSubview:self.segmentC];
    
    if (IS_PAD) {
        self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, kSegmentHeight, kScreenWidth, kCellHeightOfCourse_IPAD * 2 + 30) style:UITableViewStylePlain];
    }else
    {
        self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, kSegmentHeight, kScreenWidth, kCellHeightOfCourse * 2 + 30) style:UITableViewStylePlain];
    }
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.contentView addSubview:self.tableview];
    self.tableview.scrollEnabled = NO;
    
    
    UIView * linView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableview.frame), kScreenWidth, 1)];
    linView.backgroundColor = UIRGBColor(230, 230, 230);
    [self.contentView addSubview:linView];
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(linView.frame), kScreenWidth, kCellHeightOfCourseTitle - 1)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    self.liveLB = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 35, 10, 70, 20)];
    self.liveLB.text = @"查看更多";
    self.liveLB.font = kMainFont;
    self.liveLB.textColor = kCommonMainTextColor_100;
    self.liveLB.textAlignment = 1;
    self.liveLB.userInteractionEnabled = YES;
    [bottomView addSubview:self.liveLB];
    
    self.goImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.liveLB.frame), 13, 15, 14)];
    self.goImageView.image = [UIImage imageNamed:@"main_question_trankle"];
    [bottomView addSubview:self.goImageView];
    self.goImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * moreTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreCourseClick)];
    [bottomView addGestureRecognizer:moreTap];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *courseCellName = @"courseCell";
    CourseTableViewCell *courseCell = (CourseTableViewCell *)[self getCellWithCellName:courseCellName inTableView:tableView andCellClass:[CourseTableViewCell class]];
    
    NSArray *array = self.dataSource[_index];
    if (array.count == 0) {
        
    }else{
        NSArray *allCourseInfo = array;
        NSArray *subarray;
        if (IS_PAD) {
            if ((indexPath.row) * 3 <= allCourseInfo.count) {
                if (indexPath.row == 0) {
                    subarray = [allCourseInfo subarrayWithRange:NSMakeRange(0, 3)];
                }else{
                    subarray = [allCourseInfo subarrayWithRange:NSMakeRange(3*(indexPath.row), 3)];
                }
                
                [courseCell resetCellContentWithThreeCourseInfo:subarray];
            }else{
                if (indexPath.row == 0) {
                    if (allCourseInfo.count == 2) {
                        subarray = [allCourseInfo subarrayWithRange:NSMakeRange(0, 2)];
                        [courseCell resetCellContentWithThree_TwoCourseInfo:subarray];
                    }else
                    {
                        subarray = [allCourseInfo subarrayWithRange:NSMakeRange(0, 1)];
                        [courseCell resetCellContentWithThree_OneCourseInfo:subarray];
                    }
                    
                }else{
                    int leaveCount = allCourseInfo.count - (indexPath.row - 1) * 3;
                    if (leaveCount % 3 == 2) {
                        subarray = [allCourseInfo subarrayWithRange:NSMakeRange(3*(indexPath.row), 2)];
                        [courseCell resetCellContentWithThree_TwoCourseInfo:subarray];
                    }else
                    {
                        subarray = [allCourseInfo subarrayWithRange:NSMakeRange(3*(indexPath.row), 1)];
                        [courseCell resetCellContentWithThree_OneCourseInfo:subarray];
                    }
                }
            }
        }else
        {
            if ((indexPath.row) * 2 <= allCourseInfo.count) {
                if (indexPath.row == 0) {
                    subarray = [allCourseInfo subarrayWithRange:NSMakeRange(0, 2)];
                }else{
                    subarray = [allCourseInfo subarrayWithRange:NSMakeRange(2*(indexPath.row), 2)];
                }
                
                [courseCell resetCellContentWithTwoCourseInfo:subarray];
            }else{
                if (indexPath.row == 0) {
                    subarray = [allCourseInfo subarrayWithRange:NSMakeRange(0, 1)];
                }else{
                    subarray = [allCourseInfo subarrayWithRange:NSMakeRange(2*(indexPath.row), 1)];
                }
                [courseCell resetCellContentWithOneCourseInfo:subarray];
            }
            
        }
        
    }
    
    return courseCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_PAD) {
        return  kCellHeightOfCourse_IPAD + 15;
    }else
    {
        return  kCellHeightOfCourse + 15;
    }
}

- (void)moreCourseClick
{
    NSDictionary *dic = @{kCourseCategoryName:self.categoryName,
                          kCourseCategoryId:@(self.categoryId)};
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfCategoryPageCategoryClick object:dic];
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
#pragma mark - HYSegmentedControl 代理方法
- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    self.index = (int )index;
    
    NSDictionary * infoDic = [[[CourseraManager sharedManager] getMainVCCategoryArray] objectAtIndex:index];
    self.categoryName = [infoDic objectForKey:kCourseCategoryName];
    self.categoryId = [[infoDic objectForKey:kCourseCategoryId] intValue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableview reloadData];
    });
}

- (void)getAllDataSourseArray
{
    for (NSDictionary * dic in [[CourseraManager sharedManager] getMainVCCategoryArray]) {
        
        NSMutableArray * dataArr = [NSMutableArray array];
        
        NSArray * courseSecondArr = [dic objectForKey:kCourseCategoryCourseInfos];
        for (NSDictionary * secondDic in courseSecondArr) {
            NSArray * courseArr = [secondDic objectForKey:kCourseCategorySecondCourseInfos];
            for (NSDictionary * courseDic in courseArr) {
                [dataArr addObject:courseDic];
            }
        }
        [self.dataSource addObject:dataArr];
    }
   
    NSDictionary * infoDic = [[[CourseraManager sharedManager] getMainVCCategoryArray] objectAtIndex:0];
    self.categoryName = [infoDic objectForKey:kCourseCategoryName];
    self.categoryId = [[infoDic objectForKey:kCourseCategoryId] intValue];
    
}

@end
