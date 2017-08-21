//
//  ImageManager.m
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "ImageManager.h"
#import "BannerImageOperation.h"
#import "ImageModuleModels.h"
#import "UploadImageOperation.h"

@interface ImageManager ()

@property (nonatomic,strong) BannerImageOperation       *bannerOperation;
@property (nonatomic,strong) UploadImageOperation       *uploadOperation;

@property (nonatomic,strong) ImageModuleModels          *imageModuleModels;

@end

@implementation ImageManager

+ (instancetype)sharedManager
{
    static ImageManager *__manager__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager__ = [[ImageManager alloc] init];
    });
    return __manager__;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.imageModuleModels = [[ImageModuleModels alloc] init];
        self.bannerOperation = [[BannerImageOperation alloc] init];
        [self.bannerOperation setCurrentMainBanner:self.imageModuleModels.mainBannerModel];
        
        self.uploadOperation = [[UploadImageOperation alloc] init];
    }
    return self;
}

- (void)didRequestBannerImagesWithNotifiedObject:(id<ImageModule_BannerProtocol>)object
{
    [self.bannerOperation didRequestBannerImagesWithNotifiedObject:object];
}

- (void)didUploadImage:(NSData *)imageData withNotifiedObject:(id<ImageModule_UploadProtocol>)object
{
    [self.uploadOperation didUploadImage:imageData withNotifiedObject:object];
}

- (NSArray *)getBannerImgURLStrings
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (BannerModel *model in self.imageModuleModels.mainBannerModel.mainBanners) {
        [array addObject:model.bannerImageURLString];
    }
    return array;
}

@end
