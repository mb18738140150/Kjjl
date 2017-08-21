//
//  MyQuestionTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/3/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyQuestionTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel            *contentLabel;
@property (nonatomic,strong) UILabel            *replyInfoLabel;

- (void)resetContentWithInfo:(NSDictionary *)infoDic andIsReply:(BOOL)isReply;

@end
