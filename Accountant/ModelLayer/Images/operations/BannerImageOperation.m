//
//  BannerImageOperation.m
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "BannerImageOperation.h"
#import "HttpRequestManager.h"
#import "NotificaitonMacro.h"
#import "ImageModuleProtocol.h"

@interface BannerImageOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) MainBannerModel  *mainBannerModel;

@property (nonatomic,weak) id<ImageModule_BannerProtocol>            bannerNotifiedObject;

@end

@implementation BannerImageOperation

- (void)setCurrentMainBanner:(MainBannerModel *)mainBanner
{
    self.mainBannerModel = mainBanner;
}

- (void)didRequestBannerImagesWithNotifiedObject:(id<ImageModule_BannerProtocol>)object
{
    self.bannerNotifiedObject = object;
    [[HttpRequestManager sharedManager] requestBannerWithDelegate:self];
}

#pragma mark - http delegate
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.mainBannerModel removeAllBanners];
    NSArray *data = [successInfo objectForKey:@"data"];
    for (NSString *str in data) {
        BannerModel *model = [[BannerModel alloc] init];
        model.bannerImageURLString = str;
        [self.mainBannerModel addBanner:model];
    }
    if (self.bannerNotifiedObject != nil) {
        [self.bannerNotifiedObject didBannerRequestSuccess];
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfRequestBannerSuccess object:nil];
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (self.bannerNotifiedObject != nil) {
        [self.bannerNotifiedObject didBannerRequestFailed];
    }
}

@end
