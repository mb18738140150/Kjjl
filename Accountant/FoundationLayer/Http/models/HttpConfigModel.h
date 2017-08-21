//
//  HttpConfigModel.h
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpConfigModel : NSObject

@property (nonatomic,strong) NSString           *urlString;
@property (nonatomic,strong) NSDictionary       *parameters;
@property (nonatomic,strong) NSNumber           *command;

@end
