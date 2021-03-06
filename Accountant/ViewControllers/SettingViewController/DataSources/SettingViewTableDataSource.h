//
//  SettingViewTableDataSource.h
//  Accountant
//
//  Created by aaa on 2017/3/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SettingViewTableDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, copy)void(^upgradeMemberLevelBlock)();

@property (nonatomic,weak) NSArray              *catoryDataSourceArray;

@property (nonatomic, weak)NSArray              *dataSourceArray;

@end
