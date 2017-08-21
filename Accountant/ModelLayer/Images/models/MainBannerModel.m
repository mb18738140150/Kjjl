//
//  MainBannerModel.m
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MainBannerModel.h"

@implementation MainBannerModel

- (instancetype)init
{
    if (self = [super init]) {
        self.mainBanners = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)removeAllBanners
{
    [self.mainBanners removeAllObjects];
}

- (void)addBanner:(BannerModel *)model
{
    [self.mainBanners addObject:model];
}

@end
