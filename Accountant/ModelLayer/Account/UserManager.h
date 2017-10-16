//
//  UserManager.h
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModuleProtocol.h"

@interface UserManager : NSObject

+ (instancetype)sharedManager;


/**
 请求登陆接口

 @param userName 用户名
 @param pwd 密码
 @param object 请求成功后通知的对象
 */
- (void)loginWithUserName:(NSString *)userName
              andPassword:(NSString *)pwd
       withNotifiedObject:(id<UserModule_LoginProtocol>)object;



/**
 请求重置密码接口

 @param oldPwd 旧密码
 @param newPwd 新密码
 @param object 请求成功后通知的对象
 */
- (void)resetPasswordWithOldPassword:(NSString *)oldPwd andNewPwd:(NSString *)newPwd withNotifiedObject:(id<UserModule_ResetPwdProtocol>)object;

- (void)registWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RegistProtocol>)object;


- (void)forgetPsdWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_ForgetPasswordProtocol>)object;

- (void)getVerifyCodeWithPhoneNumber:(NSString *)phoneNumber withNotifiedObject:(id<UserModule_VerifyCodeProtocol>)object;

- (void)getVerifyAccountWithAccountNumber:(NSString *)accountNumber withNotifiedObject:(id<UserModule_VerifyAccountProtocol>)object;

- (void)completeUserInfoWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CompleteUserInfoProtocol>)object;

/**
 请求app版本信息

 @param object 请求成功后通知的对象
 */
- (void)didRequestAppVersionInfoWithNotifiedObject:(id<UserModule_AppInfoProtocol>)object;

/**
 退出登录
 */
- (void)logout;

/**
 判断是否已经登陆

 @return 是否登陆
 */
- (BOOL)isUserLogin;

/**
 绑定极光账号
 
 */
- (void)didRequestBindJPushWithCID:(NSString *)cid withNotifiedObject:(id<UserModule_BindJPushProtocol>)object;

/**
 预约直播课
 
 */
- (void)didRequestOrderLivingCourseOperationWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_OrderLivingCourseProtocol>)object;

/**
 取消预约直播课
 
 */
- (void)didRequestCancelOrderLivingCourseOperationWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_OrderLivingCourseProtocol>)object;

//- (void)refreshRCDUserInfoWithNickName:(NSString *)nickName andWithPortraitUrl:(NSString *)portraitUrl;

/**
 获取用户id

 @return 用户id
 */
- (int)getUserId;


/**
 获取用户名

 @return 用户名
 */
- (NSString *)getUserName;

/**
 获取昵称
 
 @return 昵称
 */
- (NSString *)getUserNickName;

/**
 获取验证码
 
 @return 验证码
 */
- (NSString *)getVerifyCode;

/**
 获取绑定手机号
 
 @return 已绑定手机号
 */
- (NSString *)getVerifyPhoneNumber;

/**
 获取融云token
 
 @return 融云tokrn
 */
- (NSString *)getRongToken;

- (NSString *)getIconUrl;

/**
 获取用户信息

 @return 用户信息
 */
- (NSDictionary *)getUserInfos;

- (void)refreshUserInfoWith:(NSDictionary *)infoDic;

- (int)getUserLevel;

- (NSDictionary *)getUpdateInfo;

@end
