//
//  QuestionViewTableDataSource.m
//  Accountant
//
//  Created by aaa on 2017/3/2.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "QuestionViewTableDataSource.h"
#import "QuestionTableViewCell.h"
#import "UIUtility.h"


//定义一个block
typedef BOOL(^RunloopBlock)(void);

@interface QuestionViewTableDataSource()

// 存放任务的数组
@property (nonatomic, strong)NSMutableArray *tasks;
// 任务标记
@property (nonatomic, strong)NSMutableArray * taskKeys;
// 最大任务数
@property (nonatomic, assign)NSUInteger max;

// timer
@property (nonatomic, strong)NSTimer * timer;

@end


@implementation QuestionViewTableDataSource

-(void)_timerFiredMethod{
    // 不作任何事
}

- (instancetype)init
{
    if (self = [super init]) {
        _max = 4;
        _tasks = [NSMutableArray array];
        _taskKeys = [NSMutableArray array];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(_timerFiredMethod) userInfo:nil repeats:YES];;
        //注册监听
        [self addRunloopObserver];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.questionsInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"questionCell";
    QuestionTableViewCell *cell = (QuestionTableViewCell *)[UIUtility getCellWithCellName:cellName inTableView:tableView andCellClass:[QuestionTableViewCell class]];
    cell.isCalculatedDate = NO;
    cell.isShowFullContent = NO;
    cell.isQuestionDetail = YES;
    
    __weak QuestionViewTableDataSource * weakSelf = self;
    
    cell.MoreReplyBlock = ^{
        if (weakSelf.MoreReplyBlock) {
            weakSelf.MoreReplyBlock([[[self.questionsInfoArray objectAtIndex:indexPath.row] objectForKey:kQuestionId] intValue]);
        }
    };
    
    NSLog(@"%@",[[self.questionsInfoArray objectAtIndex:indexPath.row] description] );
    
    [self addTask:^BOOL{
        
        [cell resetCellWithInfo:[weakSelf.questionsInfoArray objectAtIndex:indexPath.row]];
        return YES;
    } withKey:indexPath];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)addTask:(RunloopBlock)unit withKey:(id)key{
    [self.tasks addObject:unit];
    [self.taskKeys addObject:key];
    // 保证之前没有显示出来的任务，不在浪费时间加载
    if (self.tasks.count > self.max) {
        [self.tasks removeObjectAtIndex:0];
        [self.taskKeys removeObjectAtIndex:0];
    }
}


static void CallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    QuestionViewTableDataSource * sourse = (__bridge QuestionViewTableDataSource *)(info);
    if (sourse.tasks.count == 0) {
        return;
    }
    BOOL result = NO;
    while (result == NO && sourse.tasks.count) {
        // 取出任务
        RunloopBlock unit = sourse.tasks.firstObject;
        // 执行任务
        result = unit();
        // 拿掉第一个任务
        [sourse.tasks removeObjectAtIndex:0];
        [sourse.taskKeys removeObjectAtIndex:0];
    }
    
}
- (void)addRunloopObserver
{
    // 获取当前的RunLoop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    // 定义一个context
    CFRunLoopObserverContext context = {
        0,
        (__bridge void*)(self),
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    // 定义一个观察者
    static CFRunLoopObserverRef defaultModeObserver;
    // 创建观察者
    defaultModeObserver = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &CallBack, &context);
    // 添加当前RunLoop的观察者
    CFRunLoopAddObserver(runloop, defaultModeObserver, kCFRunLoopCommonModes);
    
    CFRelease(defaultModeObserver);
    
}

@end
