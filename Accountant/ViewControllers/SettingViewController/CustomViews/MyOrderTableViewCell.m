//
//  MyOrderTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/12/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MyOrderTableViewCell.h"

@interface MyOrderTableViewCell ()

@property (nonatomic, strong)NSDictionary * infoDic;

@end

@implementation MyOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetWithInfo:(NSDictionary *)infoDic
{
    self.infoDic = infoDic;
    
    self.myOrderPayStateBtn.layer.borderColor = UIColorFromRGB(0xff4f00).CGColor;
    self.myOrderPayStateBtn.layer.borderWidth = 1;
    self.myOrderPayStateBtn.layer.cornerRadius = 3;
    self.myOrderPayStateBtn.layer.masksToBounds = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)orderPayStateAction:(id)sender {
    
    if (self.payOrderBlock) {
        self.payOrderBlock(self.infoDic);
    }
    
}

@end
