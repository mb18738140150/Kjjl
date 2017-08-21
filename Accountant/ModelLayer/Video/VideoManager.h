//
//  VideoManager.h
//  Accountant
//
//  Created by aaa on 2017/3/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoManager : NSObject

+ (instancetype)sharedManager;

- (NSDictionary *)getCurrentVideoInfoWithVideoId:(NSNumber *)videoId;

- (void)writeToDB:(NSDictionary *)dic;

@end
