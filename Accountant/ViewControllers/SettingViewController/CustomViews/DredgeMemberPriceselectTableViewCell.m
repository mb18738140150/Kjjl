//
//  DredgeMemberPriceselectTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/12/5.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "DredgeMemberPriceselectTableViewCell.h"
#import "DredgeMemberPriceView.h"

@interface DredgeMemberPriceselectTableViewCell ()

@property (nonatomic, strong)UIButton *lookMemberDetailBtn;
@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)NSMutableArray *dredgePaiceViewArray;

@end

@implementation DredgeMemberPriceselectTableViewCell

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetCell
{
    [self loadData];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    UILabel * dredgeLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 16, 70, 16)];
    dredgeLB.text = @"开通会员";
    dredgeLB.textColor = UIColorFromRGB(0x333333);
    dredgeLB.font = kMainFont;
    [self.contentView addSubview:dredgeLB];
    
    self.lookMemberDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lookMemberDetailBtn.frame = CGRectMake(kScreenWidth - 150, 0, 140, 48);
    [self.lookMemberDetailBtn setTitle:@"查看会员等级详情" forState:UIControlStateNormal];
    [self.lookMemberDetailBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [self.lookMemberDetailBtn setImage:[UIImage imageNamed:@"icon_gd"] forState:UIControlStateNormal];
    self.lookMemberDetailBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.lookMemberDetailBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    self.lookMemberDetailBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 96 + 15, 0, 0);
    [self.lookMemberDetailBtn addTarget:self action:@selector(lookMemberDetailAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.lookMemberDetailBtn];
    
    UIView * lineSeperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 48, kScreenWidth, 1)];
    lineSeperateView.backgroundColor = UIColorFromRGB(0xedf0f0);
    [self.contentView addSubview:lineSeperateView];
    
    self.dredgePaiceViewArray = [NSMutableArray array];
    __weak typeof(self)weakSelf = self;
    for (int i = 0; i < self.dataArray.count; i++) {
        DredgeMemberPriceView * dredgeView = [[DredgeMemberPriceView alloc]initWithFrame:CGRectMake(kScreenWidth / 2 * (i%2),50 + i/2*80 + (i/2 + 1)*10, kScreenWidth / 2, 80) andInfoDic:self.dataArray[i]];
        
        if ([[self.dataArray[i] objectForKey:kMemberLevel] isEqualToString:self.memberLevel]) {
            dredgeView.selectType = DredgeMemberPrice_Select;
        }
        
        [self.contentView addSubview:dredgeView];
        [self.dredgePaiceViewArray addObject:dredgeView];
        
        dredgeView.MemberSelectBlock = ^(NSDictionary *memberLevelInfoDic) {
            [weakSelf resetWithLevel:[memberLevelInfoDic objectForKey:@"memberLevel"]];
        };
        
    }
}

- (void)loadData
{
    self.dataArray = [[[UserManager sharedManager] getLevelDetailList] mutableCopy];
    
//    NSDictionary * k1 = @{@"realityPrice":@(1180),@"price":@(1680),@"memberLevel":@"K1",@"chaozhi":@(0)};
//    NSDictionary * k2 = @{@"realityPrice":@(2180),@"price":@(2980),@"memberLevel":@"K2",@"chaozhi":@(0)};
//    NSDictionary * k3 = @{@"realityPrice":@(2580),@"price":@(3580),@"memberLevel":@"K3",@"chaozhi":@(1)};
//    NSDictionary * k4 = @{@"realityPrice":@(2980),@"price":@(3980),@"memberLevel":@"K4",@"chaozhi":@(0)};
//    NSDictionary * k5 = @{@"realityPrice":@(3580),@"price":@(4980),@"memberLevel":@"K5",@"chaozhi":@(1)};
//    [self.dataArray addObject:k1];
//    [self.dataArray addObject:k2];
//    [self.dataArray addObject:k3];
//    [self.dataArray addObject:k4];
//    [self.dataArray addObject:k5];
}


// 选择会员级别
- (void)resetWithLevel:(NSString *)memberLevel
{
    for (DredgeMemberPriceView * dredgeView in self.dredgePaiceViewArray) {
        
        if (![[dredgeView.infoDic objectForKey:kMemberLevel] isEqualToString:memberLevel]) {
            [dredgeView resetView];
        }else
        {
            if (self.memberlevelSelectBlock) {
                self.memberlevelSelectBlock(dredgeView.infoDic);
            }
        }
    }
}


- (void)lookMemberDetailAction
{
    if (self.lookMemberDetailBlock) {
        self.lookMemberDetailBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
