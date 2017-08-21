//
//  ContentTableViewDataSource.m
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "ContentTableViewDataSource.h"
#import "BannerTableViewCell.h"
#import "CategoryTableViewCell.h"
#import "CourseTableViewCell.h"
#import "CourseTitleTableViewCell.h"
#import "ImageManager.h"
#import "CourseraManager.h"
#import "QuestionTableViewCell.h"
#import "UIUtility.h"
#import "LiveStreamingTableViewCell.h"
#import "CoursecategoryTableViewCell.h"
#import "MainBottomTableViewCell.h"

@implementation ContentTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section) {
        case 0:
            count = 1;
            break;
        
        case 1:
            count = 0;
            break;
        
        case 2:
            if ([[[CourseraManager sharedManager] getNotStartLivingCourseArray] count]) {
                count = [[[CourseraManager sharedManager] getNotStartLivingCourseArray] count] + 1;
            }
            return count;
            break;
        
        case 3:
            count = [[[CourseraManager sharedManager] getHottestCourseArray] count] - 7;
            break;
        default:
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        static NSString *courseCategoryCellName = @"courseAllCategoryCell";
        CategoryTableViewCell *cell = (CategoryTableViewCell *)[self getCellWithCellName:courseCategoryCellName inTableView:tableView andCellClass:[CategoryTableViewCell class]];
        cell.pageType = PageMain;
        [cell resetWithCategoryInfos:self.catoryDataSourceArray];
        return cell;
    }
    
    if (indexPath.section == 1) {
        static NSString *bannerCellName = @"bannerCell";
        BannerTableViewCell *bannerCell = (BannerTableViewCell *)[self getCellWithCellName:bannerCellName inTableView:tableView andCellClass:[BannerTableViewCell class]];
        bannerCell.bannerImgUrlArray = [[ImageManager sharedManager] getBannerImgURLStrings];
        [bannerCell resetSubviews];
        return bannerCell;
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        static NSString *courseTitleCellName = @"liveCourseTitleCell";
        CourseTitleTableViewCell *titleCell = (CourseTitleTableViewCell *)[self getCellWithCellName:courseTitleCellName inTableView:tableView andCellClass:[CourseTitleTableViewCell class]];
        [titleCell resetSubviewsWithTitle:@"直播大厅"];
        return titleCell;
    }
    
    if (indexPath.section == 2 && indexPath.row != 0) {
        static NSString *courseCellName = @"liveCourseCell";
        LiveStreamingTableViewCell * cell = (LiveStreamingTableViewCell *)[self getCellWithCellName:courseCellName inTableView:tableView andCellClass:[LiveStreamingTableViewCell class]];
        
        [cell resetInfoWith:[[CourseraManager sharedManager] getNotStartLivingCourseArray]];
        
        cell.clickBlock = ^(NSDictionary *infoDic){
            if (self.clockBlock) {
                self.clockBlock(infoDic);
            }
        };
//        cell.morelivingBlock = ^(){
//            if (self.MoreBlock) {
//                self.MoreBlock();
//            }
//        };
        
        return cell;
    }
    
    
    if (indexPath.section == 3 && indexPath.row == 0) {
        static NSString *courseTitleCellName = @"courseTitleCell";
        CourseTitleTableViewCell *titleCell = (CourseTitleTableViewCell *)[self getCellWithCellName:courseTitleCellName inTableView:tableView andCellClass:[CourseTitleTableViewCell class]];
        [titleCell resetSubviewsWithTitle:@"热门课程"];
        return titleCell;
    }
    
    if (indexPath.section == 3 && indexPath.row != 0) {
        static NSString *courseCellName = @"courseCell";
        CoursecategoryTableViewCell *courseCell = (CoursecategoryTableViewCell *)[self getCellWithCellName:courseCellName inTableView:tableView andCellClass:[CoursecategoryTableViewCell class]];
        NSArray *array = [[CourseraManager sharedManager] getHottestCourseArray];
        
        courseCell.courseType = CourseCategoryType_hot;
        [courseCell resetCellContent:[array objectAtIndex:indexPath.row]];
        
        return courseCell;
    }
    
    if (indexPath.section == 4 && indexPath.row == 0) {
        static NSString *courseTitleCellName = @"courseTitleCell";
        CourseTitleTableViewCell *titleCell = (CourseTitleTableViewCell *)[self getCellWithCellName:courseTitleCellName inTableView:tableView andCellClass:[CourseTitleTableViewCell class]];
        [titleCell resetSubviewsWithTitle:@"答疑中心"];
        return titleCell;
    }
    
    if (indexPath.section == 4 && indexPath.row != 0) {
        static NSString *cellName = @"questionCell";
        QuestionTableViewCell *cell = (QuestionTableViewCell *)[UIUtility getCellWithCellName:cellName inTableView:tableView andCellClass:[QuestionTableViewCell class]];
        cell.isCalculatedDate = NO;
        cell.isShowFullContent = NO;
        [cell resetCellWithInfo:[self.mainQuestionArray objectAtIndex:indexPath.row-1]];
        return cell;
    }
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.textLabel.text = @"1111";
    return cell;
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

@end
