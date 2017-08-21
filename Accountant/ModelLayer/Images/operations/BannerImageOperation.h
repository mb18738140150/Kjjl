//
//  BannerImageOperation.h
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainBannerModel.h"
#import "ImageModuleProtocol.h"

@interface BannerImageOperation : NSObject

- (void)setCurrentMainBanner:(MainBannerModel *)mainBanner;

- (void)didRequestBannerImagesWithNotifiedObject:(id<ImageModule_BannerProtocol>)object;

@end
