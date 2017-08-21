//
//  TestCategoryModel.h
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestCategoryModel : NSObject

@property (nonatomic,assign) int                 categoryId;
@property (nonatomic,strong) NSString           *categoryName;

@property (nonatomic,strong) NSMutableArray     *subCategory;

@end
