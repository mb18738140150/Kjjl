//
//  UserModuleModels.m
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "UserModuleModels.h"
#import "PathUtility.h"

@implementation UserModuleModels

- (instancetype)init
{
    if (self = [super init]) {
        [self initalModels];
    }
    return self;
}

- (void)initalModels
{
    
    NSString *dataPath = [[PathUtility getDocumentPath] stringByAppendingPathComponent:@"user.data"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:dataPath]) {
        self.currentUserModel = [NSKeyedUnarchiver unarchiveObjectWithFile:dataPath];
    }else{
        self.currentUserModel = [[UserModel alloc] init];
    }
    
    self.appInfoModel = [[AppInfoModel alloc] init];
}

@end
