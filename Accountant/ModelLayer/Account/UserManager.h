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


// 注册
- (void)registWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RegistProtocol>)object;


// 忘记密码
- (void)forgetPsdWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_ForgetPasswordProtocol>)object;

// 获取验证码
- (void)getVerifyCodeWithPhoneNumber:(NSString *)phoneNumber withNotifiedObject:(id<UserModule_VerifyCodeProtocol>)object;

- (void)getVerifyAccountWithAccountNumber:(NSString *)accountNumber withNotifiedObject:(id<UserModule_VerifyAccountProtocol>)object;

// 完善个人信息
- (void)completeUserInfoWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CompleteUserInfoProtocol>)object;

- (void)bindRegCodeWithRegCode:(NSString *)regCode withNotifiedObject:(id<UserModule_bindRegCodeProtocol>)object;



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
- (void)didRequestCancelOrderLivingCourseOperationWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CancelOrderLivingCourseProtocol>)object;

//- (void)refreshRCDUserInfoWithNickName:(NSString *)nickName andWithPortraitUrl:(NSString *)portraitUrl;

/**
 获取用户id

 @return 用户id
 */
- (int)getUserId;

/**
 获取是否显示邀请码
 
 @return 邀请码是否显示
 */
- (int)getCodeview;

- (void)changeCodeViewWith:(int)codeView;

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

- (NSString *)getLevelStr;

- (NSDictionary *)getUpdateInfo;

// 支付订单
- (void)payOrderWith:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_PayOrderProtocol>)object;
// 获取订单支付详情
- (NSDictionary *)getPayOrderDetailInfo;

// 获取我的订单列表
- (void)didRequestOrderListWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_OrderListProtocol>)object;
- (NSArray *)getMyOrderList;

/**
 获取优惠券
 
 */
- (void)didRequestMyDiscountCouponWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_discountCouponProtocol>)object;
- (NSArray *)getAllDiscountCoupon;
- (NSArray *)getNormalDiscountCoupon;
- (NSArray *)getexpireDiscountCoupon;
- (NSArray *)getCannotUseDiscountCoupon:(double)price;
- (NSArray *)getHaveUsedDiscountCoupon;

- (void)didRequestAcquireDiscountCouponWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_AcquireDiscountCouponProtocol>)object;
- (NSArray *)getAcquireDiscountCoupon;

// 获取我的积分
- (void)didRequestIntegralWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RecommendProtocol>)object;
- (void)didRequestGetIntegralWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RecommendProtocol>)object;
- (void)didRequestGetRecommendIntegralWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RecommendProtocol>)object;
- (int)getIntegral;
- (NSDictionary *)getRecommendIntegral;

// 客服信息
- (void)didRequestAssistantWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_AssistantCenterProtocol>)object;
- (NSArray *)getAssistantList;
- (NSArray *)getTelephoneList;

// 会员详情信息
- (void)didRequestLevelDetailWithNotifiedObject:(id<UserModule_LevelDetailProtocol>)object;
- (NSArray *)getLevelDetailList;

// 意见反馈
- (void)didRequestSubmitOpinionWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_SubmitOperationProtocol>)object;


// 常见问题
- (void)didRequestCommonProblemWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CommonProblem>)object;
- (NSArray *)getCommonProblemList;

// 获取往期回放年份列表
- (void)didRequestLivingBackYearListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_LivingBackYearList>)object;
- (NSArray *)getLivingBackYearList;

// 福利
- (void)didRequestGiftListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_GiftList>)object;
- (NSArray *)getGiftList;

- (void)didRequestSubmitGiftCodeWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_SubmitGiftCode>)object;

@end
