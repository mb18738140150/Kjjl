//
//  DredgeMemberPriceView.h
//  Accountant
//
//  Created by aaa on 2017/12/5.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    DredgeMemberPrice_noSelect,
    DredgeMemberPrice_Select,
} DredgeMemberPriceSelectType;

@interface DredgeMemberPriceView : UIView

@property (nonatomic, strong)NSDictionary * infoDic;
@property (nonatomic, strong)NSString * memberLevel;
@property (nonatomic, assign)DredgeMemberPriceSelectType selectType;
@property (nonatomic, copy)void (^MemberSelectBlock)(NSDictionary *memberLevelInfoDic);

- (instancetype)initWithFrame:(CGRect)frame andInfoDic:(NSDictionary *)infopDic;

- (void)resetView;
- (void)selectAction;
@end
