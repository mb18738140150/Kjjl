//
//  ResetPwdOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModuleProtocol.h"

@interface ResetPwdOperation : NSObject

- (void)didRequestResetPwdWithOldPwd:(NSString *)oldPwd andNewPwd:(NSString *)newPwd withNotifiedObject:(id<UserModule_ResetPwdProtocol>)object;

@end
