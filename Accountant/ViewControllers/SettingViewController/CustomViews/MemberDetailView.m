//
//  MemberDetailView.m
//  Accountant
//
//  Created by aaa on 2017/11/9.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "MemberDetailView.h"

#import "MemberCourse.h"
#import "MemberCourseDetailView.h"
#import "MemberCoursePriceView.h"

#define kunitWidth (kScreenWidth - 20) / 15
#define kSpace 10

@interface MemberDetailView ()

@property (nonatomic, strong)UIScrollView * scrollView;

@property (nonatomic, strong)UILabel * priceLB;
// 视频课程
@property (nonatomic, strong)MemberCourse *spkcView;
@property (nonatomic, strong)MemberCoursePriceView * tkscView;
@property (nonatomic, strong)MemberCoursePriceView *luboView;
@property (nonatomic, strong)MemberCoursePriceView *zbkcView;
@property (nonatomic, strong)MemberCoursePriceView *zbhfView;

// 答疑服务
@property (nonatomic, strong)MemberCourse *dView;
@property (nonatomic, strong)MemberCoursePriceView *sxxtView;
@property (nonatomic, strong)MemberCoursePriceView *dyfwView;
@property (nonatomic, strong)MemberCoursePriceView *dyscView;
@property (nonatomic, strong)MemberCoursePriceView *lxxzxxView;

// 学习包
@property (nonatomic, strong)MemberCourse *xxbView;
@property (nonatomic, strong)MemberCoursePriceView *sgzxxbView;
@property (nonatomic, strong)MemberCoursePriceView *tszlView;
@property (nonatomic, strong)MemberCoursePriceView *zsxxjhView;

// 职称考试
@property (nonatomic, strong)MemberCourse *zcksView;
@property (nonatomic, strong)MemberCoursePriceView *cjzcView;
@property (nonatomic, strong)MemberCoursePriceView *zjzcView;
@property (nonatomic, strong)MemberCoursePriceView *zckjsView;

@property (nonatomic, strong)UIView * bottomView;
@property (nonatomic, strong)UIButton *cansultBtn;
@property (nonatomic, strong)UIButton *buyBtn;

@property (nonatomic, assign)MemberLevel level;

@end

@implementation MemberDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_height)];
    [self addSubview:self.scrollView];
    
    UILabel * xiangmuLB = [[UILabel alloc]initWithFrame:CGRectMake(kSpace, 0, kunitWidth * 6, 50)];
    xiangmuLB.text = @"项目";
    xiangmuLB.textColor = UIColorFromRGB(0x333333);
    xiangmuLB.backgroundColor = UIColorFromRGB(0xeeeeee);
    xiangmuLB.textAlignment = 1;
    xiangmuLB.font = kMainFont;
    xiangmuLB.layer.borderWidth = 1;
    xiangmuLB.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    [self.scrollView addSubview:xiangmuLB];
    
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(xiangmuLB.frame) - 1, 0, kunitWidth * 9, 50)];
    self.priceLB.textAlignment = 1;
    self.priceLB.textColor = UIColorFromRGB(0x333333);
    self.priceLB.backgroundColor = UIColorFromRGB(0xeeeeee);
    self.priceLB.font = kMainFont;
    self.priceLB.layer.borderWidth = 1;
    self.priceLB.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    [self.scrollView addSubview:self.priceLB];
    
    [self addSpkcView];
    [self addDyfwView];
    [self addXxbiew];
    [self addZcksiew];
    
    [self addBottomView];
    
}

- (void)addSpkcView
{
    self.spkcView = [[MemberCourse alloc]initWithFrame:CGRectMake(kSpace, CGRectGetMaxY(self.priceLB.frame), kunitWidth * 2, 104) andTitle:@"视频课程"];
    [self.scrollView addSubview:self.spkcView];
    
    MemberCourseDetailView * tingkeView = [[MemberCourseDetailView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.spkcView.frame), self.spkcView.hd_y, kunitWidth * 4, 26) andTitle:@"听课时长"];
    self.tkscView = [[MemberCoursePriceView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tingkeView.frame) - 1, tingkeView.hd_y, kunitWidth * 9, 26)];
    [self.scrollView addSubview:tingkeView];
    [self.scrollView addSubview:self.tkscView];
    
    
    MemberCourseDetailView * luboView = [[MemberCourseDetailView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.spkcView.frame), CGRectGetMaxY(self.tkscView.frame), kunitWidth * 4, 26) andTitle:@"录播"];
    self.luboView = [[MemberCoursePriceView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(luboView.frame) - 1, luboView.hd_y, kunitWidth * 9, 26)];
    [self.scrollView addSubview:luboView];
    [self.scrollView addSubview:self.luboView];
    
    MemberCourseDetailView * zhibokeView = [[MemberCourseDetailView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.spkcView.frame), CGRectGetMaxY(self.luboView.frame), kunitWidth * 4, 26) andTitle:@"直播课程"];
    self.zbkcView = [[MemberCoursePriceView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(zhibokeView.frame) - 1, zhibokeView.hd_y, kunitWidth * 9, 26)];
    [self.scrollView addSubview:zhibokeView];
    [self.scrollView addSubview:self.zbkcView];
    
    MemberCourseDetailView * huifangView = [[MemberCourseDetailView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.spkcView.frame), CGRectGetMaxY(self.zbkcView.frame), kunitWidth * 4, 26) andTitle:@"直播回放"];
    self.zbhfView = [[MemberCoursePriceView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(huifangView.frame) - 1, huifangView.hd_y, kunitWidth * 9, 26)];
    [self.scrollView addSubview:huifangView];
    [self.scrollView addSubview:self.zbhfView];
    
}

- (void)addDyfwView
{
    self.dView = [[MemberCourse alloc]initWithFrame:CGRectMake(kSpace, CGRectGetMaxY(self.spkcView.frame), kunitWidth * 2, 104) andTitle:@"答疑服务"];
    [self.scrollView addSubview:self.dView];
    
    MemberCourseDetailView * shixunView = [[MemberCourseDetailView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.dView.frame), self.dView.hd_y, kunitWidth * 4, 26) andTitle:@"实训系统"];
    self.sxxtView = [[MemberCoursePriceView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shixunView.frame) - 1, shixunView.hd_y, kunitWidth * 9, 26)];
    [self.scrollView addSubview:shixunView];
    [self.scrollView addSubview:self.sxxtView];
    
    
    MemberCourseDetailView * dayifuwuView = [[MemberCourseDetailView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.dView.frame), CGRectGetMaxY(self.sxxtView.frame), kunitWidth * 4, 26) andTitle:@"答疑服务"];
    self.dyfwView = [[MemberCoursePriceView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dayifuwuView.frame) - 1, dayifuwuView.hd_y, kunitWidth * 9, 26)];
    [self.scrollView addSubview:dayifuwuView];
    [self.scrollView addSubview:self.dyfwView];
    
    MemberCourseDetailView * dayishichangView = [[MemberCourseDetailView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.dView.frame), CGRectGetMaxY(self.dyfwView.frame), kunitWidth * 4, 26) andTitle:@"答疑时长"];
    self.dyscView = [[MemberCoursePriceView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dayishichangView.frame) - 1, dayishichangView.hd_y, kunitWidth * 9, 26)];
    [self.scrollView addSubview:dayishichangView];
    [self.scrollView addSubview:self.dyscView];
    
    MemberCourseDetailView * lixainView = [[MemberCourseDetailView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.dView.frame), CGRectGetMaxY(self.dyscView.frame), kunitWidth * 4, 26) andTitle:@"离线下载学习"];
    self.lxxzxxView = [[MemberCoursePriceView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lixainView.frame) - 1, lixainView.hd_y, kunitWidth * 9, 26)];
    [self.scrollView addSubview:lixainView];
    [self.scrollView addSubview:self.lxxzxxView];
}

- (void)addXxbiew
{
    self.xxbView = [[MemberCourse alloc]initWithFrame:CGRectMake(kSpace, CGRectGetMaxY(self.dView.frame), kunitWidth * 2, 78) andTitle:@"学习包"];
    [self.scrollView addSubview:self.xxbView];
    
    MemberCourseDetailView * sgzView = [[MemberCourseDetailView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.xxbView.frame), self.xxbView.hd_y, kunitWidth * 4, 26) andTitle:@"手工帐工具包"];
    self.sgzxxbView = [[MemberCoursePriceView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sgzView.frame) - 1, sgzView.hd_y, kunitWidth * 9, 26)];
    [self.scrollView addSubview:sgzView];
    [self.scrollView addSubview:self.sgzxxbView];
    
    
    MemberCourseDetailView * tushuView = [[MemberCourseDetailView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.xxbView.frame), CGRectGetMaxY(self.sgzxxbView.frame), kunitWidth * 4, 26) andTitle:@"图书资料"];
    self.tszlView = [[MemberCoursePriceView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tushuView.frame) - 1, tushuView.hd_y, kunitWidth * 9, 26)];
    [self.scrollView addSubview:tushuView];
    [self.scrollView addSubview:self.tszlView];
    
    MemberCourseDetailView * zhuanshuView = [[MemberCourseDetailView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.xxbView.frame), CGRectGetMaxY(self.tszlView.frame), kunitWidth * 4, 26) andTitle:@"专属学习计划"];
    self.zsxxjhView = [[MemberCoursePriceView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(zhuanshuView.frame) - 1, zhuanshuView.hd_y, kunitWidth * 9, 26)];
    [self.scrollView addSubview:zhuanshuView];
    [self.scrollView addSubview:self.zsxxjhView];
    
}

- (void)addZcksiew
{
    self.zcksView = [[MemberCourse alloc]initWithFrame:CGRectMake(kSpace, CGRectGetMaxY(self.xxbView.frame), kunitWidth * 2, 120) andTitle:@"职称考试"];
    [self.scrollView addSubview:self.zcksView];
    
    MemberCourseDetailView * cjzcView = [[MemberCourseDetailView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.zcksView.frame), self.zcksView.hd_y, kunitWidth * 4, 40) andTitle:@"初级职称\n(单卖900元)"];
    self.cjzcView = [[MemberCoursePriceView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cjzcView.frame) - 1, cjzcView.hd_y, kunitWidth * 9, 40)];
    [self.scrollView addSubview:cjzcView];
    [self.scrollView addSubview:self.cjzcView];
    
    
    MemberCourseDetailView * zjzcView = [[MemberCourseDetailView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.zcksView.frame), CGRectGetMaxY(self.cjzcView.frame), kunitWidth * 4, 40) andTitle:@"中级职称\n(单卖900元)"];
    self.zjzcView = [[MemberCoursePriceView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(zjzcView.frame) - 1, zjzcView.hd_y, kunitWidth * 9, 40)];
    [self.scrollView addSubview:zjzcView];
    [self.scrollView addSubview:self.zjzcView];
    
    MemberCourseDetailView * zhuceView = [[MemberCourseDetailView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.zcksView.frame), CGRectGetMaxY(self.zjzcView.frame), kunitWidth * 4, 40) andTitle:@"注册会计师\n(单卖900元)"];
    self.zckjsView = [[MemberCoursePriceView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(zhuceView.frame) - 1, zhuceView.hd_y, kunitWidth * 9, 40)];
    [self.scrollView addSubview:zhuceView];
    [self.scrollView addSubview:self.zckjsView];
}

- (void)addBottomView
{
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(kSpace, CGRectGetMaxY(self.zcksView.frame), kScreenWidth - 2 * kSpace, 61)];
    [self.scrollView addSubview:self.bottomView];
    
    CAShapeLayer * layer = [[CAShapeLayer alloc]init];
    layer.frame = self.bottomView.bounds;
    
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    bezier.lineWidth = 1;
    [bezier moveToPoint:CGPointMake(0, 0)];
    [bezier addLineToPoint:CGPointMake(0, self.bottomView.hd_height)];
    [bezier addLineToPoint:CGPointMake(self.bottomView.hd_width, self.bottomView.hd_height)];
    [bezier addLineToPoint:CGPointMake(self.bottomView.hd_width, 0)];
    
    layer.path = bezier.CGPath;
    layer.strokeColor = UIColorFromRGB(0xcccccc).CGColor;
    layer.fillColor = [UIColor whiteColor].CGColor;
    [self.bottomView.layer addSublayer:layer];
    
    self.cansultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cansultBtn.frame = CGRectMake((kScreenWidth - 2 * kSpace) / 2 - 120 - 14, 30 - 16.5, 120, 33);
    self.cansultBtn.backgroundColor = UIColorFromRGB(0x4388fb);
    [self.cansultBtn setTitle:@"点击咨询" forState:UIControlStateNormal];
    [self.cansultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cansultBtn.layer.cornerRadius = 4;
    self.cansultBtn.layer.masksToBounds = YES;
    [self.bottomView addSubview:self.cansultBtn];
    
    self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buyBtn.frame = CGRectMake((kScreenWidth - 2 * kSpace) / 2 + 14, 30 - 16.5, 120, 33);
    self.buyBtn.backgroundColor = UIColorFromRGB(0xff740e);
    [self.buyBtn setTitle:@"点击购买" forState:UIControlStateNormal];
    [self.buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.buyBtn.layer.cornerRadius = 4;
    self.buyBtn.layer.masksToBounds = YES;
    [self.bottomView addSubview:self.buyBtn];
    
    [self.cansultBtn addTarget:self action:@selector(cansultAction) forControlEvents:UIControlEventTouchUpInside];
    [self.buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    self.scrollView.contentSize = CGSizeMake(self.hd_width, CGRectGetMaxY(self.bottomView.frame));
    
}

- (void)cansultAction
{
    if (self.memberCansultBlock) {
        self.memberCansultBlock();
    }
}

- (void)buyAction
{
    if (self.memberBuyBlock) {
        self.memberBuyBlock(self.level);
    }
}

- (void)refreshUIWith:(MemberLevel)memberLevel
{
    self.level = memberLevel;
    
    switch (memberLevel) {
        case MemberLevel_K1:
            [self refreshMemberLevelK1];
            break;
        case MemberLevel_K2:
            [self refreshMemberLevelK2];
            break;
        case MemberLevel_K3:
            [self refreshMemberLevelK3];
            break;
        case MemberLevel_K4:
            [self refreshMemberLevelK4];
            break;
        case MemberLevel_K5:
            [self refreshMemberLevelK5];
            break;
            
        default:
            break;
    }
}

- (void)refreshMemberLevelK1
{
    self.priceLB.attributedText = [self getPriceText:@"1180元 1680元"];
    
    [self.tkscView resetWithTitle:@"一年"];
    [self.luboView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.zbkcView resetWithImage:[UIImage imageNamed:@"icon_error"]];
    [self.zbhfView resetWithImage:[UIImage imageNamed:@"icon_error"]];
    
    [self.sxxtView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.dyfwView resetWithTitle:@"网页答疑"];
    [self.dyscView resetWithTitle:@"1年"];
    [self.lxxzxxView resetWithImage:[UIImage imageNamed:@"icon_error"]];
    
    [self.sgzxxbView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.tszlView resetWithImage:[UIImage imageNamed:@"icon_error"]];
    [self.zsxxjhView resetWithImage:[UIImage imageNamed:@"icon_error"]];
    
    [self.cjzcView resetWithImage:[UIImage imageNamed:@"icon_error"]];
    [self.zjzcView resetWithImage:[UIImage imageNamed:@"icon_error"]];
    [self.zckjsView resetWithImage:[UIImage imageNamed:@"icon_error"]];
}

- (void)refreshMemberLevelK2
{
    self.priceLB.attributedText = [self getPriceText:@"2180元 2980元"];
    
    [self.tkscView resetWithTitle:@"永久"];
    [self.luboView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.zbkcView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.zbhfView resetWithImage:[UIImage imageNamed:@"icon_error"]];
    
    [self.sxxtView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.dyfwView resetWithTitle:@"QQ群答疑"];
    [self.dyscView resetWithTitle:@"2年"];
    [self.lxxzxxView resetWithImage:[UIImage imageNamed:@"icon_error"]];
    
    [self.sgzxxbView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.tszlView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.zsxxjhView resetWithImage:[UIImage imageNamed:@"icon_error"]];
    
    [self.cjzcView resetWithImage:[UIImage imageNamed:@"icon_Right"] andTitle:@"(二选一)"];
    [self.zjzcView resetWithImage:[UIImage imageNamed:@"icon_Right"] andTitle:@"(二选一)"];
    [self.zckjsView resetWithImage:[UIImage imageNamed:@"icon_error"]];
}
- (void)refreshMemberLevelK3
{
    self.priceLB.attributedText = [self getPriceText:@"2580元 3580元"];
    
    [self.tkscView resetWithTitle:@"永久"];
    [self.luboView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.zbkcView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.zbhfView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    
    [self.sxxtView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.dyfwView resetWithTitle:@"QQ群答疑"];
    [self.dyscView resetWithTitle:@"3年"];
    [self.lxxzxxView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    
    [self.sgzxxbView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.tszlView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.zsxxjhView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    
    [self.cjzcView resetWithImage:[UIImage imageNamed:@"icon_Right"] andTitle:@"(二选一)"];
    [self.zjzcView resetWithImage:[UIImage imageNamed:@"icon_Right"] andTitle:@"(二选一)"];
    [self.zckjsView resetWithImage:[UIImage imageNamed:@"icon_error"]];
}
- (void)refreshMemberLevelK4
{
    self.priceLB.attributedText = [self getPriceText:@"2980元 3980元"];
    
    [self.tkscView resetWithTitle:@"永久"];
    [self.luboView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.zbkcView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.zbhfView resetWithImage:[UIImage imageNamed:@"icon_error"]];
    
    [self.sxxtView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.dyfwView resetWithTitle:@"一对一答疑"];
    [self.dyscView resetWithTitle:@"3年"];
    [self.lxxzxxView resetWithImage:[UIImage imageNamed:@"icon_error"]];
    
    [self.sgzxxbView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.tszlView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.zsxxjhView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    
    [self.cjzcView resetWithImage:[UIImage imageNamed:@"icon_Right"] andTitle:@"(二选一)"];
    [self.zjzcView resetWithImage:[UIImage imageNamed:@"icon_Right"] andTitle:@"(二选一)"];
    [self.zckjsView resetWithImage:[UIImage imageNamed:@"icon_error"]];
}
- (void)refreshMemberLevelK5
{
    self.priceLB.attributedText = [self getPriceText:@"3580元 4980元"];
    
    [self.tkscView resetWithTitle:@"永久"];
    [self.luboView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.zbkcView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.zbhfView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    
    [self.sxxtView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.dyfwView resetWithTitle:@"一对一答疑"];
    [self.dyscView resetWithTitle:@"3年"];
    [self.lxxzxxView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    
    [self.sgzxxbView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.tszlView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    [self.zsxxjhView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
    
    [self.cjzcView resetWithImage:[UIImage imageNamed:@"icon_Right"] andTitle:@"(二选一)"];
    [self.zjzcView resetWithImage:[UIImage imageNamed:@"icon_Right"] andTitle:@"(二选一)"];
    [self.zckjsView resetWithImage:[UIImage imageNamed:@"icon_Right"]];
}

- (NSMutableAttributedString *)getPriceText:(NSString *)priceStr
{
    NSMutableAttributedString * aPriceStr = [[NSMutableAttributedString alloc]initWithString:priceStr];
    NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:UIColorFromRGB(0x999999),NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)};
    [aPriceStr setAttributes:attribute range:NSMakeRange(6, priceStr.length - 7)];
    
    return aPriceStr;
}

@end
