//
//  UserModuleProtocol.h
//  Accountant
//
//  Created by aaa on 2017/3/2.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserModule_LoginProtocol <NSObject>

- (void)didUserLoginSuccessed;

- (void)didUserLoginFailed:(NSString *)failedInfo;

@end

@protocol UserModule_VerifyAccountProtocol <NSObject>

- (void)didVerifyAccountSuccessed;
- (void)didVerifyAccountFailed:(NSString *)failInfo;

@end

@protocol UserModule_RegistProtocol <NSObject>

- (void)didRegistSuccessed;
- (void)didRegistFailed:(NSString *)failInfo;

@end

@protocol UserModule_CompleteUserInfoProtocol <NSObject>

- (void)didCompleteUserSuccessed;
- (void)didCompleteUserFailed:(NSString *)failInfo;

@end

@protocol UserModule_ForgetPasswordProtocol <NSObject>

- (void)didForgetPasswordSuccessed;
- (void)didForgetPasswordFailed:(NSString *)failInfo;

@end

@protocol UserModule_VerifyCodeProtocol <NSObject>

- (void)didVerifyCodeSuccessed;
- (void)didVerifyCodeFailed:(NSString *)failInfo;

@end

@protocol UserModule_ResetPwdProtocol <NSObject>

- (void)didResetPwdSuccessed;
- (void)didResetPwdFailed:(NSString *)failInfo;

@end

@protocol UserModule_AppInfoProtocol <NSObject>

- (void)didRequestAppInfoSuccessed;
- (void)didRequestAppInfoFailed:(NSString *)failedInfo;

@end
@protocol UserModule_BindJPushProtocol <NSObject>

- (void)didRequestBindJPushSuccessed;
- (void)didRequestBindJPushFailed:(NSString *)failedInfo;

@end
@protocol UserModule_OrderLivingCourseProtocol <NSObject>

- (void)didRequestOrderLivingSuccessed;
- (void)didRequestOrderLivingFailed:(NSString *)failedInfo;

@end
@protocol UserModule_CancelOrderLivingCourseProtocol <NSObject>

- (void)didRequestCancelOrderLivingSuccessed;
- (void)didRequestCancelOrderLivingFailed:(NSString *)failedInfo;

@end
