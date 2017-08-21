//
//  AppInfoOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/23.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModuleProtocol.h"
#import "AppInfoModel.h"

@interface AppInfoOperation : NSObject

@property (nonatomic,weak) id<UserModule_AppInfoProtocol>            notifiedObject;

@property (nonatomic,weak) AppInfoModel                             *appInfoModel;

- (void)didRequestAppInfoWithNotifedObject:(id<UserModule_AppInfoProtocol>)object;

@end
