//
//  PayView.h
//  Accountant
//
//  Created by aaa on 2017/12/5.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayView : UIView

@property (nonatomic, strong)UILabel * priceLB;
@property (nonatomic, strong)UIButton *payBtn;

@property (nonatomic, strong)NSString * price;

@property (nonatomic, copy)void(^payBlock)();

@end
