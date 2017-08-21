//
//  SettingViewTableDataSource.m
//  Accountant
//
//  Created by aaa on 2017/3/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "SettingViewTableDataSource.h"
#import "UIUtility.h"
#import "UserInfoViewCell.h"
#import "UserManager.h"
#import "SettingTableViewCell.h"
#define kSettingCellID @"SettingTableViewCellID"

@implementation SettingViewTableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    switch (section) {
        case 0:
            return 1;
            break;
        
        case 1:
            return 6;
            break;
            
        case 2:
            return 0;
            break;
            
        default:
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *infoCellName = @"infoCell";
        UserInfoViewCell *cell = (UserInfoViewCell *)[UIUtility getCellWithCellName:infoCellName inTableView:tableView andCellClass:[UserInfoViewCell class]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell resetCellWithInfo:[[UserManager sharedManager] getUserInfos]];
        return cell;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCellID forIndexPath:indexPath];
        cell.iconImageView.image = [UIImage imageNamed:@"main-icon1"];
        cell.titleLB.text = @"下载中心";
        
        return cell;
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCellID forIndexPath:indexPath];
        cell.iconImageView.image = [UIImage imageNamed:@"main-icon3"];
        cell.titleLB.text = @"答疑";
        return cell;
        
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCellID forIndexPath:indexPath];
        cell.iconImageView.image = [UIImage imageNamed:@"main-icon5"];
        cell.titleLB.text = @"我的收藏";
        return cell;
        
    }
    if (indexPath.section == 1 && indexPath.row == 3) {
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCellID forIndexPath:indexPath];
        cell.iconImageView.image = [UIImage imageNamed:@"main-icon6"];
        cell.titleLB.text = @"学习记录";
        return cell;
        
    }
    if (indexPath.section == 1 && indexPath.row == 4) {
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCellID forIndexPath:indexPath];
        cell.iconImageView.image = [UIImage imageNamed:@"main-icon7-拷贝"];
        cell.titleLB.text = @"笔记";
        return cell;
        
    }
    
    if (indexPath.section == 1 && indexPath.row == 5) {
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCellID forIndexPath:indexPath];
        cell.iconImageView.image = [UIImage imageNamed:@"main-icon7"];
        cell.titleLB.text = @"设置";
        return cell;
        
    }
    
    if (indexPath.section == 2) {
        static NSString *logoutCellName = @"logoutCell";
        UITableViewCell *cell = [UIUtility getCellWithCellName:logoutCellName inTableView:tableView andCellClass:[UITableViewCell class]];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

@end
