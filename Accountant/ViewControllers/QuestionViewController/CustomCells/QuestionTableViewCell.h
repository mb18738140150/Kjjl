//
//  QuestionTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/3/3.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTableViewCell : UITableViewCell

//传入的日期是否是计算过的
@property (nonatomic,assign) BOOL            isCalculatedDate;
//是否显示全问题内容
@property (nonatomic,assign) BOOL            isShowFullContent;

@property (nonatomic,assign) BOOL            isQuestionDetail;

- (void)resetCellWithInfo:(NSDictionary *)dic;

@property (nonatomic, copy)void (^MoreReplyBlock)();

@end
