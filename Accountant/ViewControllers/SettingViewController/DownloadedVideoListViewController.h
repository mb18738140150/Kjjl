//
//  DownloadedVideoListViewController.h
//  Accountant
//
//  Created by 阴天翔 on 2017/3/12.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface DownloadedVideoListViewController : ViewController

@property (nonatomic,copy) NSDictionary             *courseInfoDic;
@property (nonatomic, assign)BOOL isPresent;


- (void)refreshTables;

@end
