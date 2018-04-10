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
#import "BindRegCodeOperation.h"
#import "DiscountCouponOperation.h"
#import "OrderListOperation.h"
#import "VerifyCodeOperation.h"
#import "RegistOperation.h"
#import "ForgetPsdOperation.h"
#import "VerifyAccountOperation.h"
#import "CompleteUserInfoOperation.h"
#import "PayCourseOperation.h"
#import "PathUtility.h"
#import "RecommendOperation.h"
#import "AssistantCenterOperation.h"
#import "MemberLevelDetail.h"
#import "SubmitOpinionOperation.h"
#import "CommonProblemOperation.h"
#import "LivingBackYearListOperation.h"
#import "SubmitGiftCodeOperation.h"
#import "GiftListOperation.h"
#import "AcquireDiscountCouponOperation.h"
#import "AcquireDiscountCouponSuccess.h"

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
@property (nonatomic, strong)BindRegCodeOperation       *bindRegCodeOperation;
@property (nonatomic, strong)PayCourseOperation         *payOrderOperation;
@property (nonatomic, strong)DiscountCouponOperation    *discountCouponOperation;
@property (nonatomic, strong)OrderListOperation         *orderListOperation;
@property (nonatomic, strong)RecommendOperation         *recommendOperation;
@property (nonatomic, strong)AssistantCenterOperation   *assistantCenterOperation;
@property (nonatomic, strong)MemberLevelDetail          *memberLevelDetailOperation;
@property (nonatomic, strong)SubmitOpinionOperation     *submitOpinionOperation;
@property (nonatomic, strong)CommonProblemOperation     *commonProblemOperation;
@property (nonatomic, strong)LivingBackYearListOperation *livingBackYearLiatOperation;
@property (nonatomic, strong)GiftListOperation          *giftLIstOperation;
@property (nonatomic, strong)SubmitGiftCodeOperation    *submitGiftCodeOperation;
@property (nonatomic, strong)AcquireDiscountCouponOperation *acquireDisCountOperation;
@property (nonatomic, strong)AcquireDiscountCouponSuccess   *acquireDisCountSuccessOperation;

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
        self.bindRegCodeOperation = [[BindRegCodeOperation alloc]init];
        self.payOrderOperation = [[PayCourseOperation alloc]init];
        self.discountCouponOperation = [[DiscountCouponOperation alloc]init];
        self.acquireDisCountOperation = [[AcquireDiscountCouponOperation alloc]init];
        self.acquireDisCountSuccessOperation = [[AcquireDiscountCouponSuccess alloc]init];
        self.orderListOperation = [[OrderListOperation alloc]init];
        self.recommendOperation = [[RecommendOperation alloc]init];
        self.assistantCenterOperation = [[AssistantCenterOperation alloc]init];
        self.memberLevelDetailOperation = [[MemberLevelDetail alloc]init];
        self.submitOpinionOperation = [[SubmitOpinionOperation alloc]init];
        self.commonProblemOperation = [[CommonProblemOperation alloc]init];
        self.livingBackYearLiatOperation = [[LivingBackYearListOperation alloc]init];
        self.giftLIstOperation = [[GiftListOperation alloc]init];
        self.submitGiftCodeOperation = [[SubmitGiftCodeOperation alloc]init];
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

- (void)bindRegCodeWithRegCode:(NSString *)regCode withNotifiedObject:(id<UserModule_bindRegCodeProtocol>)object
{
    [self.bindRegCodeOperation didBindRegCodeWithWithCode:regCode withNotifiedObject:object];
}

- (void)payOrderWith:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_PayOrderProtocol>)object
{
    [self.payOrderOperation didRequestPayOrderWithCourseInfo:infoDic withNotifiedObject:object];
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

- (void)didRequestOrderListWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_OrderListProtocol>)object
{
    [self.orderListOperation didRequestOrderListWithCourseInfo:infoDic withNotifiedObject:object];
}

- (void)didRequestMyDiscountCouponWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_discountCouponProtocol>)object
{
    [self.discountCouponOperation didRequestDiscountCouponWithCourseInfo:infoDic withNotifiedObject:object];
}

- (void)didRequestAcquireDiscountCouponWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_AcquireDiscountCouponProtocol>)object
{
    [self.acquireDisCountOperation didRequestAcquireDiscountCouponWithCourseInfo:infoDic withNotifiedObject:object];
}

- (void)didRequestAcquireDiscountCouponSuccessWithCourseInfo:(NSDictionary *)infoDic
{
    [self.acquireDisCountSuccessOperation didRequestAcquireDiscountCouponSuccessWithCourseInfo:infoDic];
}

- (void)didRequestIntegralWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RecommendProtocol>)object
{
    [self.recommendOperation didRequestIntegralWithCourseInfo:infoDic withNotifiedObject:object];
}

- (void)didRequestGetIntegralWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RecommendProtocol>)object
{
    [self.recommendOperation didRequestGetIntegralWithCourseInfo:infoDic withNotifiedObject:object];
}
- (void)didRequestGetRecommendIntegralWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RecommendProtocol>)object
{
    [self.recommendOperation didRequestGetRecommendIntegralWithCourseInfo:infoDic withNotifiedObject:object];
}

- (void)didRequestAssistantWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_AssistantCenterProtocol>)object
{
    [self.assistantCenterOperation didRequestAssistantWithInfo:infoDic withNotifiedObject:object];
}

- (void)didRequestLevelDetailWithNotifiedObject:(id<UserModule_LevelDetailProtocol>)object
{
    [self.memberLevelDetailOperation didRequestMemberLevelDetailWithNotifiedObject:object];
}

- (void)didRequestSubmitOpinionWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_SubmitOperationProtocol>)object
{
    [self.submitOpinionOperation didRequestSubmitOpinionWithInfo:infoDic withNotifiedObject:object];
}

- (void)didRequestCommonProblemWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CommonProblem>)object
{
    [self.commonProblemOperation didRequestCommonProblemWithNotifiedObject:object];
}

- (void)didRequestGiftListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_GiftList>)object
{
    [self.giftLIstOperation didRequestGiftListWithInfo:infoDic withNotifiedObject:object];
}

- (void)didRequestSubmitGiftCodeWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_SubmitGiftCode>)object
{
    [self.submitGiftCodeOperation didRequestSubmitGiftCodeWithInfo:infoDic withNotifiedObject:object];
}

- (void)didRequestLivingBackYearListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_LivingBackYearList>)object
{
    [self.livingBackYearLiatOperation didRequestLivingBackYearListWithInfo:infoDic withNotifiedObject:object];
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

- (int)getCodeview
{
    return self.userModuleModels.currentUserModel.codeview;
}

- (void)changeCodeViewWith:(int)codeView
{
    self.userModuleModels.currentUserModel.codeview = codeView;
}

- (void)didRequestBindJPushWithCID:(NSString *)cid withNotifiedObject:(id<UserModule_BindJPushProtocol>)object
{
    [self.bindJPushOperation didRequestBindJPushWithCID:cid withNotifiedObject:object];
}


- (void)didRequestOrderLivingCourseOperationWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_OrderLivingCourseProtocol>)object
{
    [self.orderLivingCourseOperation didRequestOrderLivingCourseWithCourseInfo:infoDic withNotifiedObject:object];
}

- (void)didRequestCancelOrderLivingCourseOperationWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CancelOrderLivingCourseProtocol>)object
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

- (NSString *)getLevelStr
{
    NSString * levelStr = @"";
    switch (self.userModuleModels.currentUserModel.level) {
        case 1:
            levelStr = @"普通会员";
            break;
        case 2:
            levelStr = @"试听会员";
            break;
        case 3:
        {
            if ([self isHaveMemberLevel]) {
                levelStr = self.userModuleModels.currentUserModel.levelDetail;
            }else
            {
                levelStr = @"正式会员";
            }
        }
            break;
            
        default:
            break;
    }
    return levelStr;
}

- (BOOL)isHaveMemberLevel
{
    NSString * levelDetail = self.userModuleModels.currentUserModel.levelDetail ;
    if ([levelDetail isEqualToString:@"K1"] || [levelDetail isEqualToString:@"K2"] || [levelDetail isEqualToString:@"K3"] || [levelDetail isEqualToString:@"K4"] || [levelDetail isEqualToString:@"K5"]) {
        return YES;
    }else
    {
        return NO;
    }
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
    [dic setObject:self.userModuleModels.currentUserModel.levelDetail forKey:kUserLevelDetail];
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

- (NSDictionary *)getPayOrderDetailInfo
{
    return self.payOrderOperation.payOrderDetailInfo;
}

- (NSArray *)getMyOrderList
{
    NSMutableArray *dataArr = [NSMutableArray array];
    NSMutableArray * allOrderArr = [NSMutableArray array];
    NSMutableArray * notPayOrderArr = [NSMutableArray array];
    NSMutableArray * complateOrderArr = [NSMutableArray array];
    
    for (NSDictionary * orderInfo in self.orderListOperation.orderList) {
        [allOrderArr addObject:orderInfo];
        if ([[orderInfo objectForKey:kOrderStatus] intValue] == 1) {
            [complateOrderArr addObject:orderInfo];
        }else
        {
            [notPayOrderArr addObject:orderInfo];
        }
    }
    [dataArr addObject:allOrderArr];
    [dataArr addObject:notPayOrderArr];
    [dataArr addObject:complateOrderArr];
    
    return dataArr;
}

- (NSArray *)getAllDiscountCoupon
{
    return self.discountCouponOperation.discountCouponArray;
}

- (NSArray *)getAcquireDiscountCoupon
{
    return self.acquireDisCountOperation.discountCouponArray;
}

- (NSArray *)getNormalDiscountCoupon
{
    NSMutableArray * array = [NSMutableArray array];
    for (NSDictionary * infoDic in self.discountCouponOperation.discountCouponArray) {
        if ([[infoDic objectForKey:@"useType"] intValue] == 0) {
            [array addObject:infoDic];
        }
    }
    
    return array;
}
- (NSArray *)getexpireDiscountCoupon
{
    NSMutableArray * array = [NSMutableArray array];
    for (NSDictionary * infoDic in self.discountCouponOperation.discountCouponArray) {
        if ([[infoDic objectForKey:@"useType"] intValue] == 2) {
            [array addObject:infoDic];
        }
    }
    return array;
}
- (NSArray *)getCannotUseDiscountCoupon:(double)price
{
    NSMutableArray * array = [NSMutableArray array];
    
    NSMutableArray * canUseArray = [NSMutableArray array];
    NSMutableArray *cannotArray = [NSMutableArray array];
    for (NSDictionary * infoDic in self.discountCouponOperation.discountCouponArray) {
        if ([[infoDic objectForKey:@"useType"] intValue] == 0 &&  [[infoDic objectForKey:@"manPrice"] doubleValue] <= price) {
            [canUseArray addObject:infoDic];
        }else if ([[infoDic objectForKey:@"useType"] intValue] == 0)
        {
            [cannotArray addObject:infoDic];
        }
        
    }
    [array addObject:canUseArray];
    [array addObject:cannotArray];
    return array;
}
- (NSArray *)getHaveUsedDiscountCoupon
{
    NSMutableArray * array = [NSMutableArray array];
    for (NSDictionary * infoDic in self.discountCouponOperation.discountCouponArray) {
        if ([[infoDic objectForKey:@"useType"] intValue] == 1) {
            [array addObject:infoDic];
        }
        
    }
    return array;
}

- (int)getIntegral
{
    return self.recommendOperation.integral;
}
- (NSDictionary *)getRecommendIntegral
{
    return self.recommendOperation.recommendInfo;
}

- (NSArray *)getAssistantList
{
    return self.assistantCenterOperation.assistantList;
}

- (NSArray *)getTelephoneList
{
    return self.assistantCenterOperation.telephoneNumberList;
}

- (NSArray *)getLevelDetailList
{
    return self.memberLevelDetailOperation.memberLevelDetailList;
}

- (NSArray *)getCommonProblemList
{
    return self.commonProblemOperation.commonProblemList;
}

- (NSArray *)getLivingBackYearList
{
    return self.livingBackYearLiatOperation.livingBackYearList;
}

- (NSArray *)getGiftList
{
    return self.giftLIstOperation.livingBackYearList;
}

@end
