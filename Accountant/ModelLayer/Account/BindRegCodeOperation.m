//
//  BindRegCodeOperation.m
//  Accountant
//
//  Created by aaa on 2017/11/2.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "BindRegCodeOperation.h"
#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"



@interface BindRegCodeOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) id<UserModule_bindRegCodeProtocol> notifiedObject;

@end

@implementation BindRegCodeOperation

- (void)didBindRegCodeWithWithCode:(NSString *)regCode withNotifiedObject:(id<UserModule_bindRegCodeProtocol>)object{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustBindRegCodeWithCode:regCode andProcessDelegate:self];
}

#pragma mark - http request
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestbindRegCodeSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestbindRegCodeFailed:failInfo];
    }
}

@end
