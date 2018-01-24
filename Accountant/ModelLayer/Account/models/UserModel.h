//
//  UserModel.h
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject<NSCoding>

@property (nonatomic,assign) int                 userID;

@property (nonatomic,assign) BOOL                isLogin;

@property (nonatomic,strong) NSString           *userName;

@property (nonatomic,strong) NSString           *userNickName;

@property (nonatomic,strong) NSString           *headImageUrl;

@property (nonatomic,strong) NSString           *telephone;

@property (nonatomic, strong) NSString          *rongToken;

@property (nonatomic, assign) int               codeview;

/**
 1  :   普通      (啥都不能干)
 2  :   试用      (可以看部分视频)
 3  :   正式      (可以看部分视频)
 */
@property (nonatomic,assign) int                 level;

@property (nonatomic, copy)NSString                *levelDetail;

@end
