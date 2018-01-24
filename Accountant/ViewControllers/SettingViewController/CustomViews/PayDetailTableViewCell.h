//
//  PayDetailTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/11/21.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PayType_normal,
    PayType_weichat,
    PayType_alipay,
} PayType;

@interface PayDetailTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *imageV;
@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UIButton *selectBtn;
@property (nonatomic, assign)PayType payType;
@property (nonatomic, assign)BOOL isSelect;
@property (nonatomic, copy)void(^payBlock)(PayType payType);

- (void)resetUIWith:(NSDictionary *)infoDic;

@end
