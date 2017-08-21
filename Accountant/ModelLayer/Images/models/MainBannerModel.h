//
//  MainBannerModel.h
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BannerModel.h"

@interface MainBannerModel : NSObject

@property (nonatomic,strong) NSMutableArray         *mainBanners;

- (void)removeAllBanners;

- (void)addBanner:(BannerModel *)model;

@end
