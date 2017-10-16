//
//  LivingSectionDetailViewController.h
//  Accountant
//
//  Created by aaa on 2017/9/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "ViewController.h"

@interface LivingSectionDetailViewController : ViewController

@property (nonatomic, assign)int haveJurisdiction;// 直播课回放观看权限
@property (nonatomic, assign)int courseId;
@property (nonatomic, strong)NSDictionary * courseInfoDic;

@end
