//
//  AccountantTests.m
//  AccountantTests
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HttpRequestManager.h"
#import "DateUtility.h"
#import "NSString+MD5.h"
#import "WriteOperations.h"
#import "CommonMacro.h"
#import "DBManager.h"

@interface AccountantTests : XCTestCase

@end

@implementation AccountantTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
//    [DateUtility getDateShowString:@"2016/3/3 18:39:07"];
    
    
    NSLog(@"%@",[@"1231231312312" MD5]);
    NSLog(@"%@",[@"ascgrt" MD5]);
    [[DBManager sharedManager] intialDB];
/*    [[DBManager sharedManager] saveDownloadInfo:@{kCourseID:@(123),
                                                  kCourseName:@"test",
                                                  kCoursePath:@"www.http.com",
                                                  kCourseCover:@"aaaa.png",
                                                  kChapterId:@(123),
                                                  kChapterName:@"chapter",
                                                  kChapterSort:@(1),
                                                  kChapterPath:@"chapterPaht",
                                                  kVideoId:@(222),
                                                  kVideoName:@"videoName",
                                                  kVideoSort:@(999),
                                                  kVideoPath:@"videoPath"}];*/
//    NSLog(@"------%d",[[DBManager sharedManager] isVideoDownload:@(387)]);
    NSLog(@"%@",[DateUtility getCurrentFormatDateString]);
    NSLog(@"%@",[DateUtility getDateIdString]);
//    NSLog(@"write result %d",b);
    
    
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendString:@"123456789"];
    [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
    NSLog(@"%@",str);
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
