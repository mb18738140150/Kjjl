//
//  HYSegmentedControl.m
//  CustomSegControlView
//
//  Created by sxzw on 14-6-12.
//  Copyright (c) 2014年 sxzw. All rights reserved.
//

#import "HYSegmentedControl.h"

#define HYSegmentedControl_Height 42.0
#define HYSegmentedControl_Width ([UIScreen mainScreen].bounds.size.width)
#define Min_Width_4_Button ([UIScreen mainScreen].bounds.size.width / 5)

#define Define_Tag_add 1000

#define UIColorFromRGBValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface HYSegmentedControl()

@property (strong, nonatomic)UIScrollView *scrollView;
@property (strong, nonatomic)NSMutableArray *array4Btn;
@property (strong, nonatomic)UIView *bottomLineView;
@property (nonatomic, strong)NSMutableArray *separateLineArray;
@property (nonatomic, strong)UIColor * color;

@end

@implementation HYSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithOriginY:(CGFloat)y Titles:(NSArray *)titles delegate:(id)delegate drop:(BOOL)drop
{
    self.drop = drop;
    return [self initWithOriginY:y Titles:titles delegate:delegate];
}

- (id)initWithOriginY:(CGFloat)y Titles:(NSArray *)titles delegate:(id)delegate drop:(BOOL)drop color:(UIColor *)color
{
    self.drop = drop;
    self.color = color;
    return [self initWithOriginY:y Titles:titles delegate:delegate];
}

- (id)initWithOriginX:(CGFloat)X OriginY:(CGFloat)y Titles:(NSArray *)titles delegate:(id)delegate  drop:(BOOL)drop
{
    self.drop = drop;
    return [self initWithOriginX:X OriginY:y Titles:titles delegate:delegate];
}

- (id)initWithOriginX:(CGFloat)X OriginY:(CGFloat)y Titles:(NSArray *)titles delegate:(id)delegate  drop:(BOOL)drop color:(UIColor *)color
{
    self.drop = drop;
    self.color = color;
    return [self initWithOriginX:X OriginY:y Titles:titles delegate:delegate];
}

- (id)initWithOriginY:(CGFloat)y Titles:(NSArray *)titles delegate:(id)delegate
{
    
    return [self initWithOriginX:0 OriginY:y Titles:titles delegate:delegate];
}

- (id)initWithOriginX:(CGFloat)X OriginY:(CGFloat)y Titles:(NSArray *)titles delegate:(id)delegate
{
    if (titles.count == 0) {
        return nil;
    }
    CGRect rect4View = CGRectMake(X, y, HYSegmentedControl_Width , HYSegmentedControl_Height);
    if (self = [super initWithFrame:rect4View]) {
        
        //        self.backgroundColor = UIColorFromRGBValue(0xf3f3f3);
        self.backgroundColor = [UIColor whiteColor];
        [self setUserInteractionEnabled:YES];
        
        self.delegate = delegate;
        
        //
        //  array4btn
        //
        _array4Btn = [[NSMutableArray alloc] initWithCapacity:[titles count]];
        _separateLineArray = [NSMutableArray array];
        //
        //  set button
        //
        CGFloat width4btn = rect4View.size.width/[titles count];
        if (width4btn < Min_Width_4_Button) {
            width4btn = Min_Width_4_Button;
        }
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = self.backgroundColor;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.contentSize = CGSizeMake([titles count]*width4btn, HYSegmentedControl_Height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        for (int i = 0; i<[titles count]; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*width4btn, .0f, width4btn, HYSegmentedControl_Height);
            [btn setTitleColor:UIColorFromRGBValue(0x999999) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            if (self.color) {
                [btn setTitleColor:self.color forState:UIControlStateSelected];
            }else
            {
                [btn setTitleColor:UIColorFromRGBValue(0x1D7AF8) forState:UIControlStateSelected];
            }
            [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = Define_Tag_add+i;
            [_scrollView addSubview:btn];
            [_array4Btn addObject:btn];
            
            if (self.drop) {
                [btn setImage:[UIImage imageNamed:@"tiku-tra2-down"] forState:UIControlStateNormal];
//                btn.imageEdgeInsets = UIEdgeInsetsMake(0, 110, 0, 0);
//                btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.hd_width * 1.5 + 6, 0, 0);
                
            }
            
            if (i == 0) {
                btn.selected = YES;
            }
        }
        
        
        CGFloat height4Line = HYSegmentedControl_Height - 10;
        CGFloat originY = (HYSegmentedControl_Height - height4Line)/2;
        for (int i = 1; i<[titles count]; i++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i*width4btn-1.0f, originY, 1.0f, height4Line)];
            lineView.backgroundColor = UIColorFromRGBValue(0xE6E6E6);
            if (self.color) {
                lineView.hidden = YES;
            }else
            {
                lineView.hidden = NO;
            }
            [_scrollView addSubview:lineView];
            [_separateLineArray addObject:lineView];
        }
        
        //
        //  bottom lineView
        //
        
        UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, HYSegmentedControl_Height-1, _scrollView.contentSize.width, 1.0f)];
        bottomView.backgroundColor = UIColorFromRGBValue(0xC5C5C5);
        [_scrollView addSubview:bottomView];
        
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(.0f, HYSegmentedControl_Height-1, width4btn-0.0f, 1.0f)];
        if (self.color) {
            _bottomLineView.backgroundColor = self.color;
        }else
        {
            _bottomLineView.backgroundColor = UIColorFromRGBValue(0x1D7AF8);
        }
        [_scrollView addSubview:_bottomLineView];
        
        [self addSubview:_scrollView];
    }
    return self;
}

- (void)segmentedControlChange:(UIButton *)btn
{
    [UIView animateWithDuration:0.3 animations:^{
        btn.imageView.transform = CGAffineTransformRotate(btn.imageView.transform, M_PI);
    }];
    
    btn.selected = YES;
    for (UIButton *subBtn in self.array4Btn) {
        if (subBtn != btn) {
            subBtn.selected = NO;
            [UIView animateWithDuration:0.3 animations:^{
                subBtn.imageView.transform = CGAffineTransformMakeRotation(0);
            }];
        }
    }
    
    CGRect rect4boottomLine = self.bottomLineView.frame;
    rect4boottomLine.origin.x = btn.frame.origin.x;
    
    CGPoint pt = CGPointZero;
    BOOL canScrolle = NO;
    if ((btn.tag - Define_Tag_add) >= 2 && [_array4Btn count] > 5 && [_array4Btn count] > (btn.tag - Define_Tag_add + 2)) {
        pt.x = btn.frame.origin.x - Min_Width_4_Button*1.5f;
        canScrolle = YES;
    }else if ([_array4Btn count] > 5 && (btn.tag - Define_Tag_add + 2) >= [_array4Btn count]){
        pt.x = (_array4Btn.count - 5) * Min_Width_4_Button;
        canScrolle = YES;
    }else if (_array4Btn.count > 5 && (btn.tag - Define_Tag_add) < 2){
        pt.x = 0;
        canScrolle = YES;
    }
    
    if (canScrolle) {
        [UIView animateWithDuration:0.003 animations:^{
            _scrollView.contentOffset = pt;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.002 animations:^{
                self.bottomLineView.frame = rect4boottomLine;
            }];
        }];
    }else{
        [UIView animateWithDuration:0.002 animations:^{
            self.bottomLineView.frame = rect4boottomLine;
        }];
    }
    
//    if (btn.enabled == NO) {
//        int tag = btn.tag - 1000;
//        
//        UIView * lineView;
//        if (tag < _separateLineArray.count) {
//            lineView = [_separateLineArray objectAtIndex:tag];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            btn.titleLabel.textColor = [UIColor whiteColor];
//            lineView.backgroundColor = [UIColor whiteColor];
//        });
//    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hySegmentedControlSelectAtIndex:)]) {
        self.selectIndex = btn.tag - 1000;
        [self.delegate hySegmentedControlSelectAtIndex:btn.tag - 1000];
    }
}

#warning ////// index 从 0 开始
// delegete method
- (void)changeSegmentedControlWithIndex:(NSInteger)index
{
    if (index > [_array4Btn count]-1) {
        NSLog(@"index 超出范围");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"index 超出范围" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
        return;
    }
    
    UIButton *btn = [_array4Btn objectAtIndex:index];
    [self segmentedControlChange:btn];
}

- (void)clickBT:(NSInteger)index
{
    UIButton * bt = [_array4Btn   objectAtIndex:index];
    [self segmentedControlChange:bt];
}

- (void)changeTitle:(NSString *)title withIndex:(NSInteger)index
{
    UIButton * bt = [_array4Btn   objectAtIndex:index];
    CGFloat width = [UIUtility getWidthWithText:title font:kMainFont height:15];
    dispatch_async(dispatch_get_main_queue(), ^{
        [bt setTitle:title forState:UIControlStateNormal];
        bt.titleLabel.hd_width = width;
        bt.titleLabel.hd_x = (bt.hd_width - 12 - width) / 2;
        if (self.drop) {
            bt.titleEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 12);
            bt.imageEdgeInsets = UIEdgeInsetsMake(0,width + bt.titleLabel.hd_x, 0, 0);
        }
    });
}

- (void)addTipWithIndex:(NSInteger)index
{
    UIButton * bt = [_array4Btn   objectAtIndex:index];
    dispatch_async(dispatch_get_main_queue(), ^{
        [bt setImage:[UIImage imageNamed:@"message_tip"] forState:UIControlStateNormal];
    });
}

- (void)cancelTipWithIndex:(NSInteger)index
{
    UIButton * bt = [_array4Btn   objectAtIndex:index];
    dispatch_async(dispatch_get_main_queue(), ^{
        [bt setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    });
}

- (void)hideTitlesWith:(NSArray *)titlesArray
{
    for (int i = 0; i < titlesArray.count; i++) {
        int tag = [titlesArray[i] intValue];
        UIButton * bt = [_array4Btn   objectAtIndex:tag];
        bt.enabled = NO;
        UIView * lineView;
        if (tag < _separateLineArray.count) {
            lineView = [_separateLineArray objectAtIndex:tag];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            bt.hidden = YES;
            lineView.hidden = YES;
            bt.titleLabel.textColor = [UIColor whiteColor];
            lineView.backgroundColor = [UIColor whiteColor];
        });
    }
}

- (void)showTitlesWith:(NSArray *)titlesArray
{
    for (int i = 0; i < titlesArray.count; i++) {
        int tag = [titlesArray[i] intValue];
        UIButton * bt = [_array4Btn   objectAtIndex:tag];
        bt.enabled = YES;
        UIView * lineView;
        if (tag < _separateLineArray.count) {
            lineView = [_separateLineArray objectAtIndex:tag];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            bt.hidden = NO;
            lineView.hidden = NO;
            [bt setTitleColor:UIColorFromRGBValue(0x999999) forState:UIControlStateNormal];
            lineView.backgroundColor = UIColorFromRGBValue(0xE6E6E6);
        });
    }
}

- (void)resetColor:(UIColor *)color
{
    for (int i = 0; i < _array4Btn.count; i++) {
        UIButton * bt = [_array4Btn   objectAtIndex:i];
        dispatch_async(dispatch_get_main_queue(), ^{
            [bt setTitleColor:color forState:UIControlStateSelected];
            _bottomLineView.backgroundColor = color;
        });
    }
}
- (void)hideBottomLine
{
    _bottomLineView.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
