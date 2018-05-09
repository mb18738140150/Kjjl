//
//  PackageDetailOperation.m
//  Accountant
//
//  Created by aaa on 2018/4/27.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "PackageDetailOperation.h"
#import "CommonMacro.h"
#import "HttpRequestManager.h"

@interface PackageDetailOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) id<CourseModule_PackageDetailProtocol>            notifiedObject;

@end

@implementation PackageDetailOperation

- (void)didRequestPackageDetailWithpackageId:(int)packageId andNotifiedObject:(id<CourseModule_PackageDetailProtocol>)object{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestPackageDetailWithPackageId:packageId andProcessDelegate:self];
}

#pragma mark - http delegate
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    //    NSLog(@"%@", [successInfo description]);
    
    self.infoDic = successInfo;
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didReuquestPackageDetailSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didReuquestPackageDetailFailed:failInfo];
    }
}

@end
