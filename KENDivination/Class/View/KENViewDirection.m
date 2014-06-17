//
//  KENViewDirection.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-14.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewDirection.h"
#import "KENModel.h"
#import "KENConfig.h"
#import "KENUtils.h"
#import "KENDataManager.h"

#define KDirectionBtnTagBase        (400)

@interface KENViewDirection ()

@property (nonatomic, strong) NSArray* resourceArray;

@end

@implementation KENViewDirection

@synthesize viewDirection = _viewDirection;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypeDirection;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    // 监听购买结果
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

#pragma mark - others
-(UIImage*)setViewTitleImage{
    return [[KENModel shareModel] getDirectionTitle];
}

-(void)showView{
    _resourceArray = [[KENModel shareModel] getDirectionPaiZhen];
    
    for (int i = 0; i < [_resourceArray count]; i++) {
        NSDictionary* res = [_resourceArray objectAtIndex:i];
        UIImage* img = nil;
        UIImage* imgSec = nil;
        
        if (![[KENDataManager getDataByKey:KUserDefaultJieMi] boolValue] && [[res objectForKey:KDicKeyJiaMi] boolValue]) {
            img = [UIImage imageNamed:@"direction_paizhen_jiami.png"];
            imgSec = [UIImage imageNamed:@"direction_paizhen_jiami.png"];
        } else {
            img = [UIImage imageNamed:[res objectForKey:KDicKeyImg]];
            imgSec = [UIImage imageNamed:[res objectForKey:KDicKeyImgSec]];
        }
        
        UIButton* pingBtn = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                              image:img
                                           imagesec:imgSec
                                             target:self
                                             action:@selector(btnArrayClicked:)];
        pingBtn.center = CGPointMake(60 + 100 * (i % 3), 131 + 110 * (i / 3));
        pingBtn.tag = KDirectionBtnTagBase + i;
        [self.contentView addSubview:pingBtn];
    }
    
    //重置广告
    [SysDelegate.viewController resetAd];
}

#pragma mark - btn clicked
-(void)btnArrayClicked:(UIButton*)button{
    NSDictionary* res = [_resourceArray objectAtIndex:button.tag - KDirectionBtnTagBase];
    if (![[KENDataManager getDataByKey:KUserDefaultJieMi] boolValue] && [[res objectForKey:KDicKeyJiaMi] boolValue]) {
        if ([SKPaymentQueue canMakePayments]) {
            [self getProductInfo];
        } else {
            NSLog(@"失败，用户禁止应用内付费购买.");
        }
    } else {
        NSInteger paizhen = [[res objectForKey:KDicKeyPaiZhen] intValue];
        [[[KENModel shareModel] memoryData] setMemoryPaiZhen:paizhen];
        
        //按键声音
        [[KENModel shareModel] playVoiceByType:KENVoiceAnJian];
        
        [self pushView:[SysDelegate.viewController getView:KENViewTypePaiZhen] animatedType:KENTypeNull];
    }
}

#pragma mark - SKPayment
- (void)getProductInfo {
    NSSet* set = [NSSet setWithArray:[[NSArray alloc] initWithObjects:@[@"teamqi.zhanbu.jiesuo"], nil]];
    SKProductsRequest* request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}

//// 以上查询的回调函数
//- (void)productsRequest:(SKProductsRequest*)request didReceiveResponse:(SKProductsResponse*)response {
//    NSArray *myProduct = response.products;
//    if (myProduct.count == 0) {
//        NSLog(@"无法获取产品信息，购买失败。");
//        return;
//    }
//    SKPayment * payment = [SKPayment paymentWithProduct:myProduct[0]];
//    [[SKPaymentQueue defaultQueue] addPayment:payment];
//}
//
//- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
//    for (SKPaymentTransaction *transaction in transactions)
//    {
//        switch (transaction.transactionState)
//        {
//            case SKPaymentTransactionStatePurchased://交易完成
//                NSLog(@"transactionIdentifier = %@", transaction.transactionIdentifier);
//                [self completeTransaction:transaction];
//                break;
//            case SKPaymentTransactionStateFailed://交易失败
//                [self failedTransaction:transaction];
//                break;
//            case SKPaymentTransactionStateRestored://已经购买过该商品
//                [self restoreTransaction:transaction];
//                break;
//            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
//                NSLog(@"商品添加进列表");
//                break;
//            default:
//                break;
//        }
//    }
//}
//
//- (void)completeTransaction:(SKPaymentTransaction *)transaction {
//    // Your application should implement these two methods.
//    NSString * productIdentifier = transaction.payment.productIdentifier;
////    NSString * receipt = [transaction.transactionReceipt base64EncodedString];
//    if ([productIdentifier length] > 0) {
//        // 向自己的服务器验证购买凭证
//    }
//    // Remove the transaction from the payment queue.
//    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
//    
//}
//
//- (void)failedTransaction:(SKPaymentTransaction *)transaction {
//    if(transaction.error.code != SKErrorPaymentCancelled) {
//        NSLog(@"购买失败");
//    } else {
//        NSLog(@"用户取消交易");
//    }
//    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
//}
//
//- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
//    // 对于已购商品，处理恢复购买的逻辑
//    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
//}











//<SKProductsRequestDelegate> 请求协议
//收到的产品信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", [myProduct count]);
    // populate UI
    for(SKProduct *product in myProduct){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
    }
    NSLog(@"---------发送购买请求------------");
    SKPayment * payment = [SKPayment paymentWithProduct:myProduct[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
- (void)requestProUpgradeProductData{
    NSLog(@"------请求升级数据---------");
    NSSet *productIdentifiers = [NSSet setWithObject:@"com.productid"];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
}
//弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"-------弹出错误信息----------");
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
    delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
}

-(void) requestDidFinish:(SKRequest *)request{
    NSLog(@"----------反馈信息结束--------------");
}

-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"-----PurchasedTransaction----");
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
}

//<SKPaymentTransactionObserver> 千万不要忘记绑定，代码如下：
//----监听购买结果
//[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{
    NSLog(@"-----paymentQueue--------");
    for (SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState){
            case SKPaymentTransactionStatePurchased://交易完成
            {
                [self completeTransaction:transaction];
                NSLog(@"-----交易完成 --------");
                NSLog(@"不允许程序内付费购买");
                UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                   message:@"Himi说你购买成功啦～娃哈哈"
                                                                  delegate:nil cancelButtonTitle:NSLocalizedString(@"Close（关闭）",nil) otherButtonTitles:nil];
                [alerView show];
            }
            break;
                
            case SKPaymentTransactionStateFailed://交易失败
            {
                [self failedTransaction:transaction];
                NSLog(@"-----交易失败 --------");
                UIAlertView *alerView2 = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                    message:@"Himi说你购买失败，请重新尝试购买～"
                                                                   delegate:nil cancelButtonTitle:NSLocalizedString(@"Close（关闭）",nil) otherButtonTitles:nil];
                
                [alerView2 show];
            }
            break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self restoreTransaction:transaction];
                NSLog(@"-----已经购买过该商品 --------");
            case SKPaymentTransactionStatePurchasing: //商品添加进列表
                NSLog(@"-----商品添加进列表 --------");
            break;
            default:
            break;
        }
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"-----completeTransaction--------");
// Your application should implement these two methods.
    NSString *product = transaction.payment.productIdentifier;
    if ([product length] > 0) {
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0) {
            [self recordTransaction:bookid];
            [self provideContent:bookid];
        }
    }
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

//记录交易
-(void)recordTransaction:(NSString *)product{
    NSLog(@"-----记录交易--------");
}

//处理下载内容
-(void)provideContent:(NSString *)product{
    NSLog(@"-----下载--------");
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"失败");
    if (transaction.error.code != SKErrorPaymentCancelled){
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{

}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@" 交易恢复处理");
}

-(void)paymentQueue:(SKPaymentQueue *)paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"-------paymentQueue----");
}

#pragma mark connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    switch([(NSHTTPURLResponse *)response statusCode]) {
        case 200:
        case 206:
            break;
        case 304:
            break;
        case 400:
            break;
        case 404:
            break;
        case 416:
            break;
        case 403:
            break;
        case 401:
        case 500:
            break;
        default:
            break;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"test");
}
@end
