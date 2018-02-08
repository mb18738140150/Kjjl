//
//  SubmitGiftCodeOperation.h
//  Accountant
//
//  Created by aaa on 2018/2/5.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubmitGiftCodeOperation : NSObject
- (void)didRequestSubmitGiftCodeWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_SubmitGiftCode>)object;
@end
