//
//  UserModel.m
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.userName forKey:@"userName"];
    [coder encodeObject:@(self.userID) forKey:@"userId"];
    [coder encodeObject:@(self.isLogin) forKey:@"isLogin"];
    [coder encodeObject:self.userNickName forKey:@"userNickName"];
    [coder encodeObject:self.headImageUrl forKey:@"headImageUrl"];
    [coder encodeObject:self.telephone forKey:@"telephone"];
    [coder encodeObject:@(self.level) forKey:@"level"];
    [coder encodeObject:self.rongToken forKey:@"rongToken"];
    [coder encodeObject:self.levelDetail forKey:@"levelDetail"];
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super init] ) {
        self.userName = [coder decodeObjectForKey:@"userName"];
        self.userID = [[coder decodeObjectForKey:@"userId"] intValue];
        self.isLogin = [[coder decodeObjectForKey:@"isLogin"] boolValue];
        self.userNickName = [coder decodeObjectForKey:@"userNickName"];
        self.headImageUrl = [coder decodeObjectForKey:@"headImageUrl"];
        self.telephone = [coder decodeObjectForKey:@"telephone"];
        self.level = [[coder decodeObjectForKey:@"level"] intValue];
        self.rongToken = [coder decodeObjectForKey:@"rongToken"];
        self.levelDetail = [NSString stringWithFormat:@"%@", [coder decodeObjectForKey:@"levelDetail"]];
        
    }
    return self;
}

@end
