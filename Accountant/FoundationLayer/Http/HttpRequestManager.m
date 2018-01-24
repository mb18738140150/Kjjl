//
//  HttpRequestManager.m
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "HttpRequestManager.h"
#import "AFNetworking.h"
#import "NetMacro.h"
#import "NSString+MD5.h"
#import "NSDictionary+JsonString.h"
#import "HttpConfigCreator.h"


@interface HttpRequestManager ()

@property (nonatomic,strong) NSMutableDictionary        *requestDelegateDictionary;

@end

@implementation HttpRequestManager

+ (instancetype)sharedManager
{
    static HttpRequestManager *__manager__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager__ = [[HttpRequestManager alloc] init];
    });
    return __manager__;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.requestDelegateDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}


#pragma mark -
- (void)requestHottestCourseWithProcessDelegate:(__weak id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *hotHttp = [HttpConfigCreator getHottestHttpConfig];
    [self startPostWithConfig:hotHttp andProcessDelegate:delegate];
}

- (void)requestHotSearchCourseDelegate:(__weak id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *searchHttp = [HttpConfigCreator getHotSearchCourse];
    [self startPostWithConfig:searchHttp andProcessDelegate:delegate];
}

- (void)requestSearchVideoCoueseWithProcessKeyWord:(NSString *)keyword Delegate:(__weak id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *hotHttp = [HttpConfigCreator getSearchVideoCoueseHttpConfigWith:keyword];
    [self startPostWithConfig:hotHttp andProcessDelegate:delegate];
}

- (void)requestSearchLivestreamWithProcessKeyWord:(NSString *)keyword Delegate:(__weak id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *hotHttp = [HttpConfigCreator getSearchLivestreamHttpConfigWith:keyword];
    [self startPostWithConfig:hotHttp andProcessDelegate:delegate];
}

- (void)requestLoginWithUserName:(NSString *)userName
                     andPassword:(NSString *)password
              andProcessDelegate:(__weak id<HttpRequestProtocol>)delegate;
{
    HttpConfigModel *loginHttp = [HttpConfigCreator getLoginHttpConfigWithUserName:userName andPassword:password];
    [self startPostWithConfig:loginHttp andProcessDelegate:delegate];
}

- (void)requestDetailCourseWithCourseID:(int)courseID andProcessDelegate:(__weak id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *detailHttp = [HttpConfigCreator getCourseDetailConfigWithCourseID:courseID];
    [self startPostWithConfig:detailHttp andProcessDelegate:delegate];
}

- (void)requestBannerWithDelegate:(__weak id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *bannerHttp = [HttpConfigCreator getBannerHttpConfig];
    [self startPostWithConfig:bannerHttp andProcessDelegate:delegate];
}

- (void)requestAllCourseWithProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *allCourseHttp = [HttpConfigCreator getAllCourseConfig];
    [self startPostWithConfig:allCourseHttp andProcessDelegate:delegate];
}

- (void)requestQuestionWithPageIndex:(int)pageIndex withProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *questionHttp = [HttpConfigCreator getQuestionConfigWithPageCount:pageIndex];
    [self startPostWithConfig:questionHttp andProcessDelegate:delegate];
}

- (void)requestQuestionDetailWithQuestionId:(int)questionId withProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *questionDetailHttp = [HttpConfigCreator getQuestionDetailConfigWithQuestionId:questionId];
    [self startPostWithConfig:questionDetailHttp andProcessDelegate:delegate];
}

- (void)requestAllCourseCategoryWithProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *categoryHttp = [HttpConfigCreator getAllCategoryConfig];
    [self startPostWithConfig:categoryHttp andProcessDelegate:delegate];
}

- (void)requestCategoryDetailWithCategoryId:(int)categoryId andUserId:(int)userId andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *categoryDetailHttp = [HttpConfigCreator getCategoryDetailConfigWithCategoryId:categoryId andUserId:userId];
    [self startPostWithConfig:categoryDetailHttp andProcessDelegate:delegate];
}

- (void)requestResetPwdWithOldPassword:(NSString *)oldPwd andNewPwd:(NSString *)newPwd andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *reset = [HttpConfigCreator getResetPwdConfigWithOldPwd:oldPwd andNewPwd:newPwd];
    [self startPostWithConfig:reset andProcessDelegate:delegate];
}

- (void)requestQuestionPublishWithInfo:(NSDictionary *)questionInfo andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *publish = [HttpConfigCreator getPublishConfigWithInfo:questionInfo];
    [self startPostWithConfig:publish andProcessDelegate:delegate];
}

- (void)requestHistoryCourseWithProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *history = [HttpConfigCreator getHistoryConfig];
    [self startPostWithConfig:history andProcessDelegate:delegate];
}

- (void)requestAddHistoryInfoWithInfo:(NSDictionary *)info
{
    HttpConfigModel *add = [HttpConfigCreator getAddHistoryConfigWithInfo:info];
    [self startPostWithConfig:add andProcessDelegate:nil];
}

- (void)requestAllMyNoteWithProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *note = [HttpConfigCreator getAllMyNoteConfig];
    [self startPostWithConfig:note andProcessDelegate:delegate];
}

- (void)requestAddVideoNoteWithInfo:(NSDictionary *)info andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *add = [HttpConfigCreator getAddVideoNoteConfigWithInfo:info];
    [self startPostWithConfig:add andProcessDelegate:delegate];
}

- (void)requestDeleteVideoNoteWithId:(int)noteId andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *delete = [HttpConfigCreator getDeleteVideoNoteConfigWithId:noteId];
    [self startPostWithConfig:delete andProcessDelegate:delegate];
}

- (void)requestLearingCourseWithInfoDic:(NSDictionary *)infoDic ProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *learning = [HttpConfigCreator getLearningConfig:infoDic];
    [self startPostWithConfig:learning andProcessDelegate:delegate];
}

- (void)requestCollectCourseWithProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *collect = [HttpConfigCreator getCollectConfig];
    [self startPostWithConfig:collect andProcessDelegate:delegate];
}

- (void)requestMyQuestionAlreadyReplyWithProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *a = [HttpConfigCreator getMyQuestionAlreadyReplyConfig];
    [self startPostWithConfig:a andProcessDelegate:delegate];
}

- (void)requestMyQuestionNotReplyWithProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *b = [HttpConfigCreator getMyQuestionNotReplyConfig];
    [self startPostWithConfig:b andProcessDelegate:delegate];
}

- (void)requestTestAllCategoryWithProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *cate = [HttpConfigCreator getTestAllCategoryConfig];
    [self startPostWithConfig:cate andProcessDelegate:delegate];
}

- (void)requestTestChapterInfoWithCateId:(int)cateId andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *c = [HttpConfigCreator getTestChapterInfoWithId:cateId];
    [self startPostWithConfig:c andProcessDelegate:delegate];
}

- (void)requestAddCollectCourseWithCourseId:(int)courseId andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *add = [HttpConfigCreator getAddCollectCourseConfigWithCourseId:courseId];
    [self startPostWithConfig:add andProcessDelegate:delegate];
}

- (void)requestDeleteCollectCourseWithCourseId:(int)courseId andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *delete = [HttpConfigCreator getDeleteCollectCourseConfigWithCourseId:courseId];
    [self startPostWithConfig:delete andProcessDelegate:delegate];
}

- (void)requestDeleteMyLearningCourseWithCourseInfo:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *delete = [HttpConfigCreator getDeleteMyCourseConfigWithCourseInfo:infoDic];
    [self startPostWithConfig:delete andProcessDelegate:delegate];
}

- (void)requestTestSectionQuestionWithSectionId:(int)sectionId andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *sec = [HttpConfigCreator getTestSectionInfoWithId:sectionId];
    [self startPostWithConfig:sec andProcessDelegate:delegate];
}

- (void)requestTestSimulateInfoWithCateId:(int)cateId andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *s = [HttpConfigCreator getTestSimulateInfoWithId:cateId];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestTestSimulateQuestionWithTestId:(int)testId andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *s = [HttpConfigCreator getTestSimulateQuestionWithId:testId];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestTestSimulateScoreWithInfo:(NSArray *)array andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *s = [HttpConfigCreator getTestSimulateScoreWithInfo:array];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)reqeustAppVersionInfoWithProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *s = [HttpConfigCreator getAppVersionInfoConfig];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestTestErrorInfoWithCateId:(int)cateId andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *s = [HttpConfigCreator getTestErrorInfoWithId:cateId];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)reqeustTestErrorQuesitonWithSectionId:(NSDictionary *)sectionInfo andProcessDelegate:(id<HttpRequestProtocol>)delegate;
{
    HttpConfigModel *s = [HttpConfigCreator getTestErrorQuestionWithSectionId:sectionInfo];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)reqestTestAddMyWrongQuestionWithQuestionId:(int)questionId andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *s = [HttpConfigCreator getTestAddMyWrongQuestionWithQuestionId:questionId];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestTestMyWrongChapterInfoWithCategoryId:(int)cateId andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *s = [HttpConfigCreator getTestMyWrongChapterListWithCategoryId:cateId];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)reqeustTestMyWrongQuestionsWithId:(NSDictionary *)sectionInfo andProcess:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *s = [HttpConfigCreator getTestMyWrongQuestionWithId:sectionInfo ];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestTestCollectInfoWithCateId:(int)cateId andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *s = [HttpConfigCreator getTestCollectionInfoWithCategoryId:cateId];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestTestTestCollectListWithChapter:(NSDictionary *)chapterInfo andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *s = [HttpConfigCreator getTestCollectionQuestionListWithChapterId:chapterInfo ];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)reqeustTestCollectQuestionWithId:(int)questionId andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *s = [HttpConfigCreator getTestCollectQuestionWithQuestionId:questionId];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestTestUncollectQuestionWithId:(int)questionId andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *s = [HttpConfigCreator getTestUncollectQuestionWithQuestionId:questionId];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestTestJurisdictionWithId:(int)courseId andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *s = [HttpConfigCreator getTestJurisdictionWithCourseId:courseId];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)reqeustTestAddQuestionHistoryWithInfo:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *s = [HttpConfigCreator getTestHistoryConfigWithInfo:infoDic];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestTestAddQuestionDetailHistoryWithInfo:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *s = [HttpConfigCreator getTestHistoryDetailConfigWithInfo:infoDic];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)reqeustTestRecordWithInfo:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *s = [HttpConfigCreator testRecordWithInfo:infoDic];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)reqeustTestRecordQuestionWithInfo:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *s = [HttpConfigCreator testRecordQuestionWithInfo:infoDic];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)reqeustTestDailyPracticeWithInfo:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *s = [HttpConfigCreator testDailyPracticeWithInfo:infoDic];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)reqeustTestDailyPracticeQuestionWithInfo:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel *s = [HttpConfigCreator testDailyPracticeQuestionWithInfo:infoDic];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestGetNotStartLivingCourseWithInfo:(NSDictionary *)infoDic ProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator getNotStartLiveingCourseWith:infoDic];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestGetMyLivingCourseWithInfo:(NSDictionary *)infoDic ProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator getMyLiveingCourseWith:infoDic];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestGetEndLivingCourseWithProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator getEndLivingCourse];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestGetLivingSectionDetailWithInfo:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator getLivingSectionDetailWithInfo:infoDic];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)reqeustOrderLivingCourseWithInfo:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator getOrderLivingCourseWithCourseInfo:infoDic];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)reqeustCancelOrderLivingCourseWithInfo:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator getCancelOrderLivingCourseWithCourseInfo:infoDic];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)reqeustBindJPushWithCId:(NSString *)CID andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator getBindJPushWithCId:CID];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)reqeustVerifyAccountWithAccountNumber:(NSString *)AccountNumber andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator getVerifyAccount:AccountNumber];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)reqeustVerifyCodeWithPhoneNumber:(NSString *)phoneNumber andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator getVerifyCode:phoneNumber];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)reqeustRegistWithdic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator registWith:infoDic];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)reqeustForgetPasswordWithDic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator forgetPasswordWith:infoDic];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)reqeustCompleteUserInfoWithDic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator completeUserInfo:infoDic];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)reqeustBindRegCodeWithCode:(NSString *)regCode andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator bindRegCode:regCode];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestPayOrderWith:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator payOrderWithInfo:infoDic];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestDiscountCouponWithInfoDic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator discountCoupon];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestOrderListWithInfoDic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator orderList];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestRecommendWithInfoDic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator recommend];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestGetRecommendWithInfoDic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator getRecommend:infoDic];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestGetRecommendIntegralWithInfoDic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator getRecommendIntegral];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestAssistantCenterWithInfoDic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator getAssistantCnter];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestMemberLevelDetailWithProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator getMemberLevelDetail];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestSubmitOpinionWithInfoDic:(NSDictionary *)infoDic andProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator submitOpinionWithInfo:infoDic];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

- (void)requestCommonProblemWithProcessDelegate:(id<HttpRequestProtocol>)delegate
{
    HttpConfigModel * s = [HttpConfigCreator commonProblem];
    [self startPostWithConfig:s andProcessDelegate:delegate];
}

#pragma mark - post method
- (void)startPostWithConfig:(HttpConfigModel *)configModel andProcessDelegate:(__weak id<HttpRequestProtocol>)delegate
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSLog(@"%@",[configModel.parameters jsonString]);
    [session POST:configModel.urlString parameters:configModel.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        int result = [[responseObject objectForKey:@"result"] intValue];
        NSLog(@"%@",[responseObject description]);
        if (delegate != nil) {
            if (result == 1) {
                [delegate didRequestSuccessed:responseObject];
            }else{
//                NSLog(@"%@",responseObject);
                if ([[responseObject objectForKey:@"errorMsg"] isKindOfClass:[NSNull class]] ||  [[responseObject objectForKey:@"errorMsg"] length] == 0) {
                    [delegate didRequestFailed:@"暂无数据"];
                }else{
                    [delegate didRequestFailed:[responseObject objectForKey:@"errorMsg"]];
                }
            }
        }else{
            return ;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        NSLog(@"****code = %ld \n*** userinfo = %@ \n***%@",error.code,error.userInfo,error.domain);
        if (delegate != nil) {
            [delegate didRequestFailed:kNetError];
        }else{
            return ;
        }
    }];
    
    
    
    /*
     NSURL * url = [NSURL URLWithString:configModel.urlString];
     
     // 创建请求
     NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
     [request setHTTPMethod:@"POST"];
     [request setHTTPBody:[[configModel.parameters jsonString] dataUsingEncoding:NSUTF8StringEncoding]];
     
     NSURLSession *mySession = [NSURLSession sharedSession];
     NSURLSessionTask * task = [mySession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
     if (error) {
     
     if (error.code == -1009) {
     ;
     }
     // 此处如果不返回主线程的话，请求是异步线程，直接执行代理方法可能会修改程序的线程布局，就可能会导致崩溃
     dispatch_sync(dispatch_get_main_queue(), ^{
     
     NSError * error1 = [NSError errorWithDomain:@"" code:10000 userInfo:@{@"Reason":@"服务器连接失败"}];
     });
     NSLog(@"++++++=%@", error);
     
     }else
     {
     
     NSLog(@"+++++++++++++++++++++++++++++++++\njsonStr = %@\n++++++++++++++++", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
     NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
     //            NSLog(@"*****%@", [dic description]);
     // 此处如果不返回主线程的话，请求是异步线程，直接执行代理方法可能会修改程序的线程布局，就可能会导致崩溃
     dispatch_sync(dispatch_get_main_queue(), ^{
     
     if (dic == nil) {
     
     NSError * error = [NSError errorWithDomain:@"" code:10000 userInfo:@{@"Reason":@"服务器处理失败"}];
     
     
     }else
     {
     
     }
     });
     }
     }];
     
     [task resume];
     */
    

    
    
}


@end
