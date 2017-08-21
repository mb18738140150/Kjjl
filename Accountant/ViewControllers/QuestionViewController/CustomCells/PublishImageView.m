//
//  PublishImageView.m
//  Accountant
//
//  Created by aaa on 2017/3/15.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "PublishImageView.h"

@implementation PublishImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
        self.contentImageView.image = [UIImage imageNamed:@"chooseImgIcon.png"];
        [self addSubview:self.contentImageView];
        
        self.closeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-20, 0, 20, 20)];
        [self addSubview:self.closeImageView];
    }
    return self;
}

- (void)resetDefaultImage
{
    self.contentImageView.image = [UIImage imageNamed:@"chooseImgIcon.png"];
}

- (void)showCloseImage
{
    self.closeImageView.image = [UIImage imageNamed:@"photo_delete.png"];
}

- (void)hideCloseImage
{
    self.closeImageView.image = nil;
}

@end
