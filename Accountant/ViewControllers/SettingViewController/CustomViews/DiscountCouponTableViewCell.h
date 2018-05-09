//
//  DiscountCouponTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/12/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DiscountCouponUserState_normal,
    DiscountCouponUserState_haveUseed,
    DiscountCouponUserState_expire,
} DiscountCouponState;

typedef enum : NSUInteger {
    DiscountCoupon_canUse,
    DiscountCoupon_cannotUse,
} DiscountCouponUseState;

@interface DiscountCouponTableViewCell : UITableViewCell

@property (nonatomic, assign)DiscountCouponState useState;
@property (nonatomic, assign)DiscountCouponUseState canUse;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *activityLB;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLB;
@property (weak, nonatomic) IBOutlet UILabel *discountPriceLB;
@property (weak, nonatomic) IBOutlet UILabel *manPriceLB;

@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UIView *xuxianView;

@property (weak, nonatomic) IBOutlet UIImageView *useStateImageView;

- (void)resetWithInfo:(NSDictionary *)infoDic;
@end
