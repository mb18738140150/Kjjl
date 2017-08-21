//
//  DownloadedTableViewDataSource.m
//  Accountant
//
//  Created by aaa on 2017/3/10.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DownloadedTableViewDataSource.h"
#import "DownloadedCourseTableViewCell.h"
#import "CommonMacro.h"
#import "UIUtility.h"

@implementation DownloadedTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.downloadedCourseInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownloadedCourseTableViewCell *cell = (DownloadedCourseTableViewCell *)[UIUtility getCellWithCellName:@"downloadedCourseCell" inTableView:tableView andCellClass:[DownloadedCourseTableViewCell class]];
    NSDictionary *dic = [self.downloadedCourseInfoArray objectAtIndex:indexPath.row];
    int count = 0;
    for (NSDictionary *chapDic in [dic objectForKey:kCourseChapterInfos]) {
        for (NSDictionary *videoDic in [chapDic objectForKey:kChapterVideoInfos]) {
            count ++;
        }
    }
    [cell resetCellContent:[self.downloadedCourseInfoArray objectAtIndex:indexPath.row]];
    cell.courseCountLabel.text = [NSString stringWithFormat:@"%d 个视频",count];
    return cell;
}

@end
