//
//  BindRegCodeOperation.h
//  Accountant
//
//  Created by aaa on 2017/11/2.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BindRegCodeOperation : NSObject


- (void)didBindRegCodeWithWithCode:(NSString *)regCode withNotifiedObject:(id<UserModule_bindRegCodeProtocol>)object;

@end
