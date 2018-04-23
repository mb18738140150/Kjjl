//
//  CourseSectionTableViewCell.m
//  Accountant
//
//  Created by aaa on 2018/1/27.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "CourseSectionTableViewCell.h"
#import "CourseTableViewCell.h"

#define kCoursetableViewcellID  @"CoursetableViewcellID"

#define kCellHeight (kCellHeightOfCourseOfVideo +  20)

@interface CourseSectionTableViewCell ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSArray * dataArray;
@property (nonatomic, strong)NSMutableDictionary * infoDic;
@property (nonatomic, strong)UIView * tipView;


@end

@implementation CourseSectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    [self.contentView removeAllSubviews];
    
    self.tipView = [[UIView alloc]initWithFrame:CGRectMake(self.hd_width / 2 - 100, 8, 200, 1)];
    _tipView.backgroundColor = UIColorFromRGB(0xcccccc);
    [self.contentView addSubview:_tipView];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_tipView.frame) + 6, 0, self.hd_width, 16)];
    self.titleLB.font = [UIFont systemFontOfSize:12];
    self.titleLB.backgroundColor = [UIColor whiteColor];
    self.titleLB.textAlignment = NSTextAlignmentCenter;
    self.titleLB.textColor = UIColorFromRGB(0x666666);
    [self.contentView addSubview:self.titleLB];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(23, CGRectGetMaxY(_tipView.frame) + 11, self.hd_width - 20, 100) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.tableView];
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[CourseTableViewCell class] forCellReuseIdentifier:kCoursetableViewcellID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
}

- (void)resetWithInfoDic:(NSDictionary *)infoDic
{
    [self prepareUI];
    self.infoDic = infoDic;
    
    NSLog(@"%@", [infoDic description]);
    
    self.dataArray = [infoDic objectForKey:kCourseCategorySecondCourseInfos];
    self.titleLB.text = [infoDic objectForKey:kCourseSecondName];
    if (self.titleLB.text.length == 0) {
        self.titleLB.text = [infoDic objectForKey:kCourseCategoryName];
    }
    [self resetPropertyUI];
    
    int courseCount = self.dataArray.count;
    int number = [self getRow:infoDic];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (number > 3) {
            self.tableView.hd_height = (number - 1) * kCellHeight + 30;
        }else
        {
            self.tableView.hd_height = number * kCellHeight;
        }
    });
    [self.tableView reloadData];
}

- (void)resetPropertyUI
{
    CGFloat textWidth = [self.titleLB.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.titleLB.hd_height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLB.font} context:nil].size.width;
    
    self.titleLB.frame = CGRectMake((self.hd_width - textWidth - 20) / 2, self.titleLB.hd_y, textWidth + 20, self.titleLB.hd_height);
    self.tipView.frame = CGRectMake((self.hd_width - textWidth - 60) / 2, self.tipView.hd_y, textWidth + 60, self.tipView.hd_height);
}


- (int )getRow:(NSDictionary *)infoDic
{
    int courseCount = self.dataArray.count;
    int number = 0;
    if (courseCount%2 == 0) {
        if (courseCount/2 > 3) {
            if ([[self.infoDic objectForKey:kIsFold] intValue]) {
                return  4;
            }
            return courseCount/2 + 1;
        }else
        {
            return courseCount/2;
        }
    }else{
        if (courseCount/2 + 1 > 3) {
            if ([[self.infoDic objectForKey:kIsFold] intValue]) {
                return 4;
            }
            return courseCount/2 + 1 + 1;
        }else
        {
            return courseCount/2 + 1;
        }
    }
    return number;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   
    int number = [self getRow:@{}];
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *array = self.dataArray;
    if (array.count == 0) {
        return nil;
    }
    else{
        
        int courseCount = self.dataArray.count;
        int number = 0;
        if (courseCount%2 == 0) {
            number = courseCount/2;
        }else
        {
            number = courseCount/2 + 1;
        }
        
        if ((indexPath.row == 3 && [[self.infoDic objectForKey:kIsFold] intValue]) || (indexPath.row > 2 && ![[self.infoDic objectForKey:kIsFold] intValue] && indexPath.row == number)  ) {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
            [cell.contentView removeAllSubviews];
            UIButton * titleLB = [UIButton buttonWithType:UIButtonTypeCustom];
            titleLB.backgroundColor = UIColorFromRGB(0xf2f2f2);
            titleLB.frame = CGRectMake(0, 0, self.tableView.hd_width - 20, 30);
            if (indexPath.row == 3 && [[self.infoDic objectForKey:kIsFold] intValue]) {
                [titleLB setTitle:@"查看更多" forState:UIControlStateNormal];
            }else
            {
                [titleLB setTitle:@"收起" forState:UIControlStateNormal];
            }
            titleLB.titleLabel.font = kMainFont;
            [titleLB setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [titleLB addTarget:self action:@selector(foldAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:titleLB];
            return cell;
        }else
        {
            CourseTableViewCell * courseCell = [tableView dequeueReusableCellWithIdentifier:kCoursetableViewcellID forIndexPath:indexPath];
            courseCell.isVideoCourse = YES;
            NSArray *allCourseInfo = array;
            NSArray *subarray;
            if ((indexPath.row+1) * 2 <= allCourseInfo.count) {
                if (indexPath.row == 0) {
                    subarray = [allCourseInfo subarrayWithRange:NSMakeRange(0, 2)];
                }else{
                    subarray = [allCourseInfo subarrayWithRange:NSMakeRange(2*indexPath.row, 2)];
                }
                
                [courseCell resetCellContentWithTwoCourseInfo:subarray];
            }else{
                if (indexPath.row == 0) {
                    subarray = [allCourseInfo subarrayWithRange:NSMakeRange(0, 1)];
                }else{
                    subarray = [allCourseInfo subarrayWithRange:NSMakeRange(2*indexPath.row, 1)];
                }
                [courseCell resetCellContentWithOneCourseInfo:subarray];
            }
            courseCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return courseCell;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

+ (CGFloat)getCellHeightWith:(NSDictionary *)infoDic andIsFold:(BOOL)isFold
{
    NSArray * dataArray = [infoDic objectForKey:kCourseCategorySecondCourseInfos];
    
    int courseCount = dataArray.count;
    if (courseCount%2 == 0) {
        if (courseCount/2 > 3) {
            if ([[infoDic objectForKey:kIsFold] intValue]) {
                return 3 * kCellHeight + 70;
            }
            return (courseCount/2) * kCellHeight + 70;
        }else
        {
            return courseCount/2 * kCellHeight + 30;
        }
    }else{
        if (courseCount/2 + 1 > 3) {
            if ([[infoDic objectForKey:kIsFold] intValue]) {
                return 3 * kCellHeight + 70;
            }
            return (courseCount/2 + 1) * kCellHeight + 70;
        }else
        {
            return (courseCount/2 + 1) * kCellHeight + 30;
        }
    }
    
    return 0;
}

- (void)foldAction
{
    if ([[self.infoDic objectForKey:kIsFold] intValue]) {
        [self.infoDic setObject:@(0) forKey:kIsFold];
    }else
    {
        [self.infoDic setObject:@(1) forKey:kIsFold];
    }
    if (self.FoldBlock) {
        self.FoldBlock(self.infoDic);
    }
}

@end
