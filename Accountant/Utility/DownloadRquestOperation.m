//
//  DownloadRquestOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/10.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DownloadRquestOperation.h"

@implementation DownloadRquestOperation

+ (NSString *)getOperation:(NSString *)str
{
    NSArray *array = [str componentsSeparatedByString:@"."];
    NSString *str1 = [str substringToIndex:7];
    NSMutableString *muStr = [[NSMutableString alloc] init];
    [muStr appendString:str1];
    [muStr appendString:@"v1."];
    for (int i = 1; i < array.count - 1;i++) {
        [muStr appendString:[array objectAtIndex:i]];
        [muStr appendString:@"."];
    }
    [muStr appendString:@"kj"];
    
    return muStr;
}

+ (NSString *)getDownloadTaskIdWitChapterId:(NSNumber *)chapterId andVideoId:(NSNumber *)videoId
{
    return [NSString stringWithFormat:@"%@_%@",chapterId,videoId];
}

@end
