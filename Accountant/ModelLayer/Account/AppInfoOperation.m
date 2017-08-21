//
//  AppInfoOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/23.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "AppInfoOperation.h"
#import "UserModuleProtocol.h"
#import "HttpRequestManager.h"
#import "CommonMacro.h"

@interface AppInfoOperation ()<HttpRequestProtocol>

@end

@implementation AppInfoOperation

- (void)didRequestAppInfoWithNotifedObject:(id<UserModule_AppInfoProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustAppVersionInfoWithProcessDelegate:self];
    
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    NSDictionary *data = [successInfo objectForKey:@"data"];
    self.appInfoModel.updateContent = [data objectForKey:@"versionDesc"];
    self.appInfoModel.version = [[data objectForKey:@"versionCode"] floatValue];
    self.appInfoModel.downloadUrl = [data objectForKey:@"apkUrl"];
    
    self.appInfoModel.isForce = [[successInfo objectForKey:@"mandatory"] boolValue];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAppInfoSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    
}

@end
