//
//  PackageDetailIntroduceCell.h
//  Accountant
//
//  Created by aaa on 2018/4/27.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PackageDetailIntroduceCell : UITableViewCell

@property (nonatomic, strong)UIView * tipView;
@property (nonatomic, strong)UILabel * titleLB;

@property (nonatomic, strong)UITextView * textView;

- (void)resetWitnInfo:(NSDictionary *)infoDic;

@end
