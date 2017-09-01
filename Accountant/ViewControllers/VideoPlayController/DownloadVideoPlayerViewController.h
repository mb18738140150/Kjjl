//
//  DownloadVideoPlayerViewController.h
//  Accountant
//
//  Created by 阴天翔 on 2017/3/12.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadVideoPlayerViewController : UIViewController

@property (nonatomic,copy) NSDictionary             *courseInfoDic;


@property (nonatomic,assign) NSInteger                           selectedSection;
@property (nonatomic,assign) NSInteger                           selectedRow;
- (void)dismissStiop;
@end
