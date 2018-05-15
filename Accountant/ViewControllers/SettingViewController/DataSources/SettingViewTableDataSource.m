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
#import "CategoryTableViewCell.h"

#define kSettingCellID @"SettingTableViewCellID"

@implementation SettingViewTableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    switch (section) {
        case 0:
            return 2;
            break;
        
        case 1:
            return 1;
            break;
            
        case 2:
        {
            if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
                return 3;
            }else
            {
                return 2;
            }
        }
            return 3;
            break;
        case 3:
            return 2;
            break;
        case 4:
            return 1;
            break;
            
        default:
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        static NSString *infoCellName = @"infoCell";
        UserInfoViewCell *cell = (UserInfoViewCell *)[UIUtility getCellWithCellName:infoCellName inTableView:tableView andCellClass:[UserInfoViewCell class]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell resetCellWithInfo:[[UserManager sharedManager] getUserInfos]];
        return cell;
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCellID forIndexPath:indexPath];
        NSDictionary * infoDic = self.dataSourceArray[indexPath.section][indexPath.row - 1];
        [cell resetMemberWithInfo:infoDic andHaveNewActivty:NO];
        __weak typeof(self)weakSelf = self;
        cell.upgradeMemberLevelBlock = ^{
            if (weakSelf.upgradeMemberLevelBlock) {
                weakSelf.upgradeMemberLevelBlock();
            }
        };
        return cell;
    }
    
    if (indexPath.section == 1) {
        static NSString *courseCategoryCellName = @"courseAllCategoryCell";
        CategoryTableViewCell *cell = (CategoryTableViewCell *)[self getCellWithCellName:courseCategoryCellName inTableView:tableView andCellClass:[CategoryTableViewCell class]];
        cell.pageType = PageMain;
        [cell resetMainCategoryInfos:self.catoryDataSourceArray];
        return cell;
    }
    
    if (indexPath.section == 2 ) {
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCellID forIndexPath:indexPath];
        NSDictionary * infoDic = [NSDictionary dictionary];
        if ([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled]) {
            infoDic = self.dataSourceArray[indexPath.section - 1][indexPath.row];
        }else
        {
            infoDic = self.dataSourceArray[indexPath.section - 1][indexPath.row + 1];
        }
        [cell resetcellWithInfo:infoDic andHaveNewActivty:NO];
        return cell;
    }
    if (indexPath.section == 3) {
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCellID forIndexPath:indexPath];
        NSDictionary * infoDic = self.dataSourceArray[indexPath.section - 1][indexPath.row];
        [cell resetcellWithInfo:infoDic andHaveNewActivty:NO];
        return cell;
    }
    if (indexPath.section == 4) {
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCellID forIndexPath:indexPath];
        NSDictionary * infoDic = self.dataSourceArray[indexPath.section - 1][indexPath.row];
        [cell resetcellWithInfo:infoDic andHaveNewActivty:NO];
        return cell;
        
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
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
