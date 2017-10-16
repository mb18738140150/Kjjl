//
//  VerifyCodeOperation.h
//  Accountant
//
//  Created by aaa on 2017/9/13.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModuleProtocol.h"

@interface VerifyCodeOperation : NSObject

@property (nonatomic, strong
           )NSString * verifyCode;

- (void)didRequestVerifyCodeWithWithPhoneNumber:(NSString *)phoneNumber withNotifiedObject:(id<UserModule_VerifyCodeProtocol>)object;

@end
