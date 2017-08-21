//
//  TestAnswerModel.h
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestAnswerModel : NSObject


/**
 anserId        A B C D...
 */
@property (nonatomic,strong) NSString   *answerId;
@property (nonatomic,strong) NSString   *answerContent;
@property (nonatomic,assign) BOOL        isCorrectAnswer;


@end
