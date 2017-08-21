//
//  LoginStatusOperation.h
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestProtocol.h"
#import "UserModel.h"
#import "UserModuleProtocol.h"

@interface LoginStatusOperation : NSObject<HttpRequestProtocol>

- (void)clearLoginUserInfo;

- (void)setCurrentUser:(UserModel *)user;

- (void)encodeUserInfo;

- (void)didLoginWithUserName:(NSString *)userName andPassword:(NSString *)password withNotifiedObject:(id<UserModule_LoginProtocol>)object;

@end
