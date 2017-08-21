//
//  DownloadingTableViewDataSource.h
//  Accountant
//
//  Created by aaa on 2017/3/10.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DownloadingTableViewDataSource : NSObject<UITableViewDataSource>

@property (nonatomic,strong) NSArray            *downloadingVideoInfos;

@end
