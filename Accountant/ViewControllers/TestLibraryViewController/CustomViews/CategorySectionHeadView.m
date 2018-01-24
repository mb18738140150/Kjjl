//
//  CategorySectionHeadView.m
//  tiku
//
//  Created by aaa on 2017/5/16.
//  Copyright © 2017年 ytx. All rights reserved.
//

#import "CategorySectionHeadView.h"
#import "ProcessView.h"

#define YUFoldingSepertorLineWidth       0.3f
#define YUFoldingMargin                  8.0f
#define YUFoldingIconSize                16.0f

@interface CategorySectionHeadView()

@property (nonatomic, strong)UIImageView * showStateImageView;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel * questionCountLabel;
@property (nonatomic, strong)UILabel *learnPepleCountLB;
@property (nonatomic, strong)ProcessView * learnProcessView;
@property (nonatomic, strong)UIImageView *learnImageView;
@property (nonatomic, strong)UILabel * totalCountLB;

@property (nonatomic, strong) CAShapeLayer *sepertorLine;
@property (nonatomic, assign) MFoldingSectionHeaderArrowPosition arrowPosition;
@property (nonatomic, assign) MFoldingSectionState sectionState;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIView        *bottomLineView;


@end

@implementation CategorySectionHeadView

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;

    }
    return _titleLabel;
}
-(UILabel *)questionCountLabel
{
    if (!_questionCountLabel) {
        _questionCountLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _questionCountLabel.backgroundColor = [UIColor clearColor];
        _questionCountLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _questionCountLabel;
}

-(UILabel *)learnPepleCountLB
{
    if (!_learnPepleCountLB) {
        _learnPepleCountLB = [[UILabel alloc]initWithFrame:CGRectZero];
        _learnPepleCountLB.backgroundColor = [UIColor clearColor];
        _learnPepleCountLB.textAlignment = NSTextAlignmentLeft;
    }
    return _learnPepleCountLB;
}

-(UIImageView *)learnImageView
{
    if (!_learnImageView) {
        _learnImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _learnImageView.backgroundColor = [UIColor clearColor];
    }
    return _learnImageView;
}


- (UILabel *)totalCountLB
{
    if (!_totalCountLB) {
        _totalCountLB = [[UILabel alloc]initWithFrame:CGRectZero];
        _totalCountLB.backgroundColor = [UIColor clearColor];
        _totalCountLB.textAlignment = NSTextAlignmentRight;
        _totalCountLB.textColor = kMainTextColor_100;
        _totalCountLB.font = [UIFont systemFontOfSize:12];
    }
    return _totalCountLB;
}

-(UIImageView *)showStateImageView
{
    if (!_showStateImageView) {
        _showStateImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _showStateImageView.backgroundColor = [UIColor clearColor];
        _showStateImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _showStateImageView;
}
-(CAShapeLayer *)sepertorLine
{
    if (!_sepertorLine) {
        _sepertorLine = [CAShapeLayer layer];
        _sepertorLine.strokeColor = kCommonNavigationBarColor.CGColor;
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

-(instancetype)initWithFrame:(CGRect)frame withTag:(NSInteger)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = tag;
        [self setupSubviewsWithArrowPosition:MFoldingSectionHeaderArrowPositionRight];
    }
    return self;
}

-(void)setupWithBackgroundColor:(UIColor *)backgroundColor
                    titleString:(NSString *)titleString
                     titleColor:(UIColor *)titleColor
                      titleFont:(UIFont *)titleFont
              descriptionString:(NSString *)descriptionString
               descriptionColor:(UIColor *)descriptionColor
                descriptionFont:(UIFont *)descriptionFont
              peopleCountString:(NSString *)peopleCountString
               peopleCountColor:(UIColor *)peopleCountColor
                peopleCountFont:(UIFont *)peopleCountFont
                     arrowImage:(UIImage *)arrowImage
                     learnImage:(UIImage *)learnImage
                  arrowPosition:(MFoldingSectionHeaderArrowPosition)arrowPosition
                   sectionState:(MFoldingSectionState)sectionState
{
    
    [self setBackgroundColor:backgroundColor];
    
    [self setupSubviewsWithArrowPosition:arrowPosition];
    
    self.titleLabel.text = titleString;
    self.titleLabel.textColor = titleColor;
    self.titleLabel.font = titleFont;
    
    self.questionCountLabel.text = descriptionString;
    self.questionCountLabel.textColor = descriptionColor;
    self.questionCountLabel.font = descriptionFont;
    
    self.learnPepleCountLB.text = peopleCountString;
    self.learnPepleCountLB.textColor = peopleCountColor;
    self.learnPepleCountLB.font = peopleCountFont;
    
    self.showStateImageView.image = arrowImage;
    self.learnImageView.image = learnImage;
    self.arrowPosition = arrowPosition;
    self.sectionState = sectionState;
    
    
    NSArray * countArray = [descriptionString componentsSeparatedByString:@"/"];
    NSInteger writeCount = [countArray[0] integerValue];
    NSInteger totalCount = [countArray[1] integerValue];
    
    self.learnProcessView.progress = writeCount * 1.0 / totalCount;
    self.totalCountLB.text = [NSString stringWithFormat:@"%d", totalCount];
    if (sectionState == MFoldingSectionStateShow) {
        self.lineView.alpha = 1;
        
        if (self.arrowPosition == MFoldingSectionHeaderArrowPositionRight) {
            
            self.showStateImageView.image = [UIImage imageNamed:@"tiku_minus"];
        }else{
            
            self.showStateImageView.image = [UIImage imageNamed:@"tiku_minus"];
        }
    } else {
        self.lineView.alpha = 0;
        if (self.arrowPosition == MFoldingSectionHeaderArrowPositionRight) {
            
            self.showStateImageView.image = [UIImage imageNamed:@"tiku_plus"];
        }else{
            
            self.showStateImageView.image = [UIImage imageNamed:@"tiku_plus"];
        }
    }
    
    if (!self.isChapter) {
        self.titleLabel.hd_centerY = self.hd_centerY;
        self.showStateImageView.hd_centerY = self.hd_centerY;
        self.totalCountLB.hidden = YES;
        self.learnProcessView.hidden = YES;
        self.questionCountLabel.frame = CGRectMake(kScreenWidth - 35 - 10 - 80, self.learnImageView.hd_centerY - 6, 80, 12);
        self.questionCountLabel.textAlignment = NSTextAlignmentCenter;
        self.lineView.backgroundColor = UIColorFromRGB(0xdddddd);
        self.questionCountLabel.attributedText = [self getQuestionStrWith:descriptionString and:countArray[0]];
        self.titleLabel.hd_width = kScreenWidth - 38 - 125;
    }
    
    [self insertSubview:self.lineView belowSubview:self.showStateImageView];
}


- (NSMutableAttributedString *)getQuestionStrWith:(NSString *)str and:(NSString *)dStr
{
    NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSDictionary * attribute = @{NSForegroundColorAttributeName:UIColorFromRGB(0xff8400)};
    [mStr setAttributes:attribute range:NSMakeRange(0, dStr.length)];
    
    return mStr;
}


-(void)setupVideoWithBackgroundColor:(UIColor *)backgroundColor
                         titleString:(NSString *)titleString
                          titleColor:(UIColor *)titleColor
                           titleFont:(UIFont *)titleFont
                          arrowImage:(UIImage *)arrowImage
                          learnImage:(UIImage *)learnImage
                       arrowPosition:(MFoldingSectionHeaderArrowPosition)arrowPosition
                        sectionState:(MFoldingSectionState)sectionState
{
    [self setBackgroundColor:backgroundColor];
    
    [self setupVideoSubviewsWithArrowPosition:arrowPosition];
    
    self.titleLabel.text = titleString;
    self.titleLabel.textColor = titleColor;
    self.titleLabel.font = titleFont;
    
    
    self.showStateImageView.image = arrowImage;
    self.learnImageView.image = learnImage;
    self.arrowPosition = arrowPosition;
    self.sectionState = sectionState;

    if (sectionState == MFoldingSectionStateShow) {
        self.lineView.alpha = 1;
        
        if (self.arrowPosition == MFoldingSectionHeaderArrowPositionRight) {
            
            self.showStateImageView.image = [UIImage imageNamed:@"tiku_minus"];
        }else{
            
            self.showStateImageView.image = [UIImage imageNamed:@"tiku_minus"];
        }
    } else {
        self.lineView.alpha = 0;
        if (self.arrowPosition == MFoldingSectionHeaderArrowPositionRight) {
            
            self.showStateImageView.image = [UIImage imageNamed:@"tiku_plus"];
        }else{
            
            self.showStateImageView.image = [UIImage imageNamed:@"tiku_plus"];
        }
    }
    
    self.questionCountLabel.hidden = YES;
    self.learnPepleCountLB.hidden = YES;
    self.learnProcessView.hidden = YES;
    self.totalCountLB.hidden = YES;

}

-(void)setupSubviewsWithArrowPosition:(MFoldingSectionHeaderArrowPosition)arrowPosition
{
    
    [self removeAllSubviews];
    
    CGFloat labelWidth = [UIScreen mainScreen].bounds.size.width-45;
    CGFloat labelHeight = 15;
    CGFloat labelHeight1 = 12;
    CGFloat labelWidth1 = 80;
    CGRect arrowRect = CGRectMake(15, 10, 20, 20);
    CGRect titleRect = CGRectMake(CGRectGetMaxX(arrowRect) + YUFoldingMargin, YUFoldingMargin, labelWidth, labelHeight);
    CGRect questionCountRect = CGRectMake(titleRect.origin.x,  CGRectGetMaxY(titleRect) + YUFoldingMargin, labelWidth1, labelHeight1);
    CGRect learnPeopleRect = CGRectMake(CGRectGetMaxX(questionCountRect) + 5,  CGRectGetMaxY(titleRect) + YUFoldingMargin, 100, labelHeight1);
    CGRect learnImageRect = CGRectMake([UIScreen mainScreen].bounds.size.width - 10 - 25, (self.frame.size.height - 25) / 2, 25, 25);
    
    [self.showStateImageView setFrame:arrowRect];
    [self.titleLabel setFrame:titleRect];
    [self.questionCountLabel setFrame:questionCountRect];
    [self.learnPepleCountLB setFrame:learnPeopleRect];
    [self.learnImageView setFrame:learnImageRect];
    [self.sepertorLine setPath:[self getSepertorPath].CGPath];
    [self.totalCountLB setFrame:CGRectMake(self.learnImageView.hd_x - 100, self.learnImageView.hd_y, 90, 25)];
    
    [self addSubview:self.showStateImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.questionCountLabel];
    [self addSubview:self.learnPepleCountLB];
    [self addSubview:self.learnImageView];
    [self addGestureRecognizer:self.tapGesture];
    [self addSubview:self.totalCountLB];
    
    self.learnProcessView = [[ProcessView alloc]initWithFrame:CGRectMake(titleRect.origin.x, self.frame.size.height - 13, 230, 5)];
    [self addSubview:self.learnProcessView];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(25, 30, 0.7, self.frame.size.height - 30)];
    
    self.lineView.backgroundColor = [UIColor blueColor];
    [self addSubview:self.lineView];
    self.lineView.alpha = 0;
    
    self.bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
    self.bottomLineView.backgroundColor = kBackgroundGrayColor;
    [self addSubview:self.bottomLineView];
    
}

-(void)setupVideoSubviewsWithArrowPosition:(MFoldingSectionHeaderArrowPosition)arrowPosition
{
    [self removeAllSubviews];
    
    CGFloat labelWidth = [UIScreen mainScreen].bounds.size.width-45;
    CGFloat labelHeight = 15;
    CGFloat labelHeight1 = 12;
    CGFloat labelWidth1 = 80;
    CGRect arrowRect = CGRectMake(15, 15, 20, 20);
    CGRect titleRect = CGRectMake(CGRectGetMaxX(arrowRect) + YUFoldingMargin, 17, labelWidth, labelHeight);
    CGRect questionCountRect = CGRectMake(titleRect.origin.x,  CGRectGetMaxY(titleRect) + YUFoldingMargin, labelWidth1, labelHeight1);
    CGRect learnPeopleRect = CGRectMake(CGRectGetMaxX(questionCountRect) + 5,  CGRectGetMaxY(titleRect) + YUFoldingMargin, 100, labelHeight1);
    CGRect learnImageRect = CGRectMake([UIScreen mainScreen].bounds.size.width - 10 - 25, (self.frame.size.height - 25) / 2, 25, 25);
    
    [self.showStateImageView setFrame:arrowRect];
    [self.titleLabel setFrame:titleRect];
    [self.questionCountLabel setFrame:questionCountRect];
    [self.learnPepleCountLB setFrame:learnPeopleRect];
    [self.learnImageView setFrame:learnImageRect];
    [self.sepertorLine setPath:[self getSepertorPath].CGPath];
    [self.totalCountLB setFrame:CGRectMake(self.learnImageView.hd_x - 100, self.learnImageView.hd_y, 90, 25)];
    
    [self addSubview:self.showStateImageView];
    [self addSubview:self.titleLabel];
//    [self addSubview:self.learnImageView];
    [self addGestureRecognizer:self.tapGesture];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(25, 30, 0.7, self.frame.size.height - 30)];
    self.lineView.backgroundColor = [UIColor blueColor];
    [self addSubview:self.lineView];
    self.lineView.alpha = 0;
    
    self.bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
    self.bottomLineView.backgroundColor = kBackgroundGrayColor;
    [self addSubview:self.bottomLineView];
    
}

-(UIBezierPath *)getSepertorPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, self.frame.size.height - YUFoldingSepertorLineWidth)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height - YUFoldingSepertorLineWidth)];
    return path;
}

-(void)shouldExpand:(BOOL)shouldExpand
{
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         if (shouldExpand) {
                             
                             self.lineView.alpha = 1;
                             
                             if (self.arrowPosition == MFoldingSectionHeaderArrowPositionRight) {

                                 self.showStateImageView.image = [UIImage imageNamed:@"tiku_minus"];
                             }else{

                                 self.showStateImageView.image = [UIImage imageNamed:@"tiku_minus"];
                             }
                         } else {
                             self.lineView.alpha = 0;
                             if (self.arrowPosition == MFoldingSectionHeaderArrowPositionRight) {

                                 self.showStateImageView.image = [UIImage imageNamed:@"tiku_plus"];
                             }else{

                                 self.showStateImageView.image = [UIImage imageNamed:@"tiku_plus"];
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
    
    if (_tapDelegate && [_tapDelegate respondsToSelector:@selector(MFoldingSectionHeaderTappedAtIndex:)]) {
        self.sectionState = [NSNumber numberWithBool:(![NSNumber numberWithInteger:self.sectionState].boolValue)].integerValue;
        [_tapDelegate MFoldingSectionHeaderTappedAtIndex:self.tag];
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
