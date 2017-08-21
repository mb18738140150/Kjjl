//
//  UIImage+Base64.m
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "UIImage+Base64.h"

@implementation UIImage (Base64)

- (NSString *)base64
{
    NSData *data = UIImageJPEGRepresentation(self, 0.2f);
//    NSData *data = UIImagePNGRepresentation(self);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

@end
