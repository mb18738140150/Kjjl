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

@interface UserManager()

@property (nonatomic,strong) LoginStatusOperation       *loginOperation;
@property (nonatomic,strong) UserModuleModels           *userModuleModels;

@property (nonatomic,strong) ResetPwdOperation          *resetOperation;

@property (nonatomic,strong) AppInfoOperation           *infoOperation;

@property (nonatomic, strong)BindJPushOperation         *bindJPushOperation;
@property (nonatomic, strong)OrderLivingCourseOperation *orderLivingCourseOperation;

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
        self.infoOperation = [[AppInfoOperation alloc] init];
        self.infoOperation.appInfoModel = self.userModuleModels.appInfoModel;
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

- (void)didRequestAppVersionInfoWithNotifiedObject:(id<UserModule_AppInfoProtocol>)object
{
    [self.infoOperation didRequestAppInfoWithNotifedObject:object];
}

- (void)logout
{
    [self.loginOperation clearLoginUserInfo];
}

- (int)getUserId
{
    return self.userModuleModels.currentUserModel.userID;
}

- (void)didRequestBindJPushWithCID:(NSString *)cid withNotifiedObject:(id<UserModule_BindJPushProtocol>)object
{
    [self.bindJPushOperation didRequestBindJPushWithCID:cid withNotifiedObject:object];
}


- (void)didRequestOrderLivingCourseOperationWithCourseId:(int)courseId withNotifiedObject:(id<UserModule_OrderLivingCourseProtocol>)object
{
    [self.orderLivingCourseOperation didRequestOrderLivingCourseWithCourseId:courseId withNotifiedObject:object];
}

- (BOOL)isUserLogin
{
    return self.userModuleModels.currentUserModel.isLogin;
}

- (NSString *)getUserName
{
    return self.userModuleModels.currentUserModel.userName;
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
