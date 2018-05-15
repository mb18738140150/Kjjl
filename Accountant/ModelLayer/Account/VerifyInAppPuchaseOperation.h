//
//  VerifyInAppPuchaseOperation.h
//  Accountant
//
//  Created by aaa on 2018/5/13.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerifyInAppPuchaseOperation : NSObject

- (void)didRequestVerifyInAppPurchaseWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_VerifyInAppPurchase>)object;

@end
