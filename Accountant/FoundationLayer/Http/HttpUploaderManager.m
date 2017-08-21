//
//  HttpUploaderManager.m
//  Accountant
//
//  Created by aaa on 2017/3/15.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "HttpUploaderManager.h"
#import "AFNetworking.h"
#import "NetMacro.h"
#import "DateUtility.h"
#import "CommonMacro.h"

@implementation HttpUploaderManager

+ (instancetype)sharedManager
{
    static HttpUploaderManager *__manager__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager__ = [[HttpUploaderManager alloc] init];
    });
    return __manager__;
}

- (void)uploadImage:(NSData *)imageData withProcessDelegate:(id)processObject
{
    NSString *picName = [NSString stringWithFormat:@"%@.png",[DateUtility getDateIdString]];
    NSString *uploadPath = [NSString stringWithFormat:@"%@/%@/%@",kUploadRootUrl,[DateUtility getCurrentFormatDateString],picName];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:uploadPath parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:imageData name:@"image"];
    } error:nil];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
        }else{
            NSLog(@"%@",responseObject);
        }
    }];
    [uploadTask resume];
    
    

/*    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *uploadPath = [NSString stringWithFormat:@"%@/%@/%@.png",kUploadRootUrl,[DateUtility getCurrentFormatDateString],[DateUtility getDateIdString]];
    
    NSURL *URL = [NSURL URLWithString:uploadPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromData:imageData progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            if (isObjectNotNil(processObject)) {
                [processObject didUploadSuccess:responseObject];
            }
        }else{
            if (isObjectNotNil(processObject)) {
                NSLog(@"%@",error);
                [processObject didUploadFailed:kNetError];
            }
        }
    }];
    [uploadTask resume];*/
}


@end
