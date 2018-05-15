//
//  LoginStatusOperation.m
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "LoginStatusOperation.h"
#import "HttpRequestManager.h"
#import "PathUtility.h"

@interface LoginStatusOperation ()

@property (nonatomic,weak) id<UserModule_LoginProtocol>          loginNotifiedObject;

@property (nonatomic,weak) UserModel                            *userModel;

@end

@implementation LoginStatusOperation

- (void)clearLoginUserInfo
{
    self.userModel.userID = 0;
    self.userModel.userName = @"";
    self.userModel.isLogin = NO;
    self.userModel.userNickName = @"";
    self.userModel.headImageUrl = @"";
    self.userModel.telephone = @"";
    self.userModel.rongToken = @"";
    self.userModel.level = 0;
    self.userModel.level = 0;
    self.userModel.goldCoins = 0;
    self.userModel.codeview = 1;
    [self encodeUserInfo];
}

- (void)setCurrentUser:(UserModel *)user
{
    self.userModel = user;
}

- (void)didLoginWithUserName:(NSString *)userName andPassword:(NSString *)password withNotifiedObject:(id<UserModule_LoginProtocol>)object
{
//    self.userModel.userName = userName;
    self.loginNotifiedObject = object;
    [[HttpRequestManager sharedManager] requestLoginWithUserName:userName andPassword:password andProcessDelegate:self];
}

- (void)encodeUserInfo
{
    NSString *dataPath = [[PathUtility getDocumentPath] stringByAppendingPathComponent:@"user.data"];
    [NSKeyedArchiver archiveRootObject:self.userModel toFile:dataPath];
}

#pragma mark - request delegate
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    NSLog(@"successInfo = %@", successInfo);
    
    self.userModel.userID = [[successInfo objectForKey:@"data"] intValue];
    self.userModel.userName = [successInfo objectForKey:@"userName"];
    if ([[successInfo objectForKey:@"nickName"] class] == [NSNull class] || [successInfo objectForKey:@"nickName"] == nil || [[successInfo objectForKey:@"nickName"] isEqualToString:@""]) {
        self.userModel.userNickName = @"学员";
    }else{
        self.userModel.userNickName = [successInfo objectForKey:@"nickName"];
    }
    self.userModel.headImageUrl = [successInfo objectForKey:@"icon"];
    
    if ([[successInfo objectForKey:@"telephone"] class] == [NSNull class] || [successInfo objectForKey:@"telephone"] == nil || [[successInfo objectForKey:@"telephone"] isEqualToString:@""]) {
        self.userModel.telephone = @"未绑定";
    }else{
        self.userModel.telephone = [successInfo objectForKey:@"telephone"];
    }
    
    self.userModel.level = [[successInfo objectForKey:@"level"] intValue];
    self.userModel.codeview = [[successInfo objectForKey:@"codeView"] intValue];
    self.userModel.levelDetail = @"";
    if (![[successInfo objectForKey:@"levelDetail"] isKindOfClass:[NSNull class]] && [successInfo objectForKey:@"levelDetail"]) {
        self.userModel.levelDetail = [successInfo objectForKey:@"levelDetail"];
    }
    
    self.userModel.isLogin = YES;
    
    if (self.loginNotifiedObject != nil) {
        [self.loginNotifiedObject didUserLoginSuccessed];
    }
    
    if ([[successInfo objectForKey:@"rongToken"] isKindOfClass:[NSNull class]] || ![successInfo objectForKey:@"rongToken"]) {
        self.userModel.rongToken = @"";
    }else
    {
        self.userModel.rongToken = [successInfo objectForKey:@"rongToken"];
    }
    
    [self encodeUserInfo];
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (self.loginNotifiedObject != nil) {
        [self.loginNotifiedObject didUserLoginFailed:failInfo];
    }
}

@end
