//
//  MSegmentControl.m
//  Accountant
//
//  Created by aaa on 2017/11/9.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MSegmentControl.h"

#define kBtnTag 10000
#define kBtnWidth (kScreenWidth - 4) / 6

@interface MSegmentControl ()

@property (nonatomic, strong)NSArray *items;

@property (nonatomic, strong)NSMutableArray *btnArr;

@property (nonatomic, strong)UIImageView *arrowImage;

@end

@implementation MSegmentControl

- (NSMutableArray *)btnArr
{
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray *)items
{
    if (self = [super initWithFrame:frame]) {
        self.items = items;
        [self prepareUI];
    }
    
    return self;
}

- (void)prepareUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 12, kScreenWidth, 50)];
    backView.backgroundColor = UIColorFromRGB(0xcccccc);
    [self addSubview:backView];
    
    NSArray * memberDetailList = [[UserManager sharedManager]getLevelDetailList];
    for (int i = 0; i < self.items.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((kBtnWidth + 1) * i, 1, kBtnWidth, 48);
        if (i == 0) {
            button.backgroundColor = UIColorFromRGB(0x4388fb);
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else
        {
            button.backgroundColor = UIColorFromRGB(0xeeeeee);
            [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        }
        [button setTitle:self.items[i] forState:UIControlStateNormal];
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.tag = kBtnTag + i;
        [backView addSubview:button];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnArr addObject:button];
        
        NSDictionary * infoDic = memberDetailList[i];
        if ([[infoDic objectForKey:@"chaozhi"] intValue] == 1) {
            UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame) - 23, button.hd_y - 3, 20, 25)];
            imageview.image = [UIImage imageNamed:@"icon_bq1"];
            [backView addSubview:imageview];
        }
    }
    
    self.arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(kBtnWidth / 2, 61, 8, 8)];
    self.arrowImage.image = [UIImage imageNamed:@"icon_xsj"];
    [self addSubview:self.arrowImage];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.frame = CGRectMake(0, 0, 50, 50);
    
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    bezier.lineWidth = 2;
    
}

- (void)clickAction:(UIButton *)button
{
    int tag = button.tag - kBtnTag;
    
    [self refreshButtonWith:tag];
    
    [self refreshArrowImageView:tag];
    
    if (self.segmentClickBlock) {
        self.segmentClickBlock(tag);
    }
}

- (void)selectWith:(int)tag
{
    [self refreshButtonWith:tag];
    [self refreshArrowImageView:tag];
    if (self.segmentClickBlock) {
        self.segmentClickBlock(tag);
    }
}

- (void)refreshButtonWith:(int)tag
{
    for (int i = 0; i < self.items.count; i++) {
        UIButton * button = self.btnArr[i];
        if (i == tag) {
            dispatch_async(dispatch_get_main_queue(), ^{
                button.backgroundColor = UIColorFromRGB(0x4388fb);
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            });
            
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                button.backgroundColor = UIColorFromRGB(0xeeeeee);
                [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            });
            
        }
    }
}

- (void)refreshArrowImageView:(int )tag
{
    UIButton *button = self.btnArr[tag];
    [UIView animateWithDuration:0.2 animations:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.arrowImage.hd_x = button.hd_centerX;
        });
    }];
}


@end
