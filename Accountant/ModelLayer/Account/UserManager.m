//
//  UserManager.m
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "UserManager.h"
#import "LoginStatusOperation.h"
#import "UserModuleModels.h"
#import "CommonMacro.h"
#import "ResetPwdOperation.h"
#import "AppInfoOperation.h"
#import "BindJPushOperation.h"
#import "OrderLivingCourseOperation.h"
#import "CancelOrderLivingCourseOperation.h"


#import "VerifyCodeOperation.h"
#import "RegistOperation.h"
#import "ForgetPsdOperation.h"
#import "VerifyAccountOperation.h"
#import "CompleteUserInfoOperation.h"

#import "PathUtility.h"

@interface UserManager()

@property (nonatomic,strong) LoginStatusOperation       *loginOperation;
@property (nonatomic,strong) UserModuleModels           *userModuleModels;

@property (nonatomic,strong) ResetPwdOperation          *resetOperation;

@property (nonatomic,strong) AppInfoOperation           *infoOperation;

@property (nonatomic, strong)BindJPushOperation         *bindJPushOperation;
@property (nonatomic, strong)OrderLivingCourseOperation *orderLivingCourseOperation;
@property (nonatomic, strong)CancelOrderLivingCourseOperation *cancelOrderLivingCOurseOperation;
@property (nonatomic, strong)VerifyCodeOperation         *verifyCodeOperation;
@property (nonatomic, strong)RegistOperation         *registOperation;
@property (nonatomic, strong)ForgetPsdOperation         *forgetPsdOperation;
@property (nonatomic, strong)VerifyAccountOperation     *verfyAccountOperation;
@property (nonatomic, strong)CompleteUserInfoOperation  *completeOperation;

@end

@implementation UserManager

+ (instancetype)sharedManager
{
    static UserManager *__manager__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager__ = [[UserManager alloc] init];
    });
    return __manager__;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.userModuleModels = [[UserModuleModels alloc] init];
        self.loginOperation = [[LoginStatusOperation alloc] init];
        [self.loginOperation setCurrentUser:self.userModuleModels.currentUserModel];
        self.resetOperation = [[ResetPwdOperation alloc] init];
        self.bindJPushOperation = [[BindJPushOperation alloc]init];
        self.orderLivingCourseOperation = [[OrderLivingCourseOperation alloc]init];
        self.cancelOrderLivingCOurseOperation = [[CancelOrderLivingCourseOperation alloc] init];
        self.infoOperation = [[AppInfoOperation alloc] init];
        self.infoOperation.appInfoModel = self.userModuleModels.appInfoModel;
        self.verifyCodeOperation = [[VerifyCodeOperation alloc]init];
        self.registOperation = [[RegistOperation alloc]init];
        self.forgetPsdOperation = [[ForgetPsdOperation alloc]init];
        self.verfyAccountOperation = [[VerifyAccountOperation alloc]init];
        self.completeOperation = [[CompleteUserInfoOperation alloc]init];
    }
    return self;
}

- (void)loginWithUserName:(NSString *)userName andPassword:(NSString *)pwd withNotifiedObject:(id<UserModule_LoginProtocol>)object
{
    [self.loginOperation didLoginWithUserName:userName andPassword:pwd withNotifiedObject:object];
}

- (void)resetPasswordWithOldPassword:(NSString *)oldPwd andNewPwd:(NSString *)newPwd withNotifiedObject:(id<UserModule_ResetPwdProtocol>)object
{
    [self.resetOperation didRequestResetPwdWithOldPwd:oldPwd andNewPwd:newPwd withNotifiedObject:object];
}

- (void)registWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RegistProtocol>)object
{
    [self.registOperation didRequestRegistWithWithDic:infoDic withNotifiedObject:object];
}

- (void)forgetPsdWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_ForgetPasswordProtocol>)object
{
    [self.forgetPsdOperation didRequestForgetPsdWithWithDic:infoDic withNotifiedObject:object];
}

- (void)completeUserInfoWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CompleteUserInfoProtocol>)object;
{
    [self.completeOperation didRequestCompleteUserInfoWithWithDic:infoDic withNotifiedObject:object];
}

- (void)getVerifyCodeWithPhoneNumber:(NSString *)phoneNumber withNotifiedObject:(id<UserModule_VerifyCodeProtocol>)object
{
    [self.verifyCodeOperation didRequestVerifyCodeWithWithPhoneNumber:phoneNumber withNotifiedObject:object];
}

- (void)getVerifyAccountWithAccountNumber:(NSString *)accountNumber withNotifiedObject:(id<UserModule_VerifyAccountProtocol>)object
{
    [self.verfyAccountOperation didRequestVerifyAccountWithWithAccountNumber:accountNumber withNotifiedObject:object];
}

- (void)didRequestAppVersionInfoWithNotifiedObject:(id<UserModule_AppInfoProtocol>)object
{
    [self.infoOperation didRequestAppInfoWithNotifedObject:object];
}

- (void)logout
{
    [self.loginOperation clearLoginUserInfo];
}

- (void)refreshRCDUserInfoWithNickName:(NSString *)nickName andWithPortraitUrl:(NSString *)portraitUrl
{
    RCUserInfo *user = [RCUserInfo new];
    
    user.userId = [NSString stringWithFormat:@"%d", [UserManager sharedManager].getUserId];
    user.name = nickName.length > 0 ? nickName : [[UserManager sharedManager] getUserNickName];
    user.portraitUri = portraitUrl.length > 0 ? portraitUrl : [[UserManager sharedManager] getIconUrl];
    
    [[RCIM sharedRCIM]refreshUserInfoCache:user withUserId:user.userId];
}

- (int)getUserId
{
    return self.userModuleModels.currentUserModel.userID;
}

- (void)didRequestBindJPushWithCID:(NSString *)cid withNotifiedObject:(id<UserModule_BindJPushProtocol>)object
{
    [self.bindJPushOperation didRequestBindJPushWithCID:cid withNotifiedObject:object];
}


- (void)didRequestOrderLivingCourseOperationWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_OrderLivingCourseProtocol>)object
{
    [self.orderLivingCourseOperation didRequestOrderLivingCourseWithCourseInfo:infoDic withNotifiedObject:object];
}

- (void)didRequestCancelOrderLivingCourseOperationWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_OrderLivingCourseProtocol>)object
{
    [self.cancelOrderLivingCOurseOperation didRequestCancelOrderLivingCourseWithCourseInfo:infoDic withNotifiedObject:object];
}

- (BOOL)isUserLogin
{
    return self.userModuleModels.currentUserModel.isLogin;
}

- (NSString *)getUserName
{
    return self.userModuleModels.currentUserModel.userName;
}
- (NSString *)getUserNickName
{
    return self.userModuleModels.currentUserModel.userNickName;
}

- (NSString *)getVerifyCode
{
    return self.verifyCodeOperation.verifyCode;
}

- (NSString *)getVerifyPhoneNumber
{
    return self.verfyAccountOperation.verifyPhoneNumber;
}

- (NSString *)getRongToken
{
    return self.userModuleModels.currentUserModel.rongToken;
}
- (NSString *)getIconUrl
{
    return self.userModuleModels.currentUserModel.headImageUrl;
}
- (int)getUserLevel
{
    return self.userModuleModels.currentUserModel.level;
}

- (NSDictionary *)getUserInfos
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.userModuleModels.currentUserModel.userName forKey:kUserName];
    [dic setObject:@(self.userModuleModels.currentUserModel.userID) forKey:kUserId];
    [dic setObject:self.userModuleModels.currentUserModel.userNickName forKey:kUserNickName];
    
    [dic setObject:self.userModuleModels.currentUserModel.headImageUrl forKey:kUserHeaderImageUrl];
    [dic setObject:self.userModuleModels.currentUserModel.telephone forKey:kUserTelephone];
    [dic setObject:@(self.userModuleModels.currentUserModel.level) forKey:kUserLevel];
//    dic setObject:self.userModuleModels.currentUserModel. forKey:<#(nonnull id<NSCopying>)#>
    return dic;
}

- (void)refreshUserInfoWith:(NSDictionary *)infoDic
{
    RCUserInfo *user = [RCUserInfo new];
    
    
    if ([infoDic objectForKey:@"icon"] && [[infoDic objectForKey:@"icon"] length] > 0) {
        self.userModuleModels.currentUserModel.headImageUrl = [infoDic objectForKey:@"icon"];
        user.portraitUri = [infoDic objectForKey:@"icon"];
    }else
    {
        user.portraitUri = [[UserManager sharedManager] getIconUrl];
    }
    
    if ([infoDic objectForKey:@"phoneNumber"] && [[infoDic objectForKey:@"phoneNumber"] length] > 0) {
        self.userModuleModels.currentUserModel.telephone = [infoDic objectForKey:@"phoneNumber"];
    }
    
    if ([infoDic objectForKey:@"nickName"] && [[infoDic objectForKey:@"nickName"] length] > 0) {
        self.userModuleModels.currentUserModel.userNickName = [infoDic objectForKey:@"nickName"];
        user.name = [infoDic objectForKey:@"nickName"];
    }else
    {
        user.name = [[UserManager sharedManager] getUserNickName];
    }
    
    user.userId = [NSString stringWithFormat:@"%d", [UserManager sharedManager].getUserId];
    
    [[RCIM sharedRCIM]refreshUserInfoCache:user withUserId:user.userId];
    [RCIM sharedRCIM].currentUserInfo.userId = user.userId;
    [RCIM sharedRCIM].currentUserInfo.name = user.name;
    [RCIM sharedRCIM].currentUserInfo.portraitUri = user.portraitUri;
    NSString *dataPath = [[PathUtility getDocumentPath] stringByAppendingPathComponent:@"user.data"];
    [NSKeyedArchiver archiveRootObject:self.userModuleModels.currentUserModel toFile:dataPath];
}

- (NSDictionary *)getUpdateInfo
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.userModuleModels.appInfoModel.updateContent forKey:kAppUpdateInfoContent];
    [dic setObject:@(self.userModuleModels.appInfoModel.version) forKey:kAppUpdateInfoVersion];
    [dic setObject:self.userModuleModels.appInfoModel.downloadUrl forKey:kAppUpdateInfoUrl];
    [dic setObject:@(self.userModuleModels.appInfoModel.isForce) forKey:kAppUpdateInfoIsForce];
    return dic;
}

@end
