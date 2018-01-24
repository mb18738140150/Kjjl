//
//  MKPPlaceholderTextView.m
//  MKPPlaceholderTextView
//
//  Created by  on 16/11/30.
//  Copyright © 2016年 毛凯平. All rights reserved.
//

#import "MKPPlaceholderTextView.h"

@interface MKPPlaceholderTextView ()
/** 占位文字label */
@property(nonatomic,weak) UILabel *placeholderLabel;
@end
@implementation MKPPlaceholderTextView

-(UILabel *)placeholderLabel
{
    if(!_placeholderLabel)
    {
        // 添加一个用来显示占位文字的label
        UILabel *placeholderLabel = [[UILabel alloc]init];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.hd_x = 4;
        placeholderLabel.hd_y = 7;
        [self addSubview:placeholderLabel];
        _placeholderLabel = placeholderLabel;
    }
    return _placeholderLabel;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        // 垂直方向上永远有弹簧效果
        self.alwaysBounceVertical = YES;
        
        // 默认字体
        self.font = [UIFont systemFontOfSize:15];
        
        // 默认的占位文字颜色
        self.placeholderColor = [UIColor grayColor];
        
        // 监听文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 * 监听文字改变
 */
-(void)textDidChange
{
    // 只要有文字，就隐藏占位文字label
    self.placeholderLabel.hidden = self.hasText;
}

/**
 * 更新占位文字的尺寸
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.placeholderLabel.hd_width = self.hd_width - 2 * self.placeholderLabel.hd_x;
    [self.placeholderLabel sizeToFit];
}

#pragma mark - 重写setter
-(void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholderColor = [placeholder copy];
    self.placeholderLabel.text = placeholder;
    [self setNeedsLayout];
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    
    [self setNeedsLayout];
}

-(void)setText:(NSString *)text
{
    [super setText:text];
    
    [self textDidChange];
}

-(void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self textDidChange];
}

@end
