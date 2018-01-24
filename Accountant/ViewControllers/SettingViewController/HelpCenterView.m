//
//  HelpCenterView.m
//  Accountant
//
//  Created by aaa on 2018/1/9.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "HelpCenterView.h"
#import "AssistantTableViewCell.h"
#import "SettingTableViewCell.h"
#define kAssistantCellID @"AssistantTableViewCellId"

@interface HelpCenterView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *telTableview;
@property (nonatomic, strong)UITableView *assistantTableView;
@property (nonatomic, strong)UILabel * tipLB;

@property (nonatomic, strong)NSMutableArray *teldataArray;
@property (nonatomic, strong)NSMutableArray *assistantArray;

@end

@implementation HelpCenterView

- (NSMutableArray *)teldataArray
{
    if (!_teldataArray) {
        _teldataArray = [NSMutableArray array];
    }
    return _teldataArray;
}

- (NSMutableArray *)assistantArray
{
    if (!_assistantArray) {
        _assistantArray = [NSMutableArray array];
    }
    return _assistantArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.teldataArray = [[UserManager sharedManager] getTelephoneList];
        self.assistantArray = [[UserManager sharedManager]getAssistantList];
        [self prepareUI];
    }
    return self;
}

- (void)resetViewWith:(HelpType)type
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (type == HelpType_tel) {
            self.tipLB.hidden = YES;
            self.telTableview.hidden = NO;
            self.assistantTableView.hidden = YES;
            
            if (self.teldataArray.count == 0) {
                self.tipLB.hidden = NO;
                self.tipLB.text = @"暂无联系热线";
            }
            
        }else
        {
            self.tipLB.hidden = YES;
            self.telTableview.hidden = YES;
            self.assistantTableView.hidden = NO;
            if (self.assistantArray.count == 0) {
                self.tipLB.hidden = NO;
                self.tipLB.text = @"暂无在线客服";
            }
        }
    });
}

- (void)prepareUI
{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.5];
    [self addSubview:backView];
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAction)];
    [backView addGestureRecognizer:backTap];
    
    NSArray * telArray = [[UserManager sharedManager] getTelephoneList];
    self.telTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, kScreenHeight - telArray.count * 50 - 50 , kScreenWidth, telArray.count * 50 ) style:UITableViewStylePlain];
    self.telTableview.backgroundColor = [UIColor whiteColor];
    self.telTableview.delegate = self;
    self.telTableview.dataSource = self;
    self.telTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.telTableview];
    
    NSArray * assistantArray = [[UserManager sharedManager] getTelephoneList];
    self.assistantTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kScreenHeight - assistantArray.count * 75 - 50 , kScreenWidth, assistantArray.count * 75 ) style:UITableViewStylePlain];
    self.assistantTableView.backgroundColor = [UIColor whiteColor];
    self.assistantTableView.delegate = self;
    self.assistantTableView.dataSource = self;
    self.assistantTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.assistantTableView registerNib:[UINib nibWithNibName:@"AssistantTableViewCell" bundle:nil] forCellReuseIdentifier:kAssistantID];
    [self addSubview:self.assistantTableView];
    
    self.tipLB = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenHeight - 50 - 30, kScreenWidth, 30)];
    self.tipLB.textAlignment = NSTextAlignmentCenter;
    self.tipLB.font = kMainFont;
    self.tipLB.backgroundColor = [UIColor whiteColor];
    self.tipLB.textColor = UIColorFromRGB(0x333333);
    [self addSubview:self.tipLB];
    
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50)];
    bottomView.backgroundColor = UIColorFromRGB(0xedf0f0);
    [self addSubview:bottomView];
    
    UIButton * telephoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    telephoneBtn.frame = CGRectMake(0, 1, (kScreenWidth - 1) / 2.0, 49);
    telephoneBtn.backgroundColor = [UIColor whiteColor];
    [telephoneBtn setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    [telephoneBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [telephoneBtn setTitle:@"热线电话" forState:UIControlStateNormal];
    telephoneBtn.titleLabel.font = kMainFont;
    [self.telTableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [bottomView addSubview:telephoneBtn];
    
    UIButton * assistantBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    assistantBtn.frame = CGRectMake(CGRectGetMaxX(telephoneBtn.frame) + 1, 1, (kScreenWidth - 1) / 2.0, 49);
    assistantBtn.backgroundColor = [UIColor whiteColor];
    [assistantBtn setImage:[UIImage imageNamed:@"icon_kefu"] forState:UIControlStateNormal];
    [assistantBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [assistantBtn setTitle:@"在线客服" forState:UIControlStateNormal];
    assistantBtn.titleLabel.font = kMainFont;
    [bottomView addSubview:assistantBtn];
    
    [telephoneBtn addTarget:self action:@selector(telephoneAction) forControlEvents:UIControlEventTouchUpInside];
    [assistantBtn addTarget:self action:@selector(assistantAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.telTableview]) {
        return [[[UserManager sharedManager] getTelephoneList] count];
    }
    return [[[UserManager sharedManager] getAssistantList] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.telTableview]) {
        NSArray * teachersArray = [[UserManager sharedManager] getTelephoneList];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
        NSString * telephoneStr = teachersArray[indexPath.row];
        
        UIView * topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        topLine.backgroundColor = UIColorFromRGB(0xedf0f0);
        [cell.contentView addSubview:topLine];
        
        UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
        titleLB.textColor = UIColorFromRGB(0x333333);
        titleLB.font = kMainFont;
        titleLB.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:titleLB];
        titleLB.text = telephoneStr;
        return cell;
    }else
    {
        NSArray * teachersArray = [[UserManager sharedManager] getAssistantList];
        AssistantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAssistantID forIndexPath:indexPath];
        NSDictionary * teacherInfo = teachersArray[indexPath.row];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[teacherInfo objectForKey:@"assistantIconUrl"]] placeholderImage:[UIImage imageNamed:@"img_tx"]];
        cell.nameLB.text = [teacherInfo objectForKey:@"assistantName"];
        
        cell.QQLB.text = [NSString stringWithFormat:@"QQ:%@", [teacherInfo objectForKey:@"assistantQQ"]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.telTableview]) {
        if (self.telephoneBlock) {
            self.telephoneBlock(self.teldataArray[indexPath.row]);
        }
    }else
    {
        if (self.cansultBlock) {
            self.cansultBlock(self.assistantArray[indexPath.row]);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.assistantTableView]) {
        return 75;
    }
    return 50;
}

- (void)dismissAction
{
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (void)telephoneAction
{
    [self resetViewWith:HelpType_tel];
}

- (void)assistantAction
{
    [self resetViewWith:HelpType_assistant];
}


@end
