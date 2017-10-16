//
//  VerifyAccountOperation.h
//  Accountant
//
//  Created by aaa on 2017/9/15.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModuleProtocol.h"

@interface VerifyAccountOperation : NSObject

@property (nonatomic, weak)NSString * verifyPhoneNumber;

- (void)didRequestVerifyAccountWithWithAccountNumber:(NSString *)accountNumber withNotifiedObject:(id<UserModule_VerifyAccountProtocol>)object;

@end
