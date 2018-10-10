//
//  SoftManager.m
//  qianshutang
//
//  Created by aaa on 2018/8/4.
//  Copyright © 2018年 mcb. All rights reserved.
//

#import "SoftManager.h"

@implementation SoftManager

+ (instancetype)shareSoftManager
{
    static SoftManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SoftManager alloc]init];
        if ([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled]) {
            manager.coinName = @"￥";
        }else
        {
            manager.coinName = @"金币";
        }
        
    });
    
    return manager;
}

@end
