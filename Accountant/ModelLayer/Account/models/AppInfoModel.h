//
//  AppInfoModel.h
//  Accountant
//
//  Created by aaa on 2017/3/23.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppInfoModel : NSObject

@property (nonatomic,strong) NSString                   *downloadUrl;
@property (nonatomic,strong) NSString                   *updateContent;
@property (nonatomic,assign) float                       version;

@property (nonatomic,assign) BOOL                        isForce;

@end
