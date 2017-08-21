//
//  HistoryViewTableDataSource.m
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "HistoryViewTableDataSource.h"
#import "UIUtility.h"
#import "HistoryTableViewCell.h"


@implementation HistoryViewTableDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryTableViewCell *cell = (HistoryTableViewCell *)[UIUtility getCellWithCellName:@"historyCell" inTableView:tableView andCellClass:[HistoryTableViewCell class]];
    NSDictionary *dic = [self.historyInfos objectAtIndex:indexPath.section];
    NSArray *array = [dic objectForKey:kHistoryInfos];
    NSDictionary *info = [array objectAtIndex:indexPath.row];
    [cell resetCellWithInfo:info];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.historyInfos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = [self.historyInfos objectAtIndex:section];
    NSArray *array = [dic objectForKey:kHistoryInfos];
    return array.count;
}

@end
