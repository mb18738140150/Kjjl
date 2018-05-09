
//
//  PackageDetailIntroduceCell.m
//  Accountant
//
//  Created by aaa on 2018/4/27.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "PackageDetailIntroduceCell.h"

@implementation PackageDetailIntroduceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetWitnInfo:(NSDictionary *)infoDic
{
    [self.contentView removeAllSubviews];
    self.backgroundColor = [UIColor whiteColor];
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    topView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.contentView addSubview:topView];
    
    self.tipView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, 3, 13)];
    _tipView.backgroundColor = UIRGBColor(241, 82, 58);
    [self.contentView addSubview:_tipView];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(23, 19, kScreenWidth - 23, 15)];
    self.titleLB.text = @"课程介绍";
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.font = kMainFont;
    [self.contentView addSubview:self.titleLB];
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(23, CGRectGetMaxY(self.titleLB.frame) + 10, kScreenWidth - 45, 100)];
    self.textView.editable = NO;
    self.textView.textColor = UIColorFromRGB(0x666666);
    self.textView.font = kMainFont;
    [self.contentView addSubview:self.textView];
    
    NSString * title = [infoDic objectForKey:@"packageIntroduce"];
    NSAttributedString * attributeStr = [[NSAttributedString alloc] initWithData:[title dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    self.textView.attributedText = attributeStr;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
