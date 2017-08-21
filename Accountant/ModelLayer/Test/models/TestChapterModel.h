//
//  TestChapterModel.h
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestChapterModel : NSObject

@property (nonatomic,assign) int                     chapterId;
@property (nonatomic,strong) NSString               *chapterName;
@property (nonatomic,assign) int                     chapterQuestionCount;
@property (nonatomic,strong) NSMutableArray         *sectionArray;
@property (nonatomic,assign) int                     chapterParentId;

@end
