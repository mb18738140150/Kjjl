//
//  StudyPlanConditionTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/12/8.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "StudyPlanConditionTableViewCell.h"
#import "StudyPlanConditionView.h"

@interface StudyPlanConditionTableViewCell ()<UITextFieldDelegate>

@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)NSMutableArray * conditionViewsArr;

@property (nonatomic, strong)UITextField * nameTF;

@property (nonatomic, strong)UIButton * manBtn;
@property (nonatomic, strong)UIButton * womanBtn;

@end

@implementation StudyPlanConditionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetWithInfo:(NSDictionary *)infoDic
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    
    self.conditionViewsArr = [NSMutableArray array];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 39)];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.font = kMainFont;
    self.titleLB.textAlignment = NSTextAlignmentRight;
    self.titleLB.text = [infoDic objectForKey:@"title"];
    [self.contentView addSubview:self.titleLB];
    
    switch (self.conditionCellType) {
        case ConditionCellType_condition:
            [self resetConditionView:infoDic];
            break;
        case ConditionCellType_name:
            [self resetNameUI];
            break;
        case ConditionCellType_gender:
            [self resetGenderUI];
            break;
            
        default:
            break;
    }
    
   
}

- (void)resetNameUI
{
    self.nameTF = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLB.frame) + 20, 10, kScreenWidth - 90 - 20, 25)];
    self.nameTF.textColor = UIColorFromRGB(0x333333);
    self.nameTF.font = kMainFont;
    self.nameTF.placeholder = @"请输入姓名";
    self.nameTF.delegate = self;
    self.nameTF.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:self.nameTF];
}

- (void)resetGenderUI
{
    self.manBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.manBtn.frame = CGRectMake(CGRectGetMaxX(self.titleLB.frame) + 20, 10, 55, 25);
    [self.manBtn setTitle:@"男" forState:UIControlStateNormal];
    self.manBtn.titleLabel.font = kMainFont;
    [self.manBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [self.manBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
    self.manBtn.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.contentView addSubview:self.manBtn];
    
    UIBezierPath *bezier = [UIBezierPath bezierPathWithRoundedRect:self.manBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(self.manBtn.hd_height / 2, self.manBtn.hd_height / 2)];
    CAShapeLayer* layer = [CAShapeLayer layer];
    layer.frame = self.manBtn.bounds;
    layer.path = bezier.CGPath;
    self.manBtn.layer.mask = layer;
    
    [self.manBtn addTarget:self action:@selector(manSelect) forControlEvents:UIControlEventTouchUpInside];
    
    self.womanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.womanBtn.frame = CGRectMake(CGRectGetMaxX(self.manBtn.frame), 10, 55, 25);
    [self.womanBtn setTitle:@"女" forState:UIControlStateNormal];
    self.womanBtn.titleLabel.font = kMainFont;
    [self.womanBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [self.womanBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
    self.womanBtn.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.contentView addSubview:self.womanBtn];
    
    UIBezierPath *wbezier = [UIBezierPath bezierPathWithRoundedRect:self.womanBtn.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(self.womanBtn.hd_height / 2, self.womanBtn.hd_height / 2)];
    CAShapeLayer* wlayer = [CAShapeLayer layer];
    wlayer.frame = self.manBtn.bounds;
    wlayer.path = wbezier.CGPath;
    self.womanBtn.layer.mask = wlayer;
    
    [self.womanBtn addTarget:self action:@selector(womanSelect) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)resetConditionView:(NSDictionary *)infoDic
{
    
    NSInteger selecttag = [[self.selectInfoDic objectForKey:@"conditionTag"] integerValue];
    
    __weak typeof(self)weakSelf = self;
    
    NSArray * dataArr = [infoDic objectForKey:@"dataArray"];
    CGFloat conditionViewWidth = 0;
    if (self.conditionType == StudyPlanContition_education || self.conditionType == StudyPlanContition_interest) {
        conditionViewWidth = (kScreenWidth - 90) / 4;
        for (int i = 0; i < dataArr.count; i++) {
            StudyPlanConditionView * studyView = [[StudyPlanConditionView alloc]initWithFrame:CGRectMake(90 + i%4 * conditionViewWidth, 40 * (i / 4), conditionViewWidth, 40)];
            studyView.tag = 1000 + i;
            [studyView resetTitle:dataArr[i]];
            [self.contentView addSubview:studyView];
            [self.conditionViewsArr addObject:studyView];
            if (self.conditionType == StudyPlanContition_interest && i == dataArr.count - 2) {
                studyView.frame = CGRectMake(90 + i%4 * conditionViewWidth, 40 * (i / 4), conditionViewWidth + 20, 40);
                studyView.titleLB.hd_width += 20;
            }
            if (self.conditionType == StudyPlanContition_interest && i == dataArr.count - 1) {
                studyView.hd_x += 20;
            }
            studyView.SelectConditionBlock = ^(NSInteger tag) {
                [weakSelf conditionSelectWith:tag];
            };
            
        }
    }else if (self.conditionType == StudyPlanContition_professionalTitle ) {
        conditionViewWidth = (kScreenWidth - 90) / 2;
        for (int i = 0; i < dataArr.count; i++) {
            StudyPlanConditionView * studyView = [[StudyPlanConditionView alloc]initWithFrame:CGRectMake(90 + i%2 * conditionViewWidth, 40 * (i / 2), conditionViewWidth, 40)];
            studyView.tag = 1000 + i;
            [studyView resetTitle:dataArr[i]];
            [self.contentView addSubview:studyView];
            [self.conditionViewsArr addObject:studyView];
            
            studyView.SelectConditionBlock = ^(NSInteger tag) {
                [weakSelf conditionSelectWith:tag];
            };
            
        }
    }
    else
    {
        conditionViewWidth = (kScreenWidth - 90) / 3;
        for (int i = 0; i < dataArr.count; i++) {
            StudyPlanConditionView * studyView = [[StudyPlanConditionView alloc]initWithFrame:CGRectMake(90 + i%3 * conditionViewWidth, 40 * (i / 3), conditionViewWidth, 40)];
            studyView.tag = 1000 + i;
            [studyView resetTitle:dataArr[i]];
            [self.contentView addSubview:studyView];
            [self.conditionViewsArr addObject:studyView];
            studyView.SelectConditionBlock = ^(NSInteger tag) {
                [weakSelf conditionSelectWith:tag];
            };
        }
    }
    
    if (self.conditionType == [[self.selectInfoDic objectForKey:@"conditionType"] integerValue]) {
        for (StudyPlanConditionView * view in self.conditionViewsArr) {
            if (view.tag - 1000 == selecttag) {
                
                [view selectAction];
            }
        }
    }
    
}

- (void)conditionSelectWith:(NSInteger )tag
{
    for (StudyPlanConditionView * view in self.conditionViewsArr) {
        if (view.tag == tag) {
            [view selectAction];
            
        }else
        {
            [view nomalAction];
        }
    }
    
    
    NSDictionary * conditionInfo = @{@"conditionType":@(self.conditionType),@"conditionTag":@(tag - 1000)};
    if (self.ConditionSelecBlock) {
        self.ConditionSelecBlock(conditionInfo);
    }
    
}

- (void)manSelect
{
    self.womanBtn.selected = NO;
    self.womanBtn.backgroundColor = UIColorFromRGB(0xeeeeee);
    self.manBtn.selected = YES;
    self.manBtn.backgroundColor = UIColorFromRGB(0x3c71fa);
    
    if (self.GenderSelectBlock) {
        self.GenderSelectBlock(@"男");
    }
}

- (void)womanSelect
{
    self.manBtn.selected = NO;
    self.manBtn.backgroundColor = UIColorFromRGB(0xeeeeee);
    self.womanBtn.selected = YES;
    self.womanBtn.backgroundColor = UIColorFromRGB(0x3c71fa);
    if (self.GenderSelectBlock) {
        self.GenderSelectBlock(@"女");
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.nameBlock) {
        self.nameBlock(textField.text);
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
