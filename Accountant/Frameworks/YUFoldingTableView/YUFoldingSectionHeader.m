//
//  YUFoldingSectionHeader.m
//  YUFoldingTableView
//
//  Created by administrator on 16/8/24.
//  Copyright © 2016年 liufengting. All rights reserved.
//

#import "YUFoldingSectionHeader.h"


#define YUFoldingSepertorLineWidth       0.3f
#define YUFoldingMargin                  8.0f
#define YUFoldingIconSize                16.0f

@interface YUFoldingSectionHeader ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) CAShapeLayer *sepertorLine;
@property (nonatomic, assign) YUFoldingSectionHeaderArrowPosition arrowPosition;
@property (nonatomic, assign) YUFoldingSectionState sectionState;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIView        *bottomLineView;

@property (nonatomic, strong) UIView *lineView;


@end

@implementation YUFoldingSectionHeader

-(instancetype)initWithFrame:(CGRect)frame withTag:(NSInteger)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = tag;
        [self setupSubviewsWithArrowPosition:YUFoldingSectionHeaderArrowPositionRight];
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupSubviewsWithArrowPosition:YUFoldingSectionHeaderArrowPositionRight];
    
}


-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
-(UILabel *)descriptionLabel
{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.textAlignment = NSTextAlignmentRight;
    }
    return _descriptionLabel;
}
-(UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _arrowImageView.backgroundColor = [UIColor clearColor];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _arrowImageView;
}
-(CAShapeLayer *)sepertorLine
{
    if (!_sepertorLine) {
        _sepertorLine = [CAShapeLayer layer];
        _sepertorLine.strokeColor = [UIColor whiteColor].CGColor;
        _sepertorLine.lineWidth = YUFoldingSepertorLineWidth;
    }
    return _sepertorLine;
}

-(UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapped:)];
    }
    return _tapGesture;
}

-(UIBezierPath *)getSepertorPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, self.frame.size.height - YUFoldingSepertorLineWidth)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height - YUFoldingSepertorLineWidth)];
    return path;
}


-(void)setupWithBackgroundColor:(UIColor *)backgroundColor
                    titleString:(NSString *)titleString
                     titleColor:(UIColor *)titleColor
                      titleFont:(UIFont *)titleFont
              descriptionString:(NSString *)descriptionString
               descriptionColor:(UIColor *)descriptionColor
                descriptionFont:(UIFont *)descriptionFont
                     arrowImage:(UIImage *)arrowImage
                  arrowPosition:(YUFoldingSectionHeaderArrowPosition)arrowPosition
                   sectionState:(YUFoldingSectionState)sectionState
{
    
    [self setBackgroundColor:backgroundColor];
    
    [self setupSubviewsWithArrowPosition:arrowPosition];
    
    self.titleLabel.text = titleString;
    self.titleLabel.textColor = titleColor;
    self.titleLabel.font = titleFont;
    
    self.descriptionLabel.text = descriptionString;
    self.descriptionLabel.textColor = descriptionColor;
    self.descriptionLabel.font = descriptionFont;
    
    self.arrowImageView.image = arrowImage;
    self.arrowPosition = arrowPosition;
    self.sectionState = sectionState;
    
    if (sectionState == YUFoldingSectionStateShow) {
        if (self.arrowPosition == YUFoldingSectionHeaderArrowPositionRight) {
            self.arrowImageView.transform = CGAffineTransformMakeRotation(-M_PI/2);
        }else{
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
        }
    } else {
        if (self.arrowPosition == YUFoldingSectionHeaderArrowPositionRight) {
            _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
        }else{
            self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
        }
    }
    
}
-(void)setupSubviewsWithArrowPosition:(YUFoldingSectionHeaderArrowPosition)arrowPosition
{
    CGFloat labelWidth = [UIScreen mainScreen].bounds.size.width-45;
    CGFloat labelHeight = self.frame.size.height;
    CGRect arrowRect = CGRectMake(15, (self.frame.size.height - 20)/2, 20, 20);
    CGRect titleRect = CGRectMake(45, 0, labelWidth, labelHeight);
    CGRect descriptionRect = CGRectMake(YUFoldingMargin + YUFoldingIconSize + labelWidth,  0, labelWidth, labelHeight);
    
    [self.titleLabel setFrame:titleRect];
    [self.descriptionLabel setFrame:descriptionRect];
    [self.arrowImageView setFrame:arrowRect];
    [self.sepertorLine setPath:[self getSepertorPath].CGPath];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.descriptionLabel];
    [self addSubview:self.arrowImageView];
    [self addGestureRecognizer:self.tapGesture];
    [self.layer addSublayer:self.sepertorLine];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(self.arrowImageView.frame), 1, 50)];
    self.lineView.backgroundColor = [UIColor colorWithWhite:0.86 alpha:1];
    [self addSubview:self.lineView];
    self.lineView.alpha = 0;
    
    
    self.bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 1, [UIScreen mainScreen].bounds.size.width-10, 1)];
    self.bottomLineView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [self addSubview:self.bottomLineView];
    
}

-(void)shouldExpand:(BOOL)shouldExpand
{
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         if (shouldExpand) {
                             
                             self.lineView.alpha = 1;
                             
                             if (self.arrowPosition == YUFoldingSectionHeaderArrowPositionRight) {
                                 self.arrowImageView.transform = CGAffineTransformMakeRotation(-M_PI/2);
                             }else{
                                 self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
                             }
                         } else {
                             
                             self.lineView.alpha = 0;
                             
                             if (self.arrowPosition == YUFoldingSectionHeaderArrowPositionRight) {
                                 _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
                             }else{
                                 self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
                             }
                         }
                     } completion:^(BOOL finished) {
                         if (finished == YES) {
                             self.sepertorLine.hidden = shouldExpand;
                         }
                     }];
}


-(void)onTapped:(UITapGestureRecognizer *)gesture
{
    [self shouldExpand:![NSNumber numberWithInteger:self.sectionState].boolValue];
    if (_tapDelegate && [_tapDelegate respondsToSelector:@selector(yuFoldingSectionHeaderTappedAtIndex:)]) {
        self.sectionState = [NSNumber numberWithBool:(![NSNumber numberWithInteger:self.sectionState].boolValue)].integerValue;
        [_tapDelegate yuFoldingSectionHeaderTappedAtIndex:self.tag];
    }
}


@end
