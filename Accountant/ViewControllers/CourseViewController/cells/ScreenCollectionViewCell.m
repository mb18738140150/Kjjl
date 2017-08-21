//
//  ScreenCollectionViewCell.m
//  Accountant
//
//  Created by aaa on 2017/4/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "ScreenCollectionViewCell.h"

@implementation ScreenCollectionViewCell

-(void) resetWith:(NSString *)string
{
    self.imageView.hidden = YES;
//    self.seperateLine.hidden = YES;
    
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.text = string;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
