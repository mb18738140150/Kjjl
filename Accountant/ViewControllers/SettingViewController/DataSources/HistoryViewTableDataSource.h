//
//  HistoryViewTableDataSource.h
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HistoryViewTableDataSource : NSObject<UITableViewDataSource>

@property (nonatomic,strong) NSArray            *historyInfos;

@end
