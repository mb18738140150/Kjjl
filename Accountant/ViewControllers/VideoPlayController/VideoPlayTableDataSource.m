//
//  VideoPlayTableDataSource.m
//  Accountant
//
//  Created by aaa on 2017/3/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "VideoPlayTableDataSource.h"
#import "CourseraManager.h"
#import "CommonMacro.h"
#import "UIMacro.h"
#import "CategoryDetailTableViewCell.h"
#import "CategorySectionHeadView.h"

@interface VideoPlayTableDataSource ()



@end

@implementation VideoPlayTableDataSource

- (NSMutableArray *)statusArray
{
    if (!_statusArray) {
        _statusArray = [NSMutableArray array];
    }
    return _statusArray;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (((NSNumber *)self.statusArray[section]).integerValue == MFoldingSectionStateShow) {
        NSArray *array = [self.chapterVideoInfoArray objectAtIndex:section];
        return array.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"playVideoTitleCell";
    CategoryDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    NSInteger section = indexPath.section;
    NSArray *videoArray = [self.chapterVideoInfoArray objectAtIndex:section];
    NSDictionary *videoInfo = [videoArray objectAtIndex:indexPath.row];
    cell.frame = tableView.bounds;
    cell.cellType = CellType_video;
    if (indexPath.row == videoArray.count - 1) {
        [cell resetisLast:YES withDicInfo:videoInfo];
    }else
    {
        [cell resetisLast:NO withDicInfo:videoInfo];
    }
    
    if (indexPath.section == self.selectedSection && self.selectedRow == indexPath.row) {
        cell.titleLabel.textColor = kCommonMainColor;
    }else
    {
        cell.titleLabel.textColor = kCommonMainTextColor_50;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.chapterArray.count;
}

@end
