//
//  NSDictionary+Unicode.m
//  Accountant
//
//  Created by aaa on 2017/4/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "NSDictionary+Unicode.h"

@implementation NSDictionary (Unicode)

- (NSString *)my_description
{
    NSString *desc = [self my_description];
    desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    return desc;
}

@end
