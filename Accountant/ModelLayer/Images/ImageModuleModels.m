//
//  ImageModuleModels.m
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "ImageModuleModels.h"

@implementation ImageModuleModels

- (instancetype)init
{
    if (self = [super init]) {
        [self initalModels];
    }
    return self;
}

- (void)initalModels
{
    self.mainBannerModel = [[MainBannerModel alloc] init];
}

@end
