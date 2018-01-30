//
//  CourseTableViewCell.m
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CourseTableViewCell.h"
#import "UIMacro.h"
#import "MainViewMacro.h"
#import "UIImageView+WebCache.h"
#import "NotificaitonMacro.h"
#import "CommonMacro.h"

@interface CourseTableViewCell ()

@property (nonatomic,strong) UIImageView            *courseImage1;
@property (nonatomic,strong) UIImageView            *courseImage2;
@property (nonatomic,strong) UILabel                *courseLabel1;
@property (nonatomic,strong) UILabel                *courseLabel2;

@property (nonatomic,strong) NSArray                *courseInfoArray;

@end

@implementation CourseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)removeAllSubViews
{
    [self.courseImage1 removeFromSuperview];
    [self.courseImage2 removeFromSuperview];
    [self.courseLabel1 removeFromSuperview];
    [self.courseLabel2 removeFromSuperview];
}

- (void)resetCellContentWithOneCourseInfo:(NSArray *)infoArray
{
    [self removeAllSubViews];
    
    self.courseInfoArray = infoArray;
    
    
    
    CGFloat startx = kCellEdgeOfCourseImage;
    self.courseImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(startx, 10, kImageWidthOfCourse, kImageHeightOfCourse)];
    self.courseLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(self.courseImage1.frame.origin.x, self.courseImage1.frame.origin.y + kImageHeightOfCourse + 10, kImageWidthOfCourse, 20)];
    
    NSDictionary *info1 = [infoArray objectAtIndex:0];
    [self.courseImage1 sd_setImageWithURL:[NSURL URLWithString:[info1 objectForKey:kCourseCover]]];
    
    self.courseLabel1.font = [UIFont systemFontOfSize:14];
    self.courseLabel1.text = [info1 objectForKey:kCourseName];
    
    self.courseImage1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(course1Tap)];
    [self.courseImage1 addGestureRecognizer:tap1];
    
    if (self.isVideoCourse) {
        self.courseImage1.hd_x = 0;
        self.courseImage1.hd_width = kImageWidthOfCourseOfVideo;
        self.courseImage1.hd_height = kImageHeightOfCourseOfVideo;
        self.courseLabel1.hd_x = 0;
        self.courseLabel1.hd_y = CGRectGetMaxY(self.courseImage1.frame) + 10;
        self.courseLabel1.hd_width = kImageWidthOfCourseOfVideo;
        self.courseLabel1.font = [UIFont systemFontOfSize:12];
    }
    
    [self addSubview:self.courseImage1];
    [self addSubview:self.courseLabel1];
}

- (void)resetCellContentWithTwoCourseInfo:(NSArray *)infoArray
{
    [self removeAllSubViews];
    
    self.courseInfoArray = infoArray;
    
    CGFloat startx = kCellEdgeOfCourseImage;
    self.courseImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(startx, 10, kImageWidthOfCourse, kImageHeightOfCourse)];
    self.courseImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2 + startx, 10, kImageWidthOfCourse, kImageHeightOfCourse)];
    self.courseLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(self.courseImage1.frame.origin.x, self.courseImage1.frame.origin.y + kImageHeightOfCourse + 10, kImageWidthOfCourse, 20)];
    self.courseLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.courseImage2.frame.origin.x, self.courseImage2.frame.origin.y + kImageHeightOfCourse + 10, kImageWidthOfCourse, 20)];
    
    NSDictionary *info1 = [infoArray objectAtIndex:0];
    NSDictionary *info2 = [infoArray objectAtIndex:1];
    [self.courseImage1 sd_setImageWithURL:[NSURL URLWithString:[info1 objectForKey:kCourseCover]]];
    [self.courseImage2 sd_setImageWithURL:[NSURL URLWithString:[info2 objectForKey:kCourseCover]]];
    
    
/*    self.courseImage1.backgroundColor = [UIColor grayColor];
    self.courseImage2.backgroundColor = [UIColor greenColor];
    self.courseLabel1.backgroundColor = [UIColor redColor];
    self.courseLabel2.backgroundColor = [UIColor blackColor];*/
    
    self.courseLabel1.font = [UIFont systemFontOfSize:14];
    self.courseLabel2.font = [UIFont systemFontOfSize:14];
    
    self.courseLabel1.text = [info1 objectForKey:kCourseName];
    self.courseLabel2.text = [info2 objectForKey:kCourseName];
    
    self.courseImage1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(course1Tap)];
    [self.courseImage1 addGestureRecognizer:tap1];
    
    self.courseImage2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(course2Tap)];
    [self.courseImage2 addGestureRecognizer:tap2];
    
    if (self.isVideoCourse) {
        self.courseImage1.hd_x = 0;
        self.courseImage1.hd_height = kImageHeightOfCourseOfVideo;
        self.courseImage1.hd_width = kImageWidthOfCourseOfVideo;
        self.courseLabel1.hd_x = 0;
        self.courseLabel1.hd_y = CGRectGetMaxY(self.courseImage1.frame) + 10;
        self.courseLabel1.hd_width = kImageWidthOfCourseOfVideo;
        
        self.courseImage2.frame = CGRectMake(CGRectGetMaxX(self.courseImage1.frame) + 20, 10, kImageWidthOfCourseOfVideo, kImageHeightOfCourseOfVideo);
        self.courseLabel2.frame = CGRectMake(self.courseImage2.frame.origin.x, self.courseImage2.frame.origin.y + kImageHeightOfCourseOfVideo + 10, kImageWidthOfCourseOfVideo, 20);
        
        self.courseLabel1.font = [UIFont systemFontOfSize:12];
        self.courseLabel2.font = [UIFont systemFontOfSize:12];
    }
    
    [self addSubview:self.courseImage1];
    [self addSubview:self.courseImage2];
    [self addSubview:self.courseLabel2];
    [self addSubview:self.courseLabel1];
}

#pragma mark - ui getter
- (void)course1Tap
{
    NSDictionary *info = [self.courseInfoArray objectAtIndex:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfCourseClick object:info];
}

- (void)course2Tap
{
    NSDictionary *info = [self.courseInfoArray objectAtIndex:1];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfCourseClick object:info];
}




@end
