//
//  UploadImageOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/16.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageModuleProtocol.h"

@interface UploadImageOperation : NSObject

- (void)didUploadImage:(NSData *)imageData withNotifiedObject:(id<ImageModule_UploadProtocol>)notifiedObject;

@end
