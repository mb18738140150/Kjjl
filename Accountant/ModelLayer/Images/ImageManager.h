//
//  ImageManager.h
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageModuleProtocol.h"

@interface ImageManager : NSObject

+ (instancetype)sharedManager;


/**
 获取首页banner图片的地址

 @return 图片地址
 */
- (NSArray *)getBannerImgURLStrings;


/**
 请求首页banner图片的地址

 @param object 请求成功后通知的对象
 */
- (void)didRequestBannerImagesWithNotifiedObject:(id<ImageModule_BannerProtocol>)object;

- (void)didUploadImage:(NSData *)imageData withNotifiedObject:(id<ImageModule_UploadProtocol>)object;

@end
