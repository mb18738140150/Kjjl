//
//  StudyPlanConditionTableViewCell.h
//  Accountant
//
//  Created by aaa on 2017/12/8.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    StudyPlanContition_education,
    StudyPlanContition_age,
    StudyPlanContition_workLimit,
    StudyPlanContition_certificate,
    StudyPlanContition_workStatus,
    StudyPlanContition_professionalTitle,
    StudyPlanContition_vocation,
    StudyPlanContition_interest,
} StudyPlanContition_Type;

typedef enum : NSUInteger {
    ConditionCellType_condition,
    ConditionCellType_name,
    ConditionCellType_gender,
} ConditionCellType;

@interface StudyPlanConditionTableViewCell : UITableViewCell

@property (nonatomic, copy)void (^GenderSelectBlock)(NSString * gender);
@property (nonatomic, copy)void (^nameBlock)(NSString * name);
@property (nonatomic, copy)void (^ConditionSelecBlock)(NSDictionary * conditionInfo);

@property (nonatomic, strong)NSDictionary * selectInfoDic;

@property (nonatomic, assign)ConditionCellType conditionCellType;
@property (nonatomic, assign)StudyPlanContition_Type conditionType;

- (void)resetWithInfo:(NSDictionary *)infoDic;

@end
