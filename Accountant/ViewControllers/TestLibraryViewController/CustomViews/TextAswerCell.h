//
//  TextAswerCell.h
//  Accountant
//
//  Created by aaa on 2018/4/18.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKPPlaceholderTextView.h"

@interface TextAswerCell : UITableViewCell<UITextViewDelegate>
@property (nonatomic, strong)MKPPlaceholderTextView * opinionTextView;
@property (nonatomic, strong)void (^textAnswerBlock)(NSString * textAnswer);

- (void)resetProperty;

@end
