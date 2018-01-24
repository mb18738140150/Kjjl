//
//  RecommendOperation.m
//  Accountant
//
//  Created by aaa on 2017/12/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "RecommendOperation.h"

#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface RecommendOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_RecommendProtocol> notifiedObject;

@property (nonatomic, strong)NSNumber *commond;
@end

@implementation RecommendOperation


- (void)didRequestIntegralWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RecommendProtocol>)object{
    self.commond = [infoDic objectForKey:kCommand];
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestRecommendWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestGetIntegralWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RecommendProtocol>)object
{
    self.commond = [infoDic objectForKey:kCommand];
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestGetRecommendWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestGetRecommendIntegralWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RecommendProtocol>)object
{
    self.commond = [infoDic objectForKey:kCommand];
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestGetRecommendIntegralWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    switch (self.commond.intValue) {
        case 51:
            self.integral = [[successInfo objectForKey:@"integral"] intValue];
            break;
        case 52:
            self.integral = [[successInfo objectForKey:@"integral"] intValue];
            break;
        case 53:
            self.recommendInfo = successInfo;
            break;
            
        default:
            break;
    }
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestRecommendSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestRecommendFailed:failInfo];
    }
}
@end
