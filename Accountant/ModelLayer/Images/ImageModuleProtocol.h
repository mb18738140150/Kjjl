//
//  ImageModuleProtocol.h
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageModule_BannerProtocol <NSObject>

- (void)didBannerRequestSuccess;
- (void)didBannerRequestFailed;

@end

@protocol ImageModule_UploadProtocol <NSObject>

- (void)didImageUploadSuccess;
- (void)didImageUploadFailed:(NSString *)failedInfo;

@end
