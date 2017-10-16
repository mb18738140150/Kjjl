//
//  TeacherModel.h
//  Accountant
//
//  Created by aaa on 2017/9/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeacherModel : NSObject

@property (nonatomic, strong)NSString * teacherName;
@property (nonatomic, strong)NSString * teacherId;

- (instancetype)initWithInfoDic:(NSDictionary *)infoDic;
@end
