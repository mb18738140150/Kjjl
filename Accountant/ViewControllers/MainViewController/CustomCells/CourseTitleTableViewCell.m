//
//  CourseTitleTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CourseTitleTableViewCell.h"
#import "UIMacro.h"

@interface CourseTitleTableViewCell ()

@property (nonatomic,strong) UILabel        *titleLabel;
@property (nonatomic,strong) UIView         *lineView;
@property (nonatomic,strong) UILabel        *moreLabel;

@end

@implementation CourseTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetSubviewsWithTitle:(NSString *)title withNCourse:(BOOL)nCourse
{
    self.nCourse = nCourse;
    [self resetSubviewsWithTitle:title];
}

- (void)resetSubviewsWithTitle:(NSString *)title
{
    [self.lineView removeFromSuperview];
    [self.titleLabel removeFromSuperview];
    [self.moreLabel removeFromSuperview];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 13, 2, 14)];
    self.lineView.backgroundColor = UIRGBColor(250, 79, 13);
    self.lineView.layer.cornerRadius = 1;
    self.lineView.layer.masksToBounds = YES;
    [self addSubview:self.lineView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.lineView.frame.origin.x + 5, 10, 100, 20)];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.text = title;
    self.titleLabel.textColor = kCommonMainTextColor_50;
    [self addSubview:self.titleLabel];
    
    self.moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 110, 10, 100, 20)];
    self.moreLabel.textAlignment = NSTextAlignmentRight;
    self.moreLabel.font = [UIFont systemFontOfSize:14];
    self.moreLabel.textColor = kCommonMainTextColor_50;
    self.moreLabel.text = @"更多  >";
    if(!self.nCourse){
        [self addSubview:self.moreLabel];
    }
    
}

@end
