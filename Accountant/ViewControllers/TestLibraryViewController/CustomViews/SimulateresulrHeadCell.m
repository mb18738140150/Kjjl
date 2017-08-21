//
//  SimulateresulrHeadCell.m
//  Accountant
//
//  Created by aaa on 2017/4/5.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "SimulateresulrHeadCell.h"
#import "UIMacro.h"
#import "CommonMacro.h"

@implementation SimulateresulrHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)resetWithInfo:(NSDictionary *)dic
{
    
    NSLog(@"%@",[dic description]);
    
    self.rightLB.text = [NSString stringWithFormat:@"%ld\\%ld", [[dic objectForKey:kRightquistionArr] count],[[dic objectForKey:kWrongquistionArr] count] + [[dic objectForKey:kRightquistionArr] count]];
    
    self.scoreLB.text = @"97";
    self.scoreLB.hidden = YES;
    self.wrongnumberLabel.text = [NSString stringWithFormat:@"%ld\\%ld", [[dic objectForKey:kWrongquistionArr] count],[[dic objectForKey:kWrongquistionArr] count] + [[dic objectForKey:kRightquistionArr] count]];
    
    CGFloat rate = [[dic objectForKey:kRightquistionArr] count] * 1.0 / ([[dic objectForKey:kWrongquistionArr] count] + [[dic objectForKey:kRightquistionArr] count]);
    if(rate >= 0.6)
    {
        self.rateLabel.text = @"不错哦!";
        self.iconImageView.image = [UIImage imageNamed:@"simulateresultGood"];
    }else
    {
        self.rateLabel.text = @"继续加油吧!";
        self.iconImageView.image = [UIImage imageNamed:@"simulateresultBad"];
    }
    
}

- (void)resetScoreWithInfo:(NSDictionary *)dic
{
    
    NSLog(@"%@",[dic description]);
    
    NSNumber * total = @0;
    NSNumber * right = @0;
    NSNumber * wrong = @0;
    if ([dic objectForKey:@"totalCount"]) {
        total = [dic objectForKey:@"totalCount"];
    }
    if ([dic objectForKey:@"rightCount"]) {
        right = [dic objectForKey:@"rightCount"];
    }
    if ([dic objectForKey:@"wrongCount"]) {
        wrong = [dic objectForKey:@"wrongCount"];
    }
    
    self.rightLB.text = [NSString stringWithFormat:@"%@\\%@", right,total];
    
    self.scoreLB.text = @"97";
    self.scoreLB.hidden = YES;
    
    self.wrongnumberLabel.text = [NSString stringWithFormat:@"%@\\%@", wrong,total];
    
    CGFloat rate = right.intValue * 1.0 / total.intValue;
    if(rate >= 0.6)
    {
        self.rateLabel.text = @"不错哦!";
        self.iconImageView.image = [UIImage imageNamed:@"simulateresultGood"];
    }else
    {
        self.rateLabel.text = @"继续加油吧!";
        self.iconImageView.image = [UIImage imageNamed:@"simulateresultBad"];
    }
    if (total.intValue == 0) {
        self.rateLabel.text = @"还没开始做模拟题呢!";
        self.iconImageView.image = [UIImage imageNamed:@"simulateresult_no"];
    }
    
}

- (NSString *)getCreatTimeStr
{
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY-MM-dd/hh:mm";
    NSString * dateStr = [formatter stringFromDate:date];
    NSString * str = [@"生成报告时间:\n" stringByAppendingString:dateStr];
    return str;
}

- (NSMutableAttributedString *)getCountAttribute:(NSDictionary *)attribute string:(NSString *)str andCount:(NSUInteger)count
{
    NSString * string = [NSString stringWithFormat:@"%ld",count];
    
    NSRange range = [str rangeOfString:string];
    
    NSMutableAttributedString * astring = [[NSMutableAttributedString alloc]initWithString:str];
    
    [astring setAttributes:attribute range:range];
    
    return astring;
}



@end
