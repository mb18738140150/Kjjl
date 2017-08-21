//
//  FailView.h
//  tiku
//
//  Created by aaa on 2017/6/1.
//  Copyright © 2017年 ytx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FailType_NoData,
    FailType_NoNetWork,
}FailType;

@interface FailView : UIView

@property (nonatomic, assign)FailType *failType;
@property (nonatomic, strong)UIImageView * imageView;
@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UIButton *refreshBT;
@property (nonatomic, copy)void(^refreshBlock)();

@end
