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
#import "QuestionManager.h"
#import "QuestionTableViewCell.h"
#import "UIUtility.h"
#import "LiveStreamingTableViewCell.h"
#import "CoursecategoryTableViewCell.h"
#import "MainBottomTableViewCell.h"
#import "NewCourseExchangeTableViewCell.h"
#import "MainLivingCourseTableViewCell.h"
#import "CourseraManager.h"
#import "MainVCCourseTableViewCell.h"

@implementation ContentTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
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
            if ([CourseraManager sharedManager].showMore) {
                return [[[[CourseraManager sharedManager] getNotStartLivingCourseArray] objectAtIndex:0] count] + 2;
            }else
            {
                if ([[[[CourseraManager sharedManager] getNotStartLivingCourseArray] objectAtIndex:0] count] < 4 && [[[[CourseraManager sharedManager] getNotStartLivingCourseArray] objectAtIndex:0] count] > 0) {
                    return [[[[CourseraManager sharedManager] getNotStartLivingCourseArray] objectAtIndex:0] count] + 1;
                }else if ([[[[CourseraManager sharedManager] getNotStartLivingCourseArray] objectAtIndex:0] count] == 0) {
                    return 0;
                }
                else
                {
                    return 5;
                }
            }
            
            return count;
            break;
        
        case 3:
            count = [[[CourseraManager sharedManager] getHottestCourseArray] count];
            if (count > 0) {
                return 4;
            }else
            {
                return 0;
            }
            
            break;
            
        case 4:
            if ([[[CourseraManager sharedManager] getMainVCCategoryArray] count] > 0) {
                return 1;
            }else
            {
                return 0;
            }
        case 5:
            count = [[[QuestionManager sharedManager] getMainQuestionInfos] count] + 1;
            break;
        default:
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        
//        static NSString *courseCategoryCellName = @"courseAllCategoryCell";
//        CategoryTableViewCell *cell = (CategoryTableViewCell *)[self getCellWithCellName:courseCategoryCellName inTableView:tableView andCellClass:[CategoryTableViewCell class]];
//        cell.pageType = PageCategory;
//        [cell resetWithCategoryInfos:self.catoryDataSourceArray];
//        return cell;
        
        static NSString *bannerCellName = @"bannerCell";
        BannerTableViewCell *bannerCell = (BannerTableViewCell *)[self getCellWithCellName:bannerCellName inTableView:tableView andCellClass:[BannerTableViewCell class]];
        bannerCell.bannerImgUrlArray = [[ImageManager sharedManager] getBannerImgURLStrings];
        [bannerCell resetSubviews];
        return bannerCell;
        
    }
    
    if (indexPath.section == 1) {
        static NSString *bannerCellName = @"bannerCell";
        BannerTableViewCell *bannerCell = (BannerTableViewCell *)[self getCellWithCellName:bannerCellName inTableView:tableView andCellClass:[BannerTableViewCell class]];
        bannerCell.bannerImgUrlArray = [[ImageManager sharedManager] getBannerImgURLStrings];
        [bannerCell resetSubviews];
        return bannerCell;
    }
    
    // 直播
    if (indexPath.section == 2 && indexPath.row == 0) {
        static NSString *courseTitleCellName = @"liveCourseTitleCell";
        CourseTitleTableViewCell *titleCell = (CourseTitleTableViewCell *)[self getCellWithCellName:courseTitleCellName inTableView:tableView andCellClass:[CourseTitleTableViewCell class]];
        [titleCell resetSubviewsWithTitle:@"近期直播"];
        return titleCell;
    }
    
    if (indexPath.section == 2 && [CourseraManager sharedManager].showMore && indexPath.row == [[[[CourseraManager sharedManager]getNotStartLivingCourseArray] objectAtIndex:0] count] + 1) {
        static NSString *courseTitleCellName = @"courseFootCell";
        NewCourseExchangeTableViewCell *footCell = (NewCourseExchangeTableViewCell *)[self getCellWithCellName:courseTitleCellName inTableView:tableView andCellClass:[NewCourseExchangeTableViewCell class]];
        __weak typeof(self)weakSelf = self;
        footCell.MoreLivingCourseBlock = ^(BOOL showMore) {
            if (weakSelf.moreLivingCourseBlock) {
                weakSelf.moreLivingCourseBlock();
            }
        };
        [footCell resetMoreInfoWithNotTopLine];
        return footCell;
    }
    
    if(indexPath.section == 2 && ![CourseraManager sharedManager].showMore && indexPath.row == 4){
        static NSString *courseTitleCellName = @"courseFootCell";
        NewCourseExchangeTableViewCell *footCell = (NewCourseExchangeTableViewCell *)[self getCellWithCellName:courseTitleCellName inTableView:tableView andCellClass:[NewCourseExchangeTableViewCell class]];
        __weak typeof(self)weakSelf = self;
        footCell.MoreLivingCourseBlock = ^(BOOL showMore) {
            if (weakSelf.moreLivingCourseBlock) {
                weakSelf.moreLivingCourseBlock();
            }
        };
        [footCell resetMoreInfoWithNotTopLine];
        return footCell;
    }
    if (indexPath.section == 2 && indexPath.row != 0) {
        static NSString *courseCellName = @"liveCourseCell";
        
        /*
         //        LiveStreamingTableViewCell * cell = (LiveStreamingTableViewCell *)[self getCellWithCellName:courseCellName inTableView:tableView andCellClass:[LiveStreamingTableViewCell class]];
         //
         //        [cell resetInfoWith:[[[CourseraManager sharedManager]getNotStartLivingCourseArray] objectAtIndex:0]];
         //        __weak typeof(self)weakSelf = self;
         //        cell.clickBlock = ^(NSDictionary *infoDic){
         //            if (weakSelf.clockBlock) {
         //                weakSelf.clockBlock(infoDic);
         //            }
         //        };
         
         */
        __weak typeof(self)weakSelf = self;
        MainLivingCourseTableViewCell * lCell = (MainLivingCourseTableViewCell *)[self getCellWithCellName:courseCellName inTableView:tableView andCellClass:[MainLivingCourseTableViewCell class]];
        [lCell resetCellContent:[[[[CourseraManager sharedManager]getNotStartLivingCourseArray] objectAtIndex:0] objectAtIndex:indexPath.row - 1]];
        lCell.mainCountDownFinishBlock = ^{
            if (weakSelf.mainCountDownBlock) {
                weakSelf.mainCountDownBlock();
            }
        };
        return lCell;
    }
    // 新上课程
    if (indexPath.section == 3 && indexPath.row == 0) {
        static NSString *courseTitleCellName = @"courseTitleCell";
        CourseTitleTableViewCell *titleCell = (CourseTitleTableViewCell *)[self getCellWithCellName:courseTitleCellName inTableView:tableView andCellClass:[CourseTitleTableViewCell class]];
        titleCell.nCourse = YES;
        [titleCell resetSubviewsWithTitle:@"新上课程"];
        return titleCell;
    }
    
    if (indexPath.section == 3 && indexPath.row == 3) {
        static NSString *courseTitleCellName = @"courseFootCell";
        NewCourseExchangeTableViewCell *footCell = (NewCourseExchangeTableViewCell *)[self getCellWithCellName:courseTitleCellName inTableView:tableView andCellClass:[NewCourseExchangeTableViewCell class]];
        __weak typeof(self)weakSelf = self;
        footCell.ExchangeBlock = ^(int number) {
            NSLog(@"**** %d", number);
            if (weakSelf.exchangeNewCourseBlock) {
                weakSelf.exchangeNewCourseBlock();
            }
        };
        [footCell resetCell];
        return footCell;
    }
    
    if (indexPath.section == 3 && indexPath.row != 0 && indexPath.row != 3) {
        static NSString *courseCellName = @"courseCell";
        
        /*
         CoursecategoryTableViewCell *courseCell = (CoursecategoryTableViewCell *)[self getCellWithCellName:courseCellName inTableView:tableView andCellClass:[CoursecategoryTableViewCell class]];
         NSArray *array = [[CourseraManager sharedManager] getHottestCourseArray];
         
         courseCell.courseType = CourseCategoryType_hot;
         [courseCell resetCellContent:[array objectAtIndex:indexPath.row]];
         
         */
        
        CourseTableViewCell *courseCell = (CourseTableViewCell *)[self getCellWithCellName:courseCellName inTableView:tableView andCellClass:[CourseTableViewCell class]];
        NSArray *array = [[CourseraManager sharedManager] getHottestCourseArray];
        
        if (array.count == 0) {
            
        }else{
            NSArray *allCourseInfo = array;
            NSArray *subarray;
            
            if (IS_PAD) {
                if ((indexPath.row) * 3 <= allCourseInfo.count) {
                    if (indexPath.row == 1) {
                        subarray = [allCourseInfo subarrayWithRange:NSMakeRange(0, 3)];
                    }else{
                        subarray = [allCourseInfo subarrayWithRange:NSMakeRange(3*(indexPath.row - 1), 3)];
                    }
                    
                    [courseCell resetCellContentWithThreeCourseInfo:subarray];
                }else{
                    if (indexPath.row == 1) {
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
                            subarray = [allCourseInfo subarrayWithRange:NSMakeRange(3*(indexPath.row - 1), 2)];
                            [courseCell resetCellContentWithThree_TwoCourseInfo:subarray];
                        }else
                        {
                            subarray = [allCourseInfo subarrayWithRange:NSMakeRange(3*(indexPath.row - 1), 1)];
                            [courseCell resetCellContentWithThree_OneCourseInfo:subarray];
                        }
                    }
                }
            }else
            {
                if ((indexPath.row) * 2 <= allCourseInfo.count) {
                    if (indexPath.row == 1) {
                        subarray = [allCourseInfo subarrayWithRange:NSMakeRange(0, 2)];
                    }else{
                        subarray = [allCourseInfo subarrayWithRange:NSMakeRange(2*(indexPath.row - 1), 2)];
                    }
                    
                    [courseCell resetCellContentWithTwoCourseInfo:subarray];
                }else{
                    if (indexPath.row == 1) {
                        subarray = [allCourseInfo subarrayWithRange:NSMakeRange(0, 1)];
                    }else{
                        subarray = [allCourseInfo subarrayWithRange:NSMakeRange(2*(indexPath.row - 1), 1)];
                    }
                    [courseCell resetCellContentWithOneCourseInfo:subarray];
                }
            }
            
        }
        
        return courseCell;
    }
    
    if (indexPath.section == 4) {
        static NSString *mainCourseCellName = @"mainCourseCellName";
        
        MainVCCourseTableViewCell *courseCell = (MainVCCourseTableViewCell *)[self getCellWithCellName:mainCourseCellName inTableView:tableView andCellClass:[MainVCCourseTableViewCell class]];
        
        [courseCell resetInfo];
        __weak typeof(self)weakSelf = self;
        courseCell.MoreCourseClickBlock = ^{
            NSLog(@"更多课程");
            if (weakSelf.mainMoreCourseBlock) {
                weakSelf.mainMoreCourseBlock();
            }
        };
        
        return courseCell;
    }
    
    if (indexPath.section == 5 && indexPath.row == 0) {
        static NSString *courseTitleCellName = @"courseTitleCell";
        CourseTitleTableViewCell *titleCell = (CourseTitleTableViewCell *)[self getCellWithCellName:courseTitleCellName inTableView:tableView andCellClass:[CourseTitleTableViewCell class]];
        [titleCell resetSubviewsWithTitle:@"答疑中心"];
        return titleCell;
    }
    
    if (indexPath.section == 5 && indexPath.row != 0) {
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
