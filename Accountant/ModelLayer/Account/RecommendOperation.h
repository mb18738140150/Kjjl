//
//  RecommendOperation.h
//  Accountant
//
//  Created by aaa on 2017/12/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendOperation : NSObject

@property (nonatomic, assign)int integral;

@property (nonatomic, strong)NSDictionary * recommendInfo;

- (void)didRequestIntegralWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RecommendProtocol>)object;

- (void)didRequestGetIntegralWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RecommendProtocol>)object;

- (void)didRequestGetRecommendIntegralWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RecommendProtocol>)object;

@end
