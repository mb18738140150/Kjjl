//
//  SlideBlockView.m
//  tiku
//
//  Created by aaa on 2017/5/3.
//  Copyright © 2017年 ytx. All rights reserved.
//

#import "SlideBlockView.h"
#import "UIView+HDExtension.h"
#import "UIMacro.h"

#define minHeight 60
#define MaxHeight [UIScreen mainScreen].bounds.size.height - 64 - 60 - 45 - 60

@implementation SlideBlockView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.backImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.backImageView.image = [UIImage imageNamed:@"mo"];
    
    [self addSubview:self.backImageView];
    self.backImageView.userInteractionEnabled = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.beginPoint = [[touches anyObject] locationInView:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint currentPoint = [[touches anyObject] locationInView:self];
    CGPoint offSetPoint = CGPointMake(currentPoint.x - _beginPoint.x, currentPoint.y - _beginPoint.y);
    
    if (self.frame.origin.y >= minHeight && self.frame.origin.y <= MaxHeight) {
        if (self.frame.origin.y == minHeight) {
            if (offSetPoint.y < 0) {
                return;
            }
        }
        
        if (self.frame.origin.y == MaxHeight) {
            if (offSetPoint.y > 0) {
                return;
            }
        }
        
        self.center = CGPointMake(self.center.x, self.center.y + offSetPoint.y);
        if (self.moveBlock) {
            self.moveBlock(offSetPoint);
        }
    }else
    {
        return;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.frame.origin.y <= minHeight) {
        self.center = CGPointMake(self.center.x, minHeight + self.frame.size.height / 2);
        self.hd_y = minHeight;
    }else if(self.hd_y >= MaxHeight)
    {
        self.center = CGPointMake(self.center.x, MaxHeight + self.hd_height / 2);
        self.hd_y = MaxHeight;
    }
    if (self.moveBlock) {
        self.moveBlock(self.frame.origin);
    }
}

- (void)moveSlideBlock:(MoveConversationViewBlock)block
{
    self.moveBlock = [block copy];
}

@end
