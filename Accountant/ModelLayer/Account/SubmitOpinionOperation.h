//
//  SubmitOpinionOperation.h
//  Accountant
//
//  Created by aaa on 2018/1/12.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubmitOpinionOperation : NSObject

- (void)didRequestSubmitOpinionWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_SubmitOperationProtocol>)object;

@end
