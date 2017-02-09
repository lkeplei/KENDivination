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

@property (assign) BOOL isPurchased;
@property (nonatomic, strong) NSArray* resourceArray;
@property (nonatomic, strong) EBPurchase* purchase;

@end

@implementation KENViewDirection

@synthesize viewDirection = _viewDirection;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypeDirection;
        
        // Create an instance of EBPurchase.
        _purchase = [[EBPurchase alloc] init];
        _purchase.delegate = self;
        
        _isPurchased = NO; // default.
    }
    return self;
}

#pragma mark - others
-(UIImage*)setViewTitleImage{
    return [[KENModel shareModel] getDirectionTitle];
}

-(void)showView{
    _resourceArray = [[KENModel shareModel] getDirectionPaiZhen];
    
    for (int i = 0; i < [_resourceArray count]; i++) {
        NSDictionary* res = [_resourceArray objectAtIndex:i];
        UIImage* img = [UIImage imageNamed:[res objectForKey:KDicKeyImg]];
        UIImage* imgSec = [UIImage imageNamed:[res objectForKey:KDicKeyImgSec]];
        
        UIButton* pingBtn = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                              image:img
                                           imagesec:imgSec
                                             target:self
                                             action:@selector(btnArrayClicked:)];
        
        if (![[KENDataManager getDataByKey:KUserDefaultJieMi] boolValue] && [[res objectForKey:KDicKeyJiaMi] boolValue]) {
            [pingBtn setImage:[UIImage imageNamed:@"direction_paizhen_jiami.png"] forState:UIControlStateNormal];
            [pingBtn setImage:[UIImage imageNamed:@"direction_paizhen_jiami.png"] forState:UIControlStateHighlighted];
            [pingBtn setImage:[UIImage imageNamed:@"direction_paizhen_jiami.png"] forState:UIControlStateSelected];
        }
        pingBtn.center = CGPointMake(kFullScreenAdaptiveX(60.f + 100.f * (i % 3)), 131 + 110 * (i / 3));
        pingBtn.tag = KDirectionBtnTagBase + i;
        [self.contentView addSubview:pingBtn];
    }
    
    //重置广告
    [SysDelegate.viewController showAdmobBanner];
}

#pragma mark - btn clicked
-(void)btnArrayClicked:(UIButton*)button{
    NSDictionary* res = [_resourceArray objectAtIndex:button.tag - KDirectionBtnTagBase];
    if (![[KENDataManager getDataByKey:KUserDefaultJieMi] boolValue] && [[res objectForKey:KDicKeyJiaMi] boolValue]) {
        
        [KENDataManager setDataByKey:[NSNumber numberWithBool:YES] forkey:KUserDefaultJieMi];
        [SysDelegate.viewController clearAllAd];
        
//        [_purchase requestProduct:SUB_PRODUCT_ID];
    } else {
        NSInteger paizhen = [[res objectForKey:KDicKeyPaiZhen] intValue];
        [[[KENModel shareModel] memoryData] setMemoryPaiZhen:paizhen];
        
        //按键声音
        [[KENModel shareModel] playVoiceByType:KENVoiceAnJian];
        
        [self pushView:[SysDelegate.viewController getView:KENViewTypePaiZhen] animatedType:KENTypeNull];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (_purchase.validProduct != nil) {
        if (buttonIndex == 1){
            [_purchase purchaseProduct:_purchase.validProduct];
        } else if (buttonIndex == 2){
            [_purchase restorePurchase];
        }
    }
}

#pragma mark - SKPayment
-(void) requestedProduct:(EBPurchase*)ebp identifier:(NSString*)productId name:(NSString*)productName price:(NSString*)productPrice description:(NSString*)productDescription
{
    if (productPrice != nil)    {
        UIAlertView *unavailAlert = [[UIAlertView alloc] initWithTitle:nil
                                                               message:[NSString stringWithFormat:MyLocal(@"purchase_content"),
                                                                        [productPrice floatValue]]
                                                              delegate:self cancelButtonTitle:MyLocal(@"cancel")
                                                     otherButtonTitles:MyLocal(@"purchase"), MyLocal(@"restore"), nil];
        [unavailAlert show];
    } else {
        UIAlertView *unavailAlert = [[UIAlertView alloc] initWithTitle:@"Not Available" message:@"This In-App Purchase item is not available in the App Store at this time. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [unavailAlert show];
    }
}

-(void)successfulPurchase:(EBPurchase*)ebp identifier:(NSString*)productId receipt:(NSData*)transactionReceipt{
    if (!_isPurchased){
        _isPurchased = YES;
        [KENDataManager setDataByKey:[NSNumber numberWithBool:YES] forkey:KUserDefaultJieMi];
        [SysDelegate.viewController clearAllAd];
        
        for (int i = 0; i < [_resourceArray count]; i++) {
            NSDictionary* res = [_resourceArray objectAtIndex:i];
            if ([[res objectForKey:KDicKeyJiaMi] boolValue]) {
                UIButton* button = (UIButton*)[self.contentView viewWithTag:KDirectionBtnTagBase + i];
                [button setImage:nil forState:UIControlStateNormal];
                [button setImage:nil forState:UIControlStateHighlighted];
                [button setImage:nil forState:UIControlStateSelected];
            }
        }
    }
}

-(void)failedPurchase:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage{
    //@"Either you cancelled the request or Apple reported a transaction error. Please try again later, or contact the app's customer support for assistance."
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:MyLocal(@"purchase_title") message:MyLocal(@"purchase_failed")
                                                         delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
}

-(void)incompleteRestore:(EBPurchase*)ebp{
    //@"A prior purchase transaction could not be found. To restore the purchased product, tap the Buy button. Paid customers will NOT be charged again, but the purchase will be restored."
    UIAlertView *restoreAlert = [[UIAlertView alloc] initWithTitle:MyLocal(@"purchase_title") message:MyLocal(@"restore_incomplete")
                                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [restoreAlert show];
}

-(void)failedRestore:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage{
    //@"Either you cancelled the request or your prior purchase could not be restored. Please try again later, or contact the app's customer support for assistance."
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:MyLocal(@"purchase_title") message:MyLocal(@"restore_failed")
                                                         delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
}

@end
