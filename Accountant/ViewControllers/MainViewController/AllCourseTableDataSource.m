//
//  AllCourseTableDataSource.m
//  Accountant
//
//  Created by aaa on 2017/3/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "AllCourseTableDataSource.h"
#import "CourseraManager.h"
#import "CourseTableViewCell.h"
#import "CommonMacro.h"

@interface AllCourseTableDataSource ()


@end

@implementation AllCourseTableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSArray *allCourseInfo = [[CourseraManager sharedManager] getAllCourseArray];
    NSUInteger courseCount = [[[self.courseListArray objectAtIndex:section] objectForKey:kCourseCategorySecondCourseInfos] count];
    if (courseCount%2 == 0) {
        return courseCount/2;
    }else{
        return courseCount/2 + 1;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *courseCellName = @"courseCell";
    CourseTableViewCell *courseCell = (CourseTableViewCell *)[self getCellWithCellName:courseCellName inTableView:tableView andCellClass:[CourseTableViewCell class]];
    NSArray *array = [[self.courseListArray objectAtIndex:indexPath.section] objectForKey:kCourseCategorySecondCourseInfos];
    if (array.count == 0) {
        
    }else{
        NSArray *allCourseInfo = array;
        NSArray *subarray;
        if ((indexPath.row+1) * 2 <= allCourseInfo.count) {
            if (indexPath.row == 0) {
                subarray = [allCourseInfo subarrayWithRange:NSMakeRange(0, 2)];
            }else{
                subarray = [allCourseInfo subarrayWithRange:NSMakeRange(2*indexPath.row, 2)];
            }
            
            [courseCell resetCellContentWithTwoCourseInfo:subarray];
        }else{
            if (indexPath.row == 0) {
                subarray = [allCourseInfo subarrayWithRange:NSMakeRange(0, 1)];
            }else{
                subarray = [allCourseInfo subarrayWithRange:NSMakeRange(2*indexPath.row, 1)];
            }
            [courseCell resetCellContentWithOneCourseInfo:subarray];
        }
    }
    
    return courseCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.courseListArray.count;
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
