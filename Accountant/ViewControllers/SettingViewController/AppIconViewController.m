//
//  AppIconViewController.m
//  Accountant
//
//  Created by aaa on 2018/5/11.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "AppIconViewController.h"
#import "BuyCoinTableViewCell.h"
#import "BuyCoinFootTableViewCell.h"
#import "BuyCoinHeadTableViewCell.h"
#import <StoreKit/StoreKit.h>
#import "MBProgressHUD.h"

#define kCellId @"BuyCoinTableViewCell"
#define kHeadCellID @"BuyCoinHeadTableViewCell"
#define kFootCellID @"BuyCoinFootTableViewCell"

#define kJinbi_6    @"com.tianming.kjjl_jinbi_6"
#define kJinbi_50    @"com.tianming.kjjl_jinbi_50"
#define kJinbi_198    @"com.tianming.kjjl_jinbi_198"
#define kJinbi_298    @"com.tianming.kjjl_jinbi_298"
#define kJinbi_1998    @"com.tianming.kjjl_jinbi_1998"
#define kJinbi_3998    @"com.tianming.kjjl_jinbi_3998"

@interface AppIconViewController ()<UITableViewDelegate,UITableViewDataSource,UserModule_VerifyInAppPurchase,UserModule_MyCoin,SKPaymentTransactionObserver, SKProductsRequestDelegate>
{
    int buyType;
    MBProgressHUD * hud;
}
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSArray * dataArray;
@property (nonatomic, strong)NSIndexPath *currentIndex;
@property (nonatomic, strong)NSDictionary * selectInfoDic;

@end

@implementation AppIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [self loadData];
    [self navigationViewSetup];
    [self prepareUI];
    
}
- (void)navigationViewSetup
{
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, 64)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"购买金币";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //    self.navigationController.navigationBarHidden = YES;
    
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"public-返回"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData
{
    self.dataArray = @[@{@"name":@"6金币",@"price":@"6元",@"id":kJinbi_6},@{@"name":@"50金币",@"price":@"50元",@"id":kJinbi_50},@{@"name":@"198金币",@"price":@"198元",@"id":kJinbi_198},@{@"name":@"298金币",@"price":@"298元",@"id":kJinbi_298},@{@"name":@"1998金币",@"price":@"1998元",@"id":kJinbi_1998},@{@"name":@"3998金币",@"price":@"3998元",@"id":kJinbi_3998}];
    [SVProgressHUD show];
    [[UserManager sharedManager] didRequestMyCoinsWithInfo:@{} withNotifiedObject:self];
}

- (void)prepareUI
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:kCellId bundle:nil] forCellReuseIdentifier:kCellId];
    [self.tableView registerNib:[UINib nibWithNibName:kHeadCellID bundle:nil] forCellReuseIdentifier:kHeadCellID];
    [self.tableView registerNib:[UINib nibWithNibName:kFootCellID bundle:nil] forCellReuseIdentifier:kFootCellID];
    [self.view addSubview:self.tableView];
    
    UIButton * buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame = CGRectMake(0, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 50, kScreenWidth, 50);
    buyBtn.backgroundColor = UIRGBColor(255, 78, 0);
    [buyBtn setTitle:@"直接购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:buyBtn];
    [buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section) {
        case 0:
            count = 1;
            break;
        case 1:
            count = self.dataArray.count;
            break;
        case 2:
            count = 1;
            break;
            
        default:
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BuyCoinHeadTableViewCell * headCell = [tableView dequeueReusableCellWithIdentifier:kHeadCellID forIndexPath:indexPath];
        headCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [headCell resetWith:[[UserManager sharedManager] getMyGoldCoins]];
        return headCell;
    }else if (indexPath.section == 2)
    {
        BuyCoinFootTableViewCell * footCell = [tableView dequeueReusableCellWithIdentifier:kFootCellID forIndexPath:indexPath];
         footCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [footCell resetUI];
        return footCell;
    }else
    {
        BuyCoinTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
        if (self.currentIndex.section == indexPath.section && indexPath.row == self.currentIndex.row) {
            cell.isSelect = YES;
        }else
        {
            cell.isSelect = NO;
        }
        [cell resetWithInfo:self.dataArray[indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    switch (indexPath.section) {
        case 0:
            height = 80;
            break;
        case 1:
            height = 48;
            break;
        case 2:
            height = 100;
            break;
            
        default:
            break;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        self.currentIndex = indexPath;
        self.selectInfoDic = [self.dataArray objectAtIndex:indexPath.row];
        [self.tableView reloadData];
        NSLog(@"self.selectInfoDic = %@", self.selectInfoDic);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 8)];
        headView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [view addSubview:headView];
        
        UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(headView.frame) + 13, kScreenWidth - 20, 15)];
        titleLB.text = @"选择金币数额";
        titleLB.textColor = UIRGBColor(102, 102, 102);
        titleLB.font = kMainFont;
        [view addSubview:titleLB];
        
        return view;
    }else
    {
        return nil;
    }
}

- (void)buyAction
{
    if (!self.selectInfoDic) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择购买金币数量" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else
    {
        [self productFunc:[self.selectInfoDic objectForKey:@"id"]];
    }
}
#pragma mark - verifiInAppProtocol delegate
- (void)didRequestMyCoinSuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView reloadData];
}

- (void)didRequestMyCoinFailed:(NSString *)failedInfo
{
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestInAppPurchaseSuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView reloadData];
}

- (void)didRequestInAppPurchaseFailed:(NSString *)failedInfo
{
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - In_App Purchase
- (void)productFunc:(NSString * )productId
{
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    if ([SKPaymentQueue canMakePayments]) {
        [self requestProductData:productId];
    }else
    {
        [hud hide:YES];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不允许程序内付费购买" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
//请求商品
- (void)requestProductData:(NSString *)type{
    NSLog(@"-------------请求对应的产品信息----------------");
    NSArray *product = [[NSArray alloc] initWithObjects:type, nil];
    
    
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    
}

//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
        NSLog(@"--------------没有商品------------------");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有该商品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%d",[product count]);
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        
        if ([pro.productIdentifier isEqualToString:[self.selectInfoDic objectForKey:@"id"]]) {
            p = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    NSLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"------------------错误-----------------:%@", error);
    
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
    
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------");
    [hud hide:YES];
}

//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    [hud hide:YES];
    for(SKPaymentTransaction *tran in transaction){
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
            {
                NSLog(@"交易完成");
                [SVProgressHUD show];
//                [self verifyTransaction:tran];
                
                [self completeTransaction:tran];
            }
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:{
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"交易失败" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
                
            }
                break;
            default:
                break;
        }
    }
}

- (void)verifyTransaction:(SKPaymentTransaction *)transaction
{
    
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];

    if(!receipt){

    }
    
    
    NSDictionary *requestContents = @{
                                      @"ReceiptData": [receipt base64EncodedStringWithOptions:0]
                                      };
    [SVProgressHUD show];
    [[UserManager sharedManager] didRequestVerifyInAppPurchaseWithInfo:requestContents withNotifiedObject:self];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

// 交易验证，放在后台进行验证
//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");
    
    //交易验证
    // 从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
    
    if(!receipt){
        
    }
    
    NSError *error;
    NSDictionary *requestContents = @{
                                      @"receipt-data": [receipt base64EncodedStringWithOptions:0]
                                      };
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
    
    if (!requestData) { /* ... Handle error ... */ }
    
    //In the test environment, use https://sandbox.itunes.apple.com/verifyReceipt
    //In the real environment, use https://buy.itunes.apple.com/verifyReceipt
    // Create a POST request with the receipt data.
    NSURL *storeURL = [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    // Make a connection to the iTunes Store on a background queue.
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   /* ... Handle error ... */
                               } else {
                                   NSError *error;
                                   NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   if (jsonResponse) { /* ... Handle error ...*/
                                       NSLog(@"%@", [jsonResponse description]);
                                       if([jsonResponse[@"status"] intValue]==0){
                                           
                                           
                                           NSLog(@"购买成功！");
                                           NSDictionary *dicReceipt= jsonResponse[@"receipt"];
                                           NSDictionary *dicInApp=[dicReceipt[@"in_app"] firstObject];
                                           NSString *productIdentifier= dicInApp[@"product_id"];//读取产品标识
                                           //如果是消耗品则记录购买数量，非消耗品则记录是否购买过
                                           
                                           //在此处对购买记录进行存储，可以存储到开发商的服务器端
                                           [self storePayrecord:productIdentifier];
                                           
                                           
                                       }else if([jsonResponse[@"status"] intValue]==21007){
                                           NSLog(@" 收据信息是测试用（sandbox），但却被发送到产品环境中验证");
                                           
                                           [self completeTransactionSandbox:transaction];
                                       }else
                                       {
                                           NSLog(@"验证失败");
                                       }
                                       
                                   }
                                   /* ... Send a response back to the device ... */
                                   //Parse the Response
                               }
                           }];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)completeTransactionSandbox:(SKPaymentTransaction *)transaction
{
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
    
    if(!receipt){
        
    }
    
    NSError *error;
    NSDictionary *requestContents = @{
                                      @"receipt-data": [receipt base64EncodedStringWithOptions:0]
                                      };
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
    
    if (!requestData) { /* ... Handle error ... */ }
    NSURL *storeURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   /* ... Handle error ... */
                               } else {
                                   NSError *error;
                                   NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   if (jsonResponse) {
                                       NSLog(@"%@", [jsonResponse description]);
                                       if([jsonResponse[@"status"] intValue]==0){
                                           
                                           NSLog(@"购买成功！");
                                           NSDictionary *dicReceipt= jsonResponse[@"receipt"];
                                           NSDictionary *dicInApp=[dicReceipt[@"in_app"] firstObject];
                                           NSString *productIdentifier= dicInApp[@"product_id"];//读取产品标识
                                           //如果是消耗品则记录购买数量，非消耗品则记录是否购买过
                                           //在此处对购买记录进行存储，可以存储到开发商的服务器端
                                           [self storePayrecord:productIdentifier];
                                           
                                           
                                       }else
                                       {
                                           NSLog(@"验证失败");
                                       }
                                       
                                   }
                               }
                           }];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)storePayrecord:(NSString *)productIdentifier
{
    NSNumber * count = @0;
    if ([productIdentifier isEqualToString:kJinbi_6]) {
        count = @6;
    }else if ([productIdentifier isEqualToString:kJinbi_50])
    {
        count = @50;
    }else if ([productIdentifier isEqualToString:kJinbi_198])
    {
        count = @198;
    }
    else if ([productIdentifier isEqualToString:kJinbi_298])
    {
        count = @298;
    }else if ([productIdentifier isEqualToString:kJinbi_1998])
    {
        count = @1998;
    }else if ([productIdentifier isEqualToString:kJinbi_3998])
    {
        count = @3998;
    }
    
    NSDictionary *requestContents = @{
                                      @"ReceiptData":count
                                      };
    [[UserManager sharedManager] didRequestVerifyInAppPurchaseWithInfo:requestContents withNotifiedObject:self];
}

- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
