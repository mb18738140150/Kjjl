//
//  PathUtility.m
//  Accountant
//
//  Created by aaa on 2017/3/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "PathUtility.h"

@implementation PathUtility

+ (NSString *)getDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return docDir;
}

@end
