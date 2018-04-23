//
//  PackageDetailHeadCell.h
//  Accountant
//
//  Created by aaa on 2018/4/17.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PackageDetailHeadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *packageIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *packageTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UIImageView *promiseImageView;
@property (weak, nonatomic) IBOutlet UILabel *promissLB;
@property (weak, nonatomic) IBOutlet UIImageView *postageImageView;
@property (weak, nonatomic) IBOutlet UILabel *postageLB;


@end
